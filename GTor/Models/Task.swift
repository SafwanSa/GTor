//
//  Task.swift
//  GTor
//
//  Created by Safwan Saigh on 14/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation

struct Task: Codable, Identifiable {
    let id = UUID()
    var title: String
    var note: String
    var dueDate: Date
    var isDone: Bool
}
