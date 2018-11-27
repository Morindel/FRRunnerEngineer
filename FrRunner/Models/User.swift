//
//  User.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 03/11/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import Foundation

struct User:Codable {
    static var current: User!
    var id: String
    var username: String
}

struct Token:Codable {
    let token: String?
}
