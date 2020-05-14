//
//  FirestoreError.swift
//  GTor
//
//  Created by Safwan Saigh on 14/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation

enum ErrorHandler: Error {
    case noAuthDataResult
    case noCurrentUser
    case noDocumentSnapshot
    case noSnapshotData
    case noUser
    case modelMismatch
}

extension ErrorHandler: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .noAuthDataResult:
                return NSLocalizedString("No Auth Data Result", comment: "")
            case .noCurrentUser:
                return NSLocalizedString("No Current User", comment: "")
            case .noDocumentSnapshot:
                return NSLocalizedString("No Document Snapshot", comment: "")
            case .noSnapshotData:
                return NSLocalizedString("No Snapshot Data", comment: "")
            case .noUser:
                return NSLocalizedString("No User", comment: "")
            case .modelMismatch:
                return NSLocalizedString("User Model Mismatch", comment: "")
        }
    }
}

