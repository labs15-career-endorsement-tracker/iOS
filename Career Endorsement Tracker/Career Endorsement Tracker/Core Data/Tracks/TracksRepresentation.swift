//
//  TracksRepresentation.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 8/27/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct TracksRepresentation: Codable, Equatable {
    
    // this needs to exactly match our Firebase data
    var track_name: String
    var id: String
}

// we need to make sure our Firebase data matches our CoreData data

func == (lhs: TracksRepresentation, rhs: Tracks) -> Bool {
    return lhs.id == rhs.id && lhs.track_name == rhs.track_name
}

func == (lhs: Tracks, rhs: TracksRepresentation) -> Bool {
    return rhs == lhs
}

func != (lhs: TracksRepresentation, rhs: Tracks) -> Bool {
    return !(rhs == lhs)
}

func != (lhs: Tracks, rhs: TracksRepresentation) -> Bool {
    return rhs != lhs
}
