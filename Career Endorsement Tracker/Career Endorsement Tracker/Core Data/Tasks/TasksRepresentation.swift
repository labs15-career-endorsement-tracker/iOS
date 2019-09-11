//
//  TasksRepresentation.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 8/23/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct TasksRepresentation: Codable, Equatable {
    
    // this needs to exactly match our Firebase data
    var is_required: Bool
    var is_endorsement_requirement: Bool
    var title: String
    var id: String
    var tasks_description: String
}

// we need to make sure our Firebase data matches our CoreData data

func == (lhs: TasksRepresentation, rhs: Tasks) -> Bool {
    return lhs.is_required == rhs.is_required && lhs.is_endorsement_requirement == rhs.is_endorsement_requirement && lhs.title == rhs.title && lhs.id == rhs.id && lhs.tasks_description == rhs.tasks_description
}

func == (lhs: Tasks, rhs: TasksRepresentation) -> Bool {
    return rhs == lhs
}

func != (lhs: TasksRepresentation, rhs: Tasks) -> Bool {
    return !(rhs == lhs)
}

func != (lhs: Tasks, rhs: TasksRepresentation) -> Bool {
    return rhs != lhs
}
