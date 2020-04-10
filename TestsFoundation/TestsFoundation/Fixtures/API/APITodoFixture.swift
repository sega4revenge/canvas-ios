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

import Foundation
@testable import Core

extension APITodo {
    public static func make(
        type: TodoType = .submitting,
        ignore: URL = URL(string: "https://lms.flexidata.vn/api/v1/users/self/todo_ignore/1")!,
        ignore_permanently: URL = URL(string: "https://lms.flexidata.vn/api/v1/users/self/todo_ignore/1")!,
        html_url: URL = URL(string: "https://lms.flexidata.vn/api/v1/courses/1/assignments/1")!,
        needs_grading_count: UInt? = nil,
        assignment: APIAssignment = .make(),
        context_type: String = "Course",
        course_id: ID? = "1",
        group_id: ID? = nil
    ) -> APITodo {
        return APITodo(
            type: type,
            ignore: ignore,
            ignore_permanently: ignore_permanently,
            html_url: html_url,
            needs_grading_count: needs_grading_count,
            assignment: assignment,
            context_type: context_type,
            course_id: course_id,
            group_id: group_id
        )
    }
}
