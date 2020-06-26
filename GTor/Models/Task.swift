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
    var uid: String
    var title: String
    var note: String
    var dueDate: Date?
    var satisfaction: Double
    var isSatisfied: Bool
    var linkedGoalsIds: [UUID]
    var importance: Importance
}


extension Task {
    static var dummy = Task(uid: AuthService.userId!, title: "Title1", note: "Note1", satisfaction: 0, isSatisfied: false, linkedGoalsIds: [], importance: .important)
}
