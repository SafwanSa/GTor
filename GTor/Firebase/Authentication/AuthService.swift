//
//  AuthService.swift
//  GTor
//
//  Created by Safwan Saigh on 14/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation
import FirebaseAuth

struct AuthService {
    
    static var userId: String? {
        return Auth.auth().currentUser?.uid
    }
    
    
    static func createUser(name: String, email: String, password: String, completion: @escaping (Result<Void, Error>)->()){
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if let error = err {
                completion(.failure(error))
                return
            }
            
            guard let _ = result?.user, let result = result else {
                completion(.failure(err!))
                return
            }
            
            let user = User(uid: result.user.uid, name: name , email: email)
            //Save the user data
            completion(.success(()))
        }
    }
    
    func signInUser(){
        
    }
    
    func signOutUser(){
        
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
