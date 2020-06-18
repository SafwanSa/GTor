//
//  Goal.swift
//  GTor
//
//  Created by Safwan Saigh on 14/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation

enum Importance: String, Codable, CaseIterable{
    case notImportant = "Not Important"
    case important = "Important"
    case veryImportant = "Very Important"
    case none = ""
    
    
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
    var note: String
    var isSubGoal: Bool
    var importance: Importance
    var satisfaction: Double
    var dueDate: Date?
    var categories: [Category]
    var subGoals: [Goal]?
    var isDecomposed: Bool
    var tasks: [Task]
}

extension Goal {
    static var dummy: Goal = .init(uid: "xiflrj8ydNZDfkPahfkLEja5e702", title: "Goal1", note: "note1", isSubGoal: false, importance: .important, satisfaction: 0, dueDate: Date(), categories: [.init(name: "Category")], subGoals: [
        .init(uid: "xiflrj8ydNZDfkPahfkLEja5e702", title: "SubGoal1", note: "", isSubGoal: true, importance: .important, satisfaction: 0, categories: [], isDecomposed: false, tasks: [])
    ], isDecomposed: true, tasks: [])
        
}
