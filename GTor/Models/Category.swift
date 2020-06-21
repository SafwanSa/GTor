//
//  Category.swift
//  GTor
//
//  Created by Safwan Saigh on 14/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation

struct Category: Codable, Identifiable, Equatable, Hashable{
    var id = UUID()
    var name: String?
}
