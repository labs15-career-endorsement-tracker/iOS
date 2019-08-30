//
//  User_steps_completed+Convenience.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 8/27/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension User_steps_completed {
    convenience init(id: String = UUID().uuidString, steps_id: Int32, user_id: Int32, created_at: Date, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)

        self.id = id
        self.created_at = created_at
        self.steps_id = steps_id
        self.user_id = user_id
    }
    
    // creates User_steps_completed from UserStepsCompletedRepresentation
    convenience init?(userStepsCompletedRepresentation: UserStepsCompletedRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) { // optional bc it may not pull data from Firebase
        self.init(id: userStepsCompletedRepresentation.id, steps_id: userStepsCompletedRepresentation.steps_id, user_id: userStepsCompletedRepresentation.user_id, created_at: userStepsCompletedRepresentation.created_at, context: context)
    }
    
    // converts User_steps_completed to UserStepsCompletedRepresentation before going to JSON
    var userStepsCompletedRepresentation: UserStepsCompletedRepresentation? {
        guard let id = id, let created_at = created_at else {return nil}
        
        return UserStepsCompletedRepresentation(created_at: created_at, steps_id: steps_id, user_id: user_id, id: id)
    }
}

