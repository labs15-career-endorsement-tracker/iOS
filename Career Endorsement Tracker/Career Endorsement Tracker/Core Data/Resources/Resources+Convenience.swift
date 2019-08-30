//
//  Resources+Convenience.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 8/27/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension Resources {
    convenience init(id: String = UUID().uuidString, tasks_id: Int32, title: String, type: String, url: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.id = id
        self.tasks_id = tasks_id
        self.title = title
        self.type = type
        self.url = url
    }
    
    // creates Resources from ResourcesRepresentation
    convenience init?(resourcesRepresentation: ResourcesRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) { // optional bc it may not pull data from Firebase
        
        self.init(id: resourcesRepresentation.id, tasks_id: resourcesRepresentation.tasks_id, title: resourcesRepresentation.title, type: resourcesRepresentation.type, url: resourcesRepresentation.url, context: context)
    }
    
    // converts Resources to ResourcesRepresentation before going to JSON
    var resourcesRepresentation: ResourcesRepresentation? {
        guard let id = id, let title = title, let type = type, let url = url else {return nil}
        
        return ResourcesRepresentation(tasks_id: tasks_id, title: title, type: type, url: url, id: id)
    }
}

