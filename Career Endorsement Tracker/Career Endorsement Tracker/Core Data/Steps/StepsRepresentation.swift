//
//  StepsRepresentation.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 8/27/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct StepsRepresentation: Codable, Equatable {
    
    // this needs to exactly match our Firebase data
    var is_required: Bool
    var number: Int32
    var steps_description: String
    var tasks_id: Int32
    var id: String
}

// we need to make sure our Firebase data matches our CoreData data

func == (lhs: StepsRepresentation, rhs: Steps) -> Bool {
    return lhs.id == rhs.id && lhs.is_required == rhs.is_required && lhs.number == rhs.number && lhs.steps_description == rhs.steps_description && lhs.tasks_id == rhs.tasks_id
}

func == (lhs: Steps, rhs: StepsRepresentation) -> Bool {
    return rhs == lhs
}

func != (lhs: StepsRepresentation, rhs: Steps) -> Bool {
    return !(rhs == lhs)
}

func != (lhs: Steps, rhs: StepsRepresentation) -> Bool {
    return rhs != lhs
}
