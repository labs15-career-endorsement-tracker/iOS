//
//  Tracks+Convenience.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 8/27/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension Tracks {
    convenience init(id: String = UUID().uuidString, tracks_name: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.id = id
        self.track_name = tracks_name
    }
    
    // creates Task from TaskRepresentation
    convenience init?(tracksRepresentation: TracksRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) { // optional bc it may not pull data from Firebase
        
        self.init(id: tracksRepresentation.id, tracks_name: tracksRepresentation.track_name, context: context)
    }
    
    // converts Track to TrackRepresentation before going to JSON
    var tracksRepresentation: TracksRepresentation? {
        guard let id = id, let track_name = track_name else {return nil}
        
        return TracksRepresentation(track_name: track_name, id: id)
    }
    
}
