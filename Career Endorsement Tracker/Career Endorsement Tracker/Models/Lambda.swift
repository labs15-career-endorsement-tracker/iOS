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

struct Requirement: Codable, Equatable {
    var id: Int
    var tracks_id: Int
    var tasks_id: Int
    var title: String
    var is_required: Bool
    var tasks_description: String
    var is_endorsement_requirement: Bool
    var progress: Int
    var resources: [Resources]
}

struct Resources: Codable, Equatable {
    var id: Int
    var type: String
    var title: String
    var url: String
    var description: String?
    var tasks_id: Int
    
//    "id": 1,
//    "type": "google_doc",
//    "title": "Action verbs for technical resumes",
//    "url": "https://docs.google.com/document/d/1wZkDPBWtQZDGGdvStD61iRx_jOWVlIyyQl9UOYHtZgA/edit",
//    "description": null,
//    "tasks_id": 1
//    
}

struct Step: Codable {
    var id: Int
    var number: Int
    var steps_description: String
    var is_required: Bool
    var tasks_id: Int
    var is_complete: Bool
}
