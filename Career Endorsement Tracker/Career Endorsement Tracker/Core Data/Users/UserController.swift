//
//  UserController.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 8/28/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class UserController {

    // MARK: - Properties
    
    let baseURL = URL(string: "https://coredata-283af.firebaseio.com/")!

    // MARK: - Save Persistent Store
    
    func saveToPersistentStore(){
        let moc = CoreDataStack.shared.mainContext
        
        do {
            try moc.save() // save to persistent store
        } catch let error {
            print("Error saving moc: \(error)")
        }
    }
    
    typealias CompletionHandler = (Error?) -> Void

    func fetchSingleUserFromPersistentStore(identifier: String, context: NSManagedObjectContext) -> User? {
        // 1. create fetch request from User
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        
        var result: User?
        
        do {
            result = try context.fetch(fetchRequest).first
        } catch let fetchError {
            print("Error fetching single user: \(fetchError.localizedDescription)")
        }
        return result
    }
    
    func fetchUsersFromServer(completion: @escaping CompletionHandler = { _ in}){
        let requestURL = baseURL.appendingPathExtension("json")
        let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
        
        URLSession.shared.dataTask(with: requestURL)  { (data, _, error) in
            if let error = error {
                return NSLog("Error fetching users: \(error)")
            }
            
            guard let data = data else {
                NSLog("No data returned by data task")
                return completion(NSError())
            }
            
            do {
                let userRepresentationDict = try JSONDecoder().decode([String: UserRepresentation].self, from: data)
                let userRepresentation = Array(userRepresentationDict.values)
                
                self.updateUsers(with: userRepresentation, in: backgroundContext)
                
                // save changes to disk
                try CoreDataStack.shared.save(context: backgroundContext)
            } catch {
                NSLog("Error decoding tasks: \(error)")
                return completion(error)
            }
            completion(nil)
            }.resume()
    }
    
    private func updateUsers(with representations: [UserRepresentation], in context: NSManagedObjectContext) {
        context.performAndWait {
            for userRep in representations {
                let identifier = userRep.id
                
                let user = self.fetchSingleUserFromPersistentStore(identifier: identifier, context: context)
                if let user = user, user != userRep {
                    // if we have a User then update it
                    user.email = userRep.email
                    user.first_name = userRep.first_name
                    user.is_admin = userRep.is_admin
                    user.last_name = userRep.last_name
                    user.tracks_id = userRep.tracks_id
                    user.device_token = userRep.device_token
                } else if user == nil {
                    // if we have no User then create one
                    _ = User(userRepresentation: userRep, context: context)
                }
            }
        }
    }

}