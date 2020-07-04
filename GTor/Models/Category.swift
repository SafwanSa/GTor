//
//  Category.swift
//  GTor
//
//  Created by Safwan Saigh on 14/05/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation
import UIKit

enum GTColor: Int, CaseIterable {
    case none = -1, red = 0, blue = 1 , green = 2, yellow = 3, black = 4, gray = 5, pink = 6, purple = 7, brown = 8, white = 9
    
    var color: UIColor {
        switch self {
        case .red:
            return UIColor.red
        case .blue:
            return UIColor.blue
        case .green:
            return UIColor.green
        case .yellow:
            return UIColor.yellow
        case .black:
            return UIColor.black
        case .gray:
            return UIColor.gray
        case .pink:
            return UIColor.systemPink
        case .purple:
            return UIColor.purple
        case .brown:
            return UIColor.brown
        case .white:
            return UIColor.white
        case .none:
            return UIColor.black
        }
    }
}

struct Category: Codable, Identifiable, Equatable, Hashable{
    var id = UUID()
    var uid: String
    var name: String
    var colorId: Int
}
