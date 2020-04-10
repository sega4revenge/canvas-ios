//
// This file is part of Canvas.
// Copyright (C) 2018-present  Instructure, Inc.
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

private class Placeholder {}

public extension Bundle {
    @objc static let core = Bundle(for: Placeholder.self)

    static let studentBundleID = "vn.flexidata.lms.student"
    static let teacherBundleID = "vn.flexidata.lms.teacher"
    static let parentBundleID = "vn.flexidata.lms.parent"

    static let coreBundleID = "vn.flexidata.lms.core"

    static let studentUITestsBundleID = "vn.flexidata.lms.StudentUITests.xctrunner"
    static let teacherUITestsBundleID = "vn.flexidata.lms.TeacherUITests.xctrunner"
    static let parentUITestsBundleID = "vn.flexidata.lms.ParentUITests.xctrunner"

    static let studentE2ETestsBundleID = "vn.flexidata.lms.StudentE2ETests.xctrunner"
    static let teacherE2ETestsBundleID = "vn.flexidata.lms.TeacherE2ETests.xctrunner"
    static let parentE2ETestsBundleID = "vn.flexidata.lms.ParentE2ETests.xctrunner"

    func appGroupID(bundleID: String? = nil) -> String? {
        if (bundleID ?? bundleIdentifier)?.hasPrefix(Bundle.studentBundleID) == true {
            return "group.\(Bundle.studentBundleID)"
        }
        return nil
    }

    var isStudentApp: Bool { bundleIdentifier == Bundle.studentBundleID || isStudentTestsRunner }
    var isTeacherApp: Bool { bundleIdentifier == Bundle.teacherBundleID || isTeacherTestsRunner }
    var isParentApp: Bool { bundleIdentifier == Bundle.parentBundleID || isParentTestsRunner }
    var isStudentTestsRunner: Bool { [Bundle.studentUITestsBundleID, Bundle.studentE2ETestsBundleID].contains(bundleIdentifier) }
    var isTeacherTestsRunner: Bool { [Bundle.teacherUITestsBundleID, Bundle.teacherE2ETestsBundleID].contains(bundleIdentifier) }
    var isParentTestsRunner: Bool { [Bundle.parentUITestsBundleID, Bundle.parentE2ETestsBundleID].contains(bundleIdentifier) }
    var testTargetBundleID: String? {
        if isStudentTestsRunner {
            return Bundle.studentBundleID
        } else if isTeacherTestsRunner {
            return Bundle.teacherBundleID
        } else if isParentTestsRunner {
            return Bundle.parentBundleID
        } else {
            return bundleIdentifier
        }
    }
    static var isExtension: Bool { Bundle.main.bundleURL.pathExtension == "appex" }
}
