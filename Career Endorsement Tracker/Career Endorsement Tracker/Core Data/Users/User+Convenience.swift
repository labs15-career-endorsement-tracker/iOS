//
//  User+Convenience.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 8/27/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension User {
    convenience init(id: String = UUID().uuidString, email: String, first_name: String, last_name: String, is_admin: Bool, tracks_id: Int32, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.id = id
        self.email = email
        self.first_name = first_name
        self.last_name = last_name
        self.is_admin = is_admin
        self.tracks_id = tracks_id
    }
    
    // creates User from UserRepresentation
    convenience init?(userRepresentation: UserRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) { // optional bc it may not pull data from Firebase
        self.init(id: userRepresentation.id, email: userRepresentation.email, first_name: userRepresentation.first_name, last_name: userRepresentation.last_name, is_admin: userRepresentation.is_admin, tracks_id: userRepresentation.tracks_id, context: context)
    }
    
    // converts Task to TaskRepresentation before going to JSON
    var userRepresentation: UserRepresentation? {
        guard let id = id, let email = email, let first_name = first_name, let last_name = last_name else {return nil}
        
        return UserRepresentation(email: email, first_name: first_name, last_name: last_name, is_admin: is_admin, tracks_id: tracks_id, id: id)        
    }
}
