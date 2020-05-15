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
    var uid: String
    var title: String
    var note: String
    var importance: Importance
    var satisfaction: Double
    var dueDate: Date?
    var categories: [Category]
    var subGoals: [Goal]
    var isDecomposed: Bool {
        !subGoals.isEmpty
    }
}

extension Goal {
    static var dummy: Goal = .init(uid: "xiflrj8ydNZDfkPahfkLEja5e702", title: "Goal1", note: "note1", importance: .important, satisfaction: 0, dueDate: Date(), categories: [], subGoals: [
        .init(uid: "", title: "Sub-Goal1", note: "Sub-Note1", importance: .notImportant, satisfaction: 0, dueDate: Date(), categories: [], subGoals: [])
    ])
}
