//
//  ResourcesRepresentation.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 8/27/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct ResourcesRepresentation: Codable, Equatable {
    
    // this needs to exactly match our Firebase data
    var tasks_id: Int32
    var title: String
    var type: String
    var url: String
    var id: String
}

// we need to make sure our Firebase data matches our CoreData data

func == (lhs: ResourcesRepresentation, rhs: Resources) -> Bool {
    return lhs.id == rhs.id && lhs.tasks_id == rhs.tasks_id && lhs.title == rhs.title && lhs.type == rhs.type  && lhs.url == rhs.url
}

func == (lhs: Resources, rhs: ResourcesRepresentation) -> Bool {
    return rhs == lhs
}

func != (lhs: ResourcesRepresentation, rhs: Resources) -> Bool {
    return !(rhs == lhs)
}

func != (lhs: Resources, rhs: ResourcesRepresentation) -> Bool {
    return rhs != lhs
}
