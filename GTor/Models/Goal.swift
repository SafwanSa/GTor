//
//  Goal.swift
//  GTor
//
//  Created by Safwan Saigh on 14/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation

enum Priority: String, Codable, CaseIterable{
    case low = "Not Important"
    case normal = "Important"
    case high = "Very Important"
    case none = ""
    
    
    var value: Double {
        switch self {
        case .high:
            return 3.0
        case .normal:
            return 2.0
        case .low:
            return 1.0
        case .none:
            return 0
        }
    }
    
}

struct Goal: Equatable, Codable, Identifiable, Hashable {
    var id = UUID()
    var uid: String
    var title: String
    var note: String
    var isSubGoal: Bool
    var importance: Priority
    var satisfaction: Double
    var dueDate: Date?
    var categories: [Category]
    var isDecomposed: Bool
    var mid: UUID?
}

extension Goal {
    static var dummy: Goal = .init(uid: UserService.shared.user.uid, title: "Goal1", note: "Note1", isSubGoal: false, importance: .none, satisfaction: 0, categories: [], isDecomposed: true)
    static var empty: Goal = .init(uid: UserService.shared.user.uid, title: "", note: "", isSubGoal: false, importance: .none, satisfaction: 0, categories: [], isDecomposed: true)
}
