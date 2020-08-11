//
//  FirestoreError.swift
//  GTor
//
//  Created by Safwan Saigh on 14/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation

enum FirestoreErrorHandler: Error {
    case noAuthDataResult
    case noCurrentUser
    case noDocumentSnapshot
    case noSnapshotData
    case noUser
    case modelMismatch
}

extension FirestoreErrorHandler: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .noAuthDataResult:
                return NSLocalizedString("noAuthDataResult", comment: "")
            case .noCurrentUser:
                return NSLocalizedString("noCurrentUser", comment: "")
            case .noDocumentSnapshot:
                return NSLocalizedString("noDocumentSnapshot", comment: "")
            case .noSnapshotData:
                return NSLocalizedString("noSnapshotData", comment: "")
            case .noUser:
                return NSLocalizedString("noUser", comment: "")
            case .modelMismatch:
                return NSLocalizedString("userModelMismatch", comment: "")
        }
    }
}

