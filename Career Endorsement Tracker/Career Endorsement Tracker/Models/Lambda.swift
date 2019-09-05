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
    var id: Int
    var tracks_id: Int
    var tasks_id: Int
    var title: String
    var is_required: Bool
    var tasks_description: String
    var is_endorsement_requirement: Bool
    var progress: Int
}

struct Step: Codable {
    var id: Int
    var number: Int
    var steps_description: String
    var is_required: Bool
    var tasks_id: Int
    var is_complete: Bool
}
