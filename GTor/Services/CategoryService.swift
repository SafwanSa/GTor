//
//  CategoryService.swift
//  GTor
//
//  Created by Safwan Saigh on 14/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation
import Firebase

enum CategoryErrors: Error {
    case noName, noColor
}

extension CategoryErrors: LocalizedError {//TODO
    var errorDescription: String? {
        switch self {
        case .noName:
            return NSLocalizedString("nameIsMissing", comment: "")
        case .noColor:
            return NSLocalizedString("colorIsMissing", comment: "")
        }
    }
}


class CategoryService: ObservableObject {
    @Published var categories: [Category] = []
    static let shared = CategoryService()
    
    
    
    func getCategoriesFromDatabase(completion: @escaping (Result<Void, Error>) -> ()){
        FirestoreService.shared.getDocuments(collection: .categories, documentId: UserService.shared.user.uid) { (result: Result<[Category], Error>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let categories):
                DispatchQueue.main.async {
                    self.categories = categories
                    completion(.success(()))
                }
            }
        }
    }
    
    func saveCategoriesToDatabase(category: Category, completion: @escaping (Result<Void, Error>)->()){
        FirestoreService.shared.saveDocument(collection: .categories, documentId: category.id.description, model: category) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success():
                completion(.success(()))
            }
        }
    }
    
    
    func saveCategory(category: Category, completion: @escaping (Result<Void, Error>)->()) {
        validateCategory(category: category) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(()):
                self.saveCategoriesToDatabase(category: category) { (result) in
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
    
    func validateCategory(category: Category, completion: @escaping (Result<Void, Error>)->()) {
        if category.name.isEmpty {
            completion(.failure(CategoryErrors.noName))
        }else if category.colorId == -1{
            completion(.failure(CategoryErrors.noColor))
        }else {
            completion(.success(()))
        }
    }
    
    func deleteCategory(category: Category, completion: @escaping (Result<Void, Error>)->()) {
        FirestoreService.shared.deleteDocument(collection: .categories, documentId: category.id.description) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(()):
                completion(.success(()))
            }
        }
    }
    
}
