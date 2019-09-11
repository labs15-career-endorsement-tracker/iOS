//
//  Steps+Convenience.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 8/27/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension Steps {
    convenience init(id: String = UUID().uuidString, is_required: Bool, number: Int32, steps_description: String, tasks_id: Int32, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.id = id
        self.is_required = is_required
        self.number = number
        self.steps_description = steps_description
        self.tasks_id = tasks_id
    }
    
    // creates Steps from stepsRepresentation
    convenience init?(stepsRepresentation: StepsRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) { // optional bc it may not pull data from Firebase
        self.init(id: stepsRepresentation.id, is_required: stepsRepresentation.is_required, number: stepsRepresentation.number, steps_description: stepsRepresentation.steps_description, tasks_id: stepsRepresentation.tasks_id, context: context)
    }
    
    // converts Steps to StepsRepresentation before going to JSON
    var stepsRepresentation: StepsRepresentation? {
        guard let id = id, let steps_description = steps_description else {return nil}
        
        return StepsRepresentation(is_required: is_required, number: number, steps_description: steps_description, tasks_id: tasks_id, id: id)
    }
}

