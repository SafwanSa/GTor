//
//  User.swift
//  GTor
//
//  Created by Safwan Saigh on 14/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation

enum Gender: String, Codable {
    case male = "Male"
    case female = "Female"
    case unknown = "Unknown"
}

struct User: Codable {
    var uid: String
    var name: String
    var gender: Gender?
    var email: String
}

extension User {
    static var dummyUser: User = .init(uid: "xiflrj8ydNZDfkPahfkLEja5e702", name: "Safwan", gender: .male , email: "safwan9f@gmail.com")
}
