//
//  Task.swift
//  GTor
//
//  Created by Safwan Saigh on 14/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation

struct Task: Codable, Identifiable, Equatable, Hashable {
    var id = UUID()
    var uid: String?
    var title: String
    var note: String?
    var dueDate: Date?
    var satisfaction: Double?
    var isSatisfied: Bool?
    var linkedGoals: [Goal]?
}


extension Task {
    static var dummy = Task(title: "Title1", note: "Note1", satisfaction: 0, isSatisfied: false, linkedGoals: [])
}
