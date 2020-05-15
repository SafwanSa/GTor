//
//  SybGoal.swift
//  GTor
//
//  Created by Safwan Saigh on 15/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation

struct SubGoal: Codable, Identifiable {
    var id = UUID()
    var uid: String?
    var title: String?
    var note: String?
    var importance: Importance?
    var satisfaction: Double?
    var dueDate: Date?
}
