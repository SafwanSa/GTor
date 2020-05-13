//
//  Goal.swift
//  GTor
//
//  Created by Safwan Saigh on 14/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation

struct Goal: Codable, Identifiable {
    let id = UUID()
    var isDecomposed: Bool
    var title: String
    var note: String
    var importance: Int
    var satisfaction: Double
    var dueDate: Date
    var categories: [Category]
    var subGoals: [Goal]
    var tasks: [Task]
}
