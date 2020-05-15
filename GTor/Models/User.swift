//
//  User.swift
//  GTor
//
//  Created by Safwan Saigh on 14/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation

struct User: Codable {
    var uid: String
    var name: String
    var email: String
}

extension User {
    static var dummyUser: User = .init(uid: "xiflrj8ydNZDfkPahfkLEja5e702", name: "Safwan", email: "safwan9f@gmail.com")
}
