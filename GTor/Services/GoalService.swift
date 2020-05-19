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
    
    func getGoalsFromDatabase(){
        FirestoreService.shared.getDocuments(collection: .goals, documentId: AuthService.userId ?? "") { (result: Result<[Goal], Error>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let goals):
                DispatchQueue.main.async { self.goals = goals }
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
        if goal.categories?.count == 0 && !goal.isSubGoal {
            completion(.failure(GoalErrors.noCategory))
        } else if goal.title!.isEmpty {
            completion(.failure(GoalErrors.noTitle))
        } else if !goal.isDecomposed && goal.importance == Importance.none{
            completion(.failure(GoalErrors.noImportance))
        } else {
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
    
    func updateSubGoals(goal: Goal, completion: @escaping (Result<Void, Error>)->()) {
        FirestoreService.shared.updateDocument(collection: .goals, documentId: goal.id.description, field: "subGoals", newData: goal.subGoals!) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(()):
                completion(.success(()))
            }
        }
    }
    
    func updateGoal(goal: Goal, completion: @escaping (Result<Void, Error>)->()) {
        validateGoal(goal: goal) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(()):
                self.saveGoal(goal: goal) { (result) in
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
}
