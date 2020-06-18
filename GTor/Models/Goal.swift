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
    case none = 0
    
    var description: String {
        switch self {
        case .important:
            return "Important"
        case .veryImportant:
            return "Very Important"
        case .notImportant:
            return "Not Important"
        case .none:
            return ""
        }
    }
    
    var value: Double {
        switch self {
        case .veryImportant:
            return 1.0
        case .important:
            return 0.6
        case .notImportant:
            return 0.3
        case .none:
            return 0
        }
    }
    
}

struct Goal: Equatable, Codable, Identifiable, Hashable {
    var id = UUID()
    var uid: String
    var title: String
    var note: String?
    var isSubGoal: Bool
    var importance: Importance
    var satisfaction: Double
    var dueDate: Date?
    var categories: [Category]
    var subGoals: [Goal]?
    var isDecomposed: Bool
    var tasks: [Task]
    
    static func stringToImportance(importance: String)->Importance {
        switch importance {
        case "Very Important":
            return .veryImportant
        case "Important":
            return .important
        case "Not Important":
            return .notImportant
        default:
            return .none
        }
    }
}

extension Goal {
    static var dummy: Goal = .init(uid: "xiflrj8ydNZDfkPahfkLEja5e702", title: "Goal1", note: "note1", isSubGoal: false, importance: .important, satisfaction: 0, dueDate: Date(), categories: [.init(name: "Category")], subGoals: [
        .init(uid: "xiflrj8ydNZDfkPahfkLEja5e702", title: "SubGoal1", isSubGoal: true, importance: .important, satisfaction: 0, categories: [], isDecomposed: false, tasks: [])
    ], isDecomposed: true, tasks: [])
        
}
