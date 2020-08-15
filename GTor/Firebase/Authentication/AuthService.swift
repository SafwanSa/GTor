//
//  AuthService.swift
//  GTor
//
//  Created by Safwan Saigh on 14/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthService: ObservableObject {
    static var shared = AuthService()
    
    
    func createUser(name: String, gender: Gender, email: String, password: String, completion: @escaping (Result<Void, Error>)->()){
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            var newError:NSError
            if let err = error {
                newError = err as NSError
                var authError: AuthError?
                switch newError.code {
                    case 17008:
                        authError = .invalidEmail
                    case 17007:
                        authError = .emailAlreadyInUse
                    case 17034:
                        authError = .missingEmail
                    case 17026:
                        authError = .weakPassword
                    case 17010:
                        authError = .tooManyRequests
                    default:
                        authError = .unknownError
                }
                completion(.failure(authError!))
                return
            }
            
            guard let _ = result?.user, let result = result else {
                completion(.failure(error!))
                return
            }
            
            let user = User(uid: result.user.uid, name: name, gender: gender , email: email)
            FirestoreService.shared.saveDocument(collection: FirestoreKeys.Collection.users, documentId: user.uid, model: user) { completion($0) }
            
            let categoriesData: [Category] = [
                .init(uid: result.user.uid, name: NSLocalizedString("work", comment: ""), colorId: 0),
                .init(uid: result.user.uid, name: NSLocalizedString("study", comment: ""), colorId: 1),
                .init(uid: result.user.uid, name: NSLocalizedString("relationships", comment: ""), colorId: 2),
                .init(uid: result.user.uid, name: NSLocalizedString("life", comment: ""), colorId: 3)
            ]
            
            for category in categoriesData {
                CategoryService.shared.saveCategory(category: category) { _ in }
            }
            
            completion(.success(()))
        }
    }
    
    func signInUser(email: String, password: String, completion: @escaping (Result<Void, Error>)->()){
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            var newError:NSError
            if let err = error {
                newError = err as NSError
                var authError: AuthError?
                switch newError.code {
                    case 17009:
                        authError = .incorrectPassword
                    case 17008:
                        authError = .invalidEmail
                    case 17011:
                        authError = .accountDoesNotExist
                    case 17010:
                        authError = .tooManyRequests
                    default:
                        authError = .unknownError
                }
                completion(.failure(authError!))
                return
            }
            
            guard let _ = result?.user, let _ = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(()))
        }
    }
    
    func signOutUser(){
        do {
            
            try Auth.auth().signOut()
            
        }catch (let error) {
            print("Error while sign out. ", error.localizedDescription)
        }
    }
    
    func verifiedEmail(){
        
    }
    
    func forgotPassword(withEmail: String, completion: @escaping (Result<Void, Error>)->()) {
        Auth.auth().sendPasswordReset(withEmail: withEmail) { error in
            if let err = error {
                completion(.failure(err))
                return
            }
            completion(.success(()))
        }
    }
    
    func changePassword(){
        
    }
    
    func changeEmail(){
        
    }
    
    func deleteUser(){
        
    }
    
    
    
    
    
    
    
    
}
