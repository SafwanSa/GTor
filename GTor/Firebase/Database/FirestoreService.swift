//
//  FirestoreService.swift
//  GTor
//
//  Created by Safwan Saigh on 14/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase

enum FirestoreKeys {
    enum Collection: String {
        case users = "users"
        case goals = "goals"
        case categories = "categories"
        case tasks = "tasks"
    }
}

class FirestoreService {
    
    static var shared = FirestoreService()
    
    
    func getDocument<T: Codable>(collection: FirestoreKeys.Collection, documentId: String, completion: @escaping (Result<T, Error>) -> ()){
        let reference = Firestore.firestore().collection(collection.rawValue).document(documentId)
        reference.getDocument { (documentSnapshot, err) in
            DispatchQueue.main.async {
                if let err = err {
                    completion(.failure(err))
                    return
                }
                //Check the dicumentSnapshot
                guard let documentSnapshot = documentSnapshot else {
                    completion(.failure(FirestoreErrorHandler.noDocumentSnapshot))
                    return
                }
                //Check the data
                guard let document = documentSnapshot.data() else {
                    completion(.failure(FirestoreErrorHandler.noSnapshotData))
                    return
                }
                var model: T
                //Decoding
                do {
                    model = try FirestoreDecoder().decode(T.self, from: document)
                } catch (let error) {
                    fatalError("Error in decoding the model: \(error.localizedDescription)")
                }
                completion(.success(model))
            }
        }
    }
    
    func saveDocument<T: Codable>(collection: FirestoreKeys.Collection, documentId: String, model: T, completion: @escaping (Result<Void, Error>) -> ()){
        let reference = Firestore.firestore().collection(collection.rawValue).document(documentId)
        var doc: [String:Any] = [:]
        do {
            doc = try FirestoreEncoder().encode(model)
        }catch(let error) {
            completion(.failure(error))
        }
        reference.setData(doc, merge: true) { error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                }
                completion(.success(()))
            }
        }
    }
    
    func deleteDocument<T: Codable>(collection: FirestoreKeys.Collection, documentId: String, model: T, completion: @escaping (Result<Void, Error>) -> ()){
        let reference = Firestore.firestore().collection(collection.rawValue).document(documentId)
        
        reference.delete { (error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                }
                completion(.success(()))
            }
        }
    }
    
    
    
}
