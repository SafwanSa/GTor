//
//  AuthError.swift
//  GTor
//
//  Created by Safwan Saigh on 14/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation
import FirebaseAuth


enum AuthError: Error {
    case invalidEmail
    case operationNotAllowed
    case userDisabled
    case tooManyRequests
    case emailAlreadyInUse
    case missingEmail
    case weakPassword
    case incorrectPassword
    case accountDoesNotExist
    case unknownError
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
       switch self {
        case .invalidEmail:
            return NSLocalizedString("Invalid Email", comment: "")
        case .operationNotAllowed:
            return NSLocalizedString("Operation Not Allowed", comment: "")
        case .userDisabled:
            return NSLocalizedString("Disabled User", comment: "")
        case .tooManyRequests:
            return NSLocalizedString("Too Many Requests", comment: "")
        case .emailAlreadyInUse:
            return NSLocalizedString("This email is used", comment: "")
        case .missingEmail:
            return NSLocalizedString("Email Is Missing", comment: "")
        case .weakPassword:
            return NSLocalizedString("Weak Password", comment: "")
       case .incorrectPassword:
            return NSLocalizedString("Incorrect Password", comment: "")
        case .accountDoesNotExist:
             return NSLocalizedString("Account does not exist", comment: "")
        case .unknownError:
             return NSLocalizedString("Please contact us on Twitter", comment: "")
        }
    }
}
