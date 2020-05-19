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
    
    
    func getDocumentOnce<T: Codable>(collection: FirestoreKeys.Collection, documentId: String, completion: @escaping (Result<T, Error>) -> ()){
        let reference = Firestore.firestore().collection(collection.rawValue).document(documentId)
        reference.getDocument { (documentSnapshot, err) in
            DispatchQueue.main.async {
                if let err = err {
                    completion(.failure(err))
                    return
                }
                //Check the documentSnapshot
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
                    model = try FirebaseDecoder().decode(T.self, from: document)
                } catch (let error) {
                    fatalError("Error in decoding the model: \(error.localizedDescription)")
                }
                completion(.success(model))
            }
        }
    }
    
    
    func getDocument<T: Codable>(collection: FirestoreKeys.Collection, documentId: String, completion: @escaping (Result<T, Error>) -> ()){
        let reference = Firestore.firestore().collection(collection.rawValue).document(documentId)
        reference.addSnapshotListener { (documentSnapshot, err) in
            DispatchQueue.main.async {
                if let error = err {
                    completion(.failure(error))
                }
                guard let documentSnapshot = documentSnapshot else {
                    completion(.failure(FirestoreErrorHandler.noDocumentSnapshot))
                    return
                }
                guard let document = documentSnapshot.data() else {
                    completion(.failure(FirestoreErrorHandler.noSnapshotData))
                    return
                }
                var model: T
                do {
                    model = try FirebaseDecoder().decode(T.self, from: document)
                } catch(let error) {
                    fatalError("Error in decoding the model: \(error.localizedDescription)")
                }
                completion(.success(model))
            }
        }
    }
    
    //Check for the snapShotData
    func getDocumentsOnce<T: Codable>(collection: FirestoreKeys.Collection, documentId: String, completion: @escaping (Result<[T], Error>) -> ()){
        let reference = Firestore.firestore().collection(collection.rawValue).whereField("uid", isEqualTo: documentId)//Revice this
        reference.getDocuments { (querySnapshot, err) in
            DispatchQueue.main.async {
                if let error = err {
                    completion(.failure(error))
                }
                guard let querySnapshot = querySnapshot else {
                    completion(.failure(FirestoreErrorHandler.noDocumentSnapshot))
                    return
                }
                var models: [T] = []
                let documents = querySnapshot.documents
                for document in documents {
                    //Decoding
                    do {
                        try models.append(FirebaseDecoder().decode(T.self, from: document.data()))
                    } catch (let error) {
                        fatalError("Error in decoding the model: \(error.localizedDescription)")
                    }
                }
                completion(.success(models))
            }
        }
    }
    
    //Check for the snapShotData
    func getDocuments<T: Codable>(collection: FirestoreKeys.Collection, documentId: String, completion: @escaping (Result<[T], Error>) -> ()){
        let reference = Firestore.firestore().collection(collection.rawValue).whereField("uid", isEqualTo: documentId)//Revice this
        reference.addSnapshotListener { (querySnapshot, err) in
            DispatchQueue.main.async {
                if let error = err {
                    completion(.failure(error))
                }
                guard let querySnapshot = querySnapshot else {
                    completion(.failure(FirestoreErrorHandler.noDocumentSnapshot))
                    return
                }
                var models: [T] = []
                let documents = querySnapshot.documents
                for document in documents {
                    //Decoding
                    do {
                        try models.append(FirebaseDecoder().decode(T.self, from: document.data()))
                    } catch (let error) {
                        fatalError("Error in decoding the model: \(error.localizedDescription)")
                    }
                }
                completion(.success(models))
            }
        }
    }
    
    func saveDocument<T: Codable>(collection: FirestoreKeys.Collection, documentId: String, model: T, completion: @escaping (Result<Void, Error>) -> ()){
        var reference = Firestore.firestore().collection(collection.rawValue).document()
        if !documentId.isEmpty { reference = Firestore.firestore().collection(collection.rawValue).document(documentId) }
        var doc: [String:Any] = [:]
        do {
            doc = try FirebaseEncoder().encode(model) as! [String : Any]
        }catch(let error) {
            fatalError("Error in encoding the model: \(error.localizedDescription)")
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
    
    func deleteDocument(collection: FirestoreKeys.Collection, documentId: String, modelId: String, completion: @escaping (Result<Void, Error>) -> ()){
        let reference = Firestore.firestore().collection(collection.rawValue).whereField("uid", isEqualTo: AuthService.userId ?? "").whereField("id", isEqualTo: modelId)
        let batch = Firestore.firestore().collection(collection.rawValue)
        reference.getDocuments { (querySnapshot, err) in
              DispatchQueue.main.async {
                  if let error = err {
                      completion(.failure(error))
                  }
                  guard let querySnapshot = querySnapshot else {
                      completion(.failure(FirestoreErrorHandler.noDocumentSnapshot))
                      return
                  }
                  let documents = querySnapshot.documents
                  for document in documents {
                    batch.document(document.documentID).delete()
                  }
                completion(.success(()))
              }
        }
    }
    
    func updateDocument<T: Codable>(collection: FirestoreKeys.Collection, documentId: String, field: String, newData: T, completion: @escaping (Result<Void, Error>) -> ()){
        let reference = Firestore.firestore().collection(collection.rawValue).whereField("uid", isEqualTo: AuthService.userId).whereField("id", isEqualTo: documentId)
        let batch = Firestore.firestore().collection(collection.rawValue)
        reference.getDocuments { (querySnapshot, err) in
            DispatchQueue.main.async {
                if let error = err {
                    completion(.failure(error))
                }
                guard let querySnapshot = querySnapshot else {
                    completion(.failure(FirestoreErrorHandler.noDocumentSnapshot))
                    return
                }
                let documents = querySnapshot.documents
                for document in documents {
                    //Decoding
                    do {
                        let docField = try FirebaseEncoder().encode(newData)
                        batch.document(document.documentID).updateData([
                            field: docField
                        ])
                    } catch (let error) {
                        fatalError("Error in decoding the model: \(error.localizedDescription)")
                    }
                }
                completion(.success(()))
            }
        }
        
    }
    
    
    
}
