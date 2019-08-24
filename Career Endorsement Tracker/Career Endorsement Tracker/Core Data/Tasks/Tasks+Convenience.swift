//
//  Tasks+Convenience.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 8/23/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension Tasks {
    convenience init(id: String = UUID().uuidString, tasks_description: String, is_required: Bool, is_endorsement_requirement: Bool, title: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.id = id
        self.is_required = is_required
        self.is_endorsement_requirement = is_endorsement_requirement
        self.title = title
        self.tasks_description = tasks_description
    }
    
    // creates Task from TaskRepresentation
    convenience init?(taskRepresentation: TasksRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) { // optional bc it may not pull data from Firebase
        self.init(id: taskRepresentation.id, tasks_description: taskRepresentation.tasks_description, is_required: taskRepresentation.is_required, is_endorsement_requirement: taskRepresentation.is_endorsement_requirement, title: taskRepresentation.title, context: context)
    }
    
    // converts Task to TaskRepresentation before going to JSON
    var taskRepresentation: TasksRepresentation? {
        guard let id = id, let title = title, let tasks_description = tasks_description else {return nil}
        
        return TasksRepresentation(is_required: is_required, is_endorsement_requirement: is_endorsement_requirement, title: title, id: id, tasks_description: tasks_description)
    }
    
}
