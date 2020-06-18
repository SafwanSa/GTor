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
    
    func getTasksFromDatabase(){
          FirestoreService.shared.getDocuments(collection: .tasks, documentId: AuthService.userId ?? "") { (result: Result<[Task], Error>) in
              switch result {
              case .failure(let error):
                  print(error.localizedDescription)
              case .success(let tasks):
                  DispatchQueue.main.async { self.tasks = tasks
                    print(self.tasks[0].id)
                }
              }
          }
      }
      
      func saveTasksToDatabase(task: Task, completion: @escaping (Result<Void, Error>)->()){
          FirestoreService.shared.saveDocument(collection: .tasks, documentId: task.id.description, model: task) { result in
              switch result {
              case .failure(let error):
                  completion(.failure(error))
              case .success():
                  completion(.success(()))
              }
          }
      }
    
    
    func saveTask(task: Task, completion: @escaping (Result<Void, Error>)->()) {
           validateTask(task: task) { (result) in
               switch result {
               case .failure(let error):
                   completion(.failure(error))
               case .success(()):
                   self.saveTasksToDatabase(task: task) { (result) in
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
       
       func validateTask(task: Task, completion: @escaping (Result<Void, Error>)->()) {
            if task.title.isEmpty {
               completion(.failure(GoalErrors.noTitle))
           } else {
               completion(.success(()))
           }
       }
    
    func deleteTask(task: Task, completion: @escaping (Result<Void, Error>)->()) {
        FirestoreService.shared.deleteDocument(collection: .tasks, documentId: task.id.description) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(()):
                completion(.success(()))
            }
        }
    }
    
}
