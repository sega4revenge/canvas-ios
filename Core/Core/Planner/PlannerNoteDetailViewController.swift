//
// This file is part of Canvas.
// Copyright (C) 2020-present  Instructure, Inc.
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

import Foundation

public class PlannerNoteDetailViewController: UIViewController {

    @IBOutlet weak var dateLabel: DynamicLabel!
    @IBOutlet weak var titleLabel: DynamicLabel!
    @IBOutlet weak var detailsLabel: DynamicLabel!
    var plannable: Plannable!

    public static func create(plannable: Plannable) -> PlannerNoteDetailViewController {
        let vc = loadFromStoryboard()
        vc.plannable = plannable
        return vc
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        title = NSLocalizedString("To Do", bundle: .core, comment: "")
        titleLabel.text = plannable.title
        dateLabel.text = plannable.date.flatMap {
            DateFormatter.localizedString(from: $0, dateStyle: .medium, timeStyle: .short)
        }
        detailsLabel.text = plannable.details
    }
}
