//
//  User_steps_completedRepresentation.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 8/27/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct UserStepsCompletedRepresentation: Codable, Equatable {
    
    // this needs to exactly match our Firebase data
    var created_at: Date
    var steps_id: Int32
    var user_id: Int32
    var id: String
}

// we need to make sure our Firebase data matches our CoreData data

func == (lhs: UserStepsCompletedRepresentation, rhs: User_steps_completed) -> Bool {
    return lhs.id == rhs.id && lhs.created_at == rhs.created_at && lhs.steps_id == rhs.steps_id && lhs.user_id == rhs.user_id
}

func == (lhs: User_steps_completed, rhs: UserStepsCompletedRepresentation) -> Bool {
    return rhs == lhs
}

func != (lhs: UserStepsCompletedRepresentation, rhs: User_steps_completed) -> Bool {
    return !(rhs == lhs)
}

func != (lhs: User_steps_completed, rhs: UserStepsCompletedRepresentation) -> Bool {
    return rhs != lhs
}
