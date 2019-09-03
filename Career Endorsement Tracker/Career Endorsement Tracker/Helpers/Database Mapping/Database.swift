//
//  Database.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 8/28/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct UserDefaultsKeys {
    static let ifUserLoggedIn = "ifUserLoggedIn"
    static let deviceToken = "device_token"
    
    // Bearer Tokens
    static let encodedBearer = "encodedBearerToken"
    static let decodedBearer = "decodedBearerToken"
    
    // CurrentUser
    static let firstName = "first_name"
    static let lastName = "last_name"
    static let email = "email"
    static let password = "password"
    static let tracksID = "tracks_id"
}

struct Endpoints {
    static let login = "/login"
    static let users = "/users"
    static let tracks = "/tracks"
    static let requirements = "/requirements"
    static let steps = "/requirements/:requirementsId/steps"
}
