//
//  TaskService.swift
//  GTor
//
//  Created by Safwan Saigh on 14/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation
import Firebase

enum TaskErrors: Error {
    case noTitle, noCategory, noImportance//TODO
}

extension TaskErrors: LocalizedError {//TODO
    var errorDescription: String? {
        switch self {
        case .noCategory:
            return "The category is misssing."
        case .noTitle:
            return "The title is missing."
        case .noImportance:
            return "The importance of is misssing."
        }
    }
}


class TaskService: ObservableObject {
    @Published var tasks: [Task] = []
    static let shared = TaskService()
    
    
    
    
}
