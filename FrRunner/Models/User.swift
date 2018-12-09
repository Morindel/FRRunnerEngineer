//
//  User.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 03/11/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import Foundation

struct User: Codable, Hashable {
    var id: String?
    var pk: Int?
    var username: String
    
    var hashValue: Int {
        return pk.hashValue
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.pk == rhs.pk && lhs.username == rhs.username
    }
    
}

struct Token:Codable {
    let token: String?
}
