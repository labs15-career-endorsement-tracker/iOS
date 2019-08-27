//
//  UserRepresentation.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 8/27/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct UserRepresentation: Codable, Equatable {
    
    // this needs to exactly match our Firebase data
    var email: String
    var first_name: String
    var last_name: String
    var is_admin: Bool
    var tracks_id: Int32
    var id: String
}

// we need to make sure our Firebase data matches our CoreData data

func == (lhs: UserRepresentation, rhs: User) -> Bool {
    return lhs.id == rhs.id && lhs.email == rhs.email && lhs.tracks_id == rhs.tracks_id && lhs.first_name == rhs.first_name  && lhs.last_name == rhs.last_name && lhs.is_admin == rhs.is_admin
}

func == (lhs: User, rhs: UserRepresentation) -> Bool {
    return rhs == lhs
}

func != (lhs: UserRepresentation, rhs: User) -> Bool {
    return !(rhs == lhs)
}

func != (lhs: User, rhs: UserRepresentation) -> Bool {
    return rhs != lhs
}
