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
    
    var opacity: Double {
        switch self {
        case .important:
            return 0.5
        case .veryImportant:
            return 1
        case .notImportant:
            return 0.2
        case .none:
            return 0
        }
    }
}

struct Goal: Codable, Identifiable {
    var id = UUID()
    var uid: String?
    var title: String?
    var note: String?
    var importance: Importance?
    var satisfaction: Double?
    var dueDate: Date?
    var categories: [Category]?
    var subGoals: [Goal]?
    var isDecomposed: Bool?
}

extension Goal {
    static var dummy: Goal = .init(uid: "xiflrj8ydNZDfkPahfkLEja5e702", title: "Goal1", note: "note1", importance: .veryImportant, satisfaction: 0, dueDate: Date(), categories: [.init(name: "Category")], subGoals: [
        .init(title: "Sub-Goal", note: "Sub-Note", importance: .notImportant, satisfaction: 0)
    ])
}
