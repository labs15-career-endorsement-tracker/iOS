//
//  Tasks_Tracks+Convenience.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 8/27/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension TasksTracks {
    convenience init(id: String = UUID().uuidString, tracks_id: Int32, tasks_id: Int32, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.id = id
        self.tracks_id = tracks_id
        self.tasks_id = tasks_id
    }
    
    // creates Task from TaskRepresentation
    convenience init?(taskTracksRepresentation: TaskTracksRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) { // optional bc it may not pull data from Firebase
        
        self.init(id: taskTracksRepresentation.id, tracks_id: taskTracksRepresentation.tracks_id, tasks_id: taskTracksRepresentation.tasks_id, context: context)
    }
    
    // converts Task to TaskRepresentation before going to JSON
    var taskTracksRepresentation: TaskTracksRepresentation? {
        guard let id = id else {return nil}
        
        return TaskTracksRepresentation(tracks_id: tracks_id, tasks_id: tasks_id, id: id)
    }
    
}
