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
            return NSLocalizedString("invalidEmail", comment: "")
        case .operationNotAllowed:
            return NSLocalizedString("operationNotAllowed", comment: "")
        case .userDisabled:
            return NSLocalizedString("disabledUser", comment: "")
        case .tooManyRequests:
            return NSLocalizedString("tooManyRequests", comment: "")
        case .emailAlreadyInUse:
            return NSLocalizedString("emailIsUsed", comment: "")
        case .missingEmail:
            return NSLocalizedString("emailIsMissing", comment: "")
        case .weakPassword:
            return NSLocalizedString("weakPassword" , comment: "")
       case .incorrectPassword:
            return NSLocalizedString("incorrectPassword", comment: "")
        case .accountDoesNotExist:
             return NSLocalizedString("accountDoesNotExist", comment: "")
        case .unknownError:
             return NSLocalizedString("contactUsOnTwitter", comment: "")
        }
    }
}
