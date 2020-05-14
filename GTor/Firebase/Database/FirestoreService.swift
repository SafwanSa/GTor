//
//  FirestoreService.swift
//  GTor
//
//  Created by Safwan Saigh on 14/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FirestoreKeys {
    enum Collection: String {
        case users = "users"
        case goals = "goals"
        case categories = "categories"
        case tasks = "tasks"
    }
}

class FirestoreService {
    
    let shared = FirestoreService()
    
    
    func getDocument<T: Codable>(collection: FirestoreKeys.Collection, documentId: String, completion: @escaping (Result<T, Error>) -> ()){
        let reference = Firestore.firestore().collection(collection.rawValue).document(documentId)
        
        reference.getDocument { (documentSnapshot, err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            guard let documentSnapshot = documentSnapshot else {
                completion(.failure(FirestoreErrorHandler.noDocumentSnapshot))
                return
            }
            guard let document = documentSnapshot.data() else {
                completion(.failure(FirestoreErrorHandler.noSnapshotData))
                return
            }
            
            
        }
    }
    
    func saveDocument(){
        
    }
    
    func deleteDocument(){
        
    }
    
    
    
}
