//
//  Task_TracksRepresentation.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 8/27/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct TaskTracksRepresentation: Codable, Equatable {
    
    // this needs to exactly match our Firebase data
    var tracks_id: Int32
    var tasks_id: Int32
    var id: String
}

// we need to make sure our Firebase data matches our CoreData data

func == (lhs: TaskTracksRepresentation, rhs: TasksTracks) -> Bool {
    return lhs.id == rhs.id && lhs.tracks_id == rhs.tracks_id && lhs.tasks_id == rhs.tasks_id
}

func == (lhs: TasksTracks, rhs: TaskTracksRepresentation) -> Bool {
    return rhs == lhs
}

func != (lhs: TaskTracksRepresentation, rhs: TasksTracks) -> Bool {
    return !(rhs == lhs)
}

func != (lhs: TasksTracks, rhs: TaskTracksRepresentation) -> Bool {
    return rhs != lhs
}
