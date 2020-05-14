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
    
    var authStateDidChangeHandler: AuthStateDidChangeListenerHandle?
    
    func configureAuthStateDidChnageListner() {
        if authStateDidChangeHandler != nil {
            return
        }
        
        authStateDidChangeHandler = Auth.auth().addStateDidChangeListener({ (_ , user) in
            guard let user = user else {
                DispatchQueue.main.async {
                    self.authState = .signOut
                    self.user = .dummy
                }
                return
            }
            DispatchQueue.main.async {
                 self.authState = .signIn
            }
            self.retreiveUser(uid: user.uid)
        })
    }
    
    
    
    
    private func retreiveUser(uid: String){
        FirestoreService.shared.getDocument(collection: FirestoreKeys.Collection.users, documentId: uid) { (result: Result<User, Error>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let user):
                DispatchQueue.main.async { self.user = user }
            }
        }
        
    }
}






extension User {
    static let dummy = User(uid: "", name: "Dummy Name", email: "")
}
