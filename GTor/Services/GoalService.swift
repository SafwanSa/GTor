//
//  GoalService.swift
//  GTor
//
//  Created by Safwan Saigh on 14/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation

enum GoalErrors: Error {
    case noTitle, noCategory, noImportance
}

extension GoalErrors: LocalizedError {
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


class GoalService: ObservableObject {
    @Published var goals: [Goal] = []
    static let shared = GoalService()
    
    func getSubGoals(mainGoal: Goal) -> [Goal] {
        return goals.filter {$0.mid == mainGoal.id}
    }
    
    func getMainGoals() -> [Goal] {
        return goals.filter {$0.mid == nil}
    }
    
    func getTasks(goal: Goal) -> [Task] {
        return TaskService.shared.tasks.filter {$0.linkedGoalsIds.contains(goal.id)}
    }
    
    func getGoalsFromDatabase(completion: @escaping (Result<Void, Error>) -> ()){
        FirestoreService.shared.getDocuments(collection: .goals, documentId: UserService.shared.user.uid) { (result: Result<[Goal], Error>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let goals):
                DispatchQueue.main.async {
                    self.goals = goals
                    completion(.success(()))
                }
            }
        }
    }
    
    func saveGoalsToDatabase(goal: Goal, completion: @escaping (Result<Void, Error>)->()){
        FirestoreService.shared.saveDocument(collection: .goals, documentId: goal.id.description, model: goal) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success():
                completion(.success(()))
            }
        }
    }
    
    func saveGoal(goal: Goal, completion: @escaping (Result<Void, Error>)->()) {
        validateGoal(goal: goal) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(()):
                self.saveGoalsToDatabase(goal: goal) { (result) in
                    switch result {
                    case .failure(let error):
                        completion(.failure(error))
                    case .success(()):
                        completion(.success(()))
                    }
                }
                
            }
        }
    }
    
    func validateGoal(goal: Goal, completion: @escaping (Result<Void, Error>)->()) {
        if goal.categories.count == 0 && !goal.isSubGoal {
            completion(.failure(GoalErrors.noCategory))
        } else if goal.title.isEmpty {
            completion(.failure(GoalErrors.noTitle))
        }/* else if !goal.isDecomposed && goal.importance == Importance.none{
            completion(.failure(GoalErrors.noImportance))
        } */else {
            completion(.success(()))
        }
    }
    
    
    func deleteGoal(goal: Goal, completion: @escaping (Result<Void, Error>)->()) {
        FirestoreService.shared.deleteDocument(collection: .goals, documentId: goal.id.description) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(()):
                completion(.success(()))
            }
        }
    }
}
