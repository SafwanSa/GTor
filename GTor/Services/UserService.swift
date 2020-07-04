//
//  UserService.swift
//  GTor
//
//  Created by Safwan Saigh on 14/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation
import FirebaseAuth


enum AuthState{
    case signIn, signOut, udefined
}


class UserService: ObservableObject {
    @Published var user: User = .dummy
    @Published var authState: AuthState = .udefined
    static let shared = UserService()
    
    
    var authStateDidChangeHandler: AuthStateDidChangeListenerHandle?
    
    func configureAuthStateDidChangeListner(completion: @escaping (Bool) -> ()) {
        if authStateDidChangeHandler != nil {
            completion(false)
            return
        }
        
        authStateDidChangeHandler = Auth.auth().addStateDidChangeListener({ (_ , user) in
            guard let user = user else {
                DispatchQueue.main.async {
                    self.authState = .signOut
                    self.user = .dummy
                    completion(true)
                }
                return
            }
            DispatchQueue.main.async {
                self.authState = .signIn
            }
            self.retreiveUser(uid: user.uid) { (result) in
                switch result {
                case .failure(_ ):
                    completion(false)
                case .success(()):
                    completion(true)
                }
            }
        })
    }
    
    
    
    
    private func retreiveUser(uid: String, completion: @escaping (Result<Void, Error>) -> ()){
        FirestoreService.shared.getDocument(collection: FirestoreKeys.Collection.users, documentId: uid) { (result: Result<User, Error>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let user):
                DispatchQueue.main.async {
                    self.user = user
                    TaskService.shared.getTasksFromDatabase { (result) in
                        switch result {
                        case .failure(let error):
                            completion(.failure(error))
                        case .success(()):
                            GoalService.shared.getGoalsFromDatabase { (result) in
                                switch result {
                                case .failure(let error):
                                    completion(.failure(error))
                                case .success(()):
                                    completion(.success(()))
                                }
                            }
                            CategoryService.shared.getCategoriesFromDatabase { (result) in
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
        }
    }
}






extension User {
    static let dummy = User(uid: "", name: "Dummy Name", email: "")
}
