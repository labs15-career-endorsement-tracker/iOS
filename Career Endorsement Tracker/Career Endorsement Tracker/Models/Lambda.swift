//
//  Lambda.swift
//  Career Endorsement Tracker
//
//  Created by Victor  on 8/27/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct tracks: Codable {
    let id: Int
    let title: String
}

struct track: Codable {
    var requirements: [Requirement]
}

struct Requirement: Codable {
    var description: String
}
