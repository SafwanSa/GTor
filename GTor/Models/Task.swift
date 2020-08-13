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
    var time: Date?
    var satisfaction: Double
    var isSatisfied: Bool
    var linkedGoalsIds: [UUID]
    var importance: Priority
}


extension Task {
    static var dummy = Task(uid: UserService.shared.user.uid, title: "Title1", note: "Note1", dueDate: Date(), satisfaction: 0, isSatisfied: false, linkedGoalsIds: [], importance: .normal)
}
