//
// This file is part of Canvas.
// Copyright (C) 2019-present  Instructure, Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
//

import UIKit
import Core

protocol PageListViewProtocol: ErrorViewController, ColoredNavViewProtocol {
    func update(isLoading: Bool)
}

class PageListViewController: UIViewController, PageListViewProtocol {
    @IBOutlet weak var emptyLabel: DynamicLabel!
    @IBOutlet weak var frontPageView: UIView!
    @IBOutlet weak var frontPageTitleLabel: DynamicLabel!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!

    var color: UIColor?
    var presenter: PageListPresenter?
    var titleSubtitleView: TitleSubtitleView = TitleSubtitleView.create()
    var showedFirstPage: Bool = false

    static func create(env: AppEnvironment = .shared, context: Context) -> PageListViewController {
        let view = loadFromStoryboard()
        view.presenter = PageListPresenter(env: env, view: view, context: context)
        return view
    }

    func update(isLoading: Bool) {
        tableView?.reloadData()

        let isEmpty = presenter?.pages.isEmpty == true && presenter?.frontPage.isEmpty == true
        if isEmpty && !isLoading {
            emptyLabel?.text = NSLocalizedString("There are no pages to display.", bundle: .student, comment: "")
            emptyLabel?.textColor = .named(.textDarkest)
            emptyLabel?.isHidden = false
        } else {
            emptyLabel?.isHidden = true
        }

        if !isLoading && !isEmpty && !showedFirstPage {
            showedFirstPage = true
            if UIApplication.shared.keyWindow?.traitCollection.horizontalSizeClass == .regular {
                if let frontPage = presenter?.frontPage.first {
                    presenter?.select(frontPage, from: self)
                } else if let page = presenter?.pages.first {
                    presenter?.select(page, from: self)
                }
            }
        }

        if !isEmpty || !isLoading {
            loadingView?.stopAnimating()
            tableView?.refreshControl?.endRefreshing()
            view.setNeedsLayout()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let headerView = tableView.tableHeaderView else { return }
        var height: CGFloat

        if let frontPage = presenter?.frontPage.first {
            frontPageTitleLabel.text = frontPage.title
            frontPageView.isHidden = false
            height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        } else {
            frontPageView.isHidden = true
            height = 0
        }

        if headerView.frame.size.height != height {
            headerView.frame.size.height = height
            tableView.tableHeaderView = headerView
            view.setNeedsLayout()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTitleViewInNavbar(title: NSLocalizedString("Pages", bundle: .student, comment: ""))
        loadingView?.color = Brand.shared.primary.ensureContrast(against: .named(.white))
        loadingView.isHidden = true

        let gestureRecogizer = UITapGestureRecognizer(target: self, action: #selector(frontPageTapped))
        frontPageView.addGestureRecognizer(gestureRecogizer)
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)

        tableView?.refreshControl = refresh
        tableView?.separatorColor = .named(.borderMedium)
        tableView.delegate = self
        tableView.dataSource = self

        frontPageView.accessibilityIdentifier = "pages.list.front-page-row"
        let layer = frontPageView.layer
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset.height = 1
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.35
        layer.cornerRadius = 4

        presenter?.viewIsReady()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView?.selectRow(at: nil, animated: false, scrollPosition: .none)
        presenter?.viewDidAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewDidDisappear()
    }

    @objc func frontPageTapped() {
        guard let page = presenter?.frontPage.first else { return }
        presenter?.select(page, from: self)
    }

    @objc func refresh(_ control: UIRefreshControl) {
        presenter?.pages.refresh(force: true)
        presenter?.frontPage.refresh(force: true)
    }
}

extension PageListViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.pages.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(PageListCell.self, for: indexPath)
        guard let page = presenter?.pages[indexPath.row] else { return cell }

        cell.accessibilityIdentifier = "pages.list.page.row-\(indexPath.row)"
        cell.update(page: page, color: color)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let page = presenter?.pages[indexPath.row] else { return }
        presenter?.select(page, from: self)
    }
}

extension PageListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isBottomReached() {
            presenter?.pages.getNextPage()
        }
    }
}