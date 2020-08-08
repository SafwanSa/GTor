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
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if let error = err {
                completion(.failure(error))
                return
            }
            
            guard let _ = result?.user, let result = result else {
                completion(.failure(err!))
                return
            }
            
            let user = User(uid: result.user.uid, name: name, gender: gender , email: email)
            FirestoreService.shared.saveDocument(collection: FirestoreKeys.Collection.users, documentId: user.uid, model: user) { completion($0) }
            
            let categoriesData: [Category] = [
                .init(uid: result.user.uid, name: "Work", colorId: 0),
                .init(uid: result.user.uid, name: "Study", colorId: 1),
                .init(uid: result.user.uid, name: "Relationships", colorId: 2),
                .init(uid: result.user.uid, name: "Life", colorId: 3)
            ]
            
            for category in categoriesData {
                CategoryService.shared.saveCategory(category: category) { _ in }
            }
            
            completion(.success(()))
        }
    }
    
    func signInUser(email: String, password: String, completion: @escaping (Result<Void, Error>)->()){
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(.failure(error))
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
    
    func forgotPassword(){
        
    }
    
    func changePassword(){
        
    }
    
    func changeEmail(){
        
    }
    
    func deleteUser(){
        
    }
    
    
    
    
    
    
    
    
}
