//
//  Goal.swift
//  GTor
//
//  Created by Safwan Saigh on 14/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation

enum Importance: Int, Codable {
    case notImportant = 1
    case important = 2
    case veryImportant = 3
}

struct Goal: Codable, Identifiable {
    let id = UUID()
    var title: String
    var note: String
    var importance: Importance
    var satisfaction: Double
    var dueDate: Date?
    var categories: [Category]
    var subGoals: [Goal]
    var tasks: [Task]
    var isDecomposed: Bool {
        !subGoals.isEmpty
    }
}
