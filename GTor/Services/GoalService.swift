//
//  GoalService.swift
//  GTor
//
//  Created by Safwan Saigh on 14/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation


class GoalService: ObservableObject {
    @Published var goals: [Goal] = []
    
    
    func getGoalsFromDatabase(uid: String){
        FirestoreService.shared.getDocuments(collection: .goals, documentId: uid) { (result: Result<[Goal], Error>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let goals):
                DispatchQueue.main.async { self.goals = goals }
            }
        }
    }
    
    func saveGoalsToDatabase(goal: Goal, completion: @escaping (Result<Void, Error>)->()){
        FirestoreService.shared.saveDocument(collection: .goals, documentId: "", model: goal) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success():
                completion(.success(()))
            }
        }
    }
}
