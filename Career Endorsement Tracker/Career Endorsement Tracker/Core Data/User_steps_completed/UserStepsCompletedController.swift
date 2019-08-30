//
//  UserStepsCompletedController.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 8/29/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class UserStepsCompletedController {
    
    // MARK: - Init
    
    init(){
        fetchUserStepsFromServer { (error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            print("HERE user steps pulled down: ", self.userStepsCompleted.count)
        }
    }
    // MARK: - Properties
    
    let baseURL = URL(string: "https://backend.com/")!
    
    var userStepsCompleted: [User_steps_completed] {
        let request: NSFetchRequest<User_steps_completed> = User_steps_completed.fetchRequest()
        //Sort by timestamp
        //request.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: true)]
        return (try? CoreDataStack.shared.mainContext.fetch(request)) ?? []
    }
    
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
    
    func fetchSingleUserStepsCompletedFromPersistentStore(identifier: String, context: NSManagedObjectContext) -> User_steps_completed? {
        // 1. create fetch request from User
        let fetchRequest: NSFetchRequest<User_steps_completed> = User_steps_completed.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        
        var result: User_steps_completed?
        
        do {
            result = try context.fetch(fetchRequest).first
        } catch let fetchError {
            print("Error fetching single user: \(fetchError.localizedDescription)")
        }
        return result
    }
    
    private func updateUserCompletedStesp(with representations: [UserStepsCompletedRepresentation], in context: NSManagedObjectContext) {
        context.performAndWait {
            for userStepRep in representations {
                let identifier = userStepRep.id
                
                let userStep = self.fetchSingleUserStepsCompletedFromPersistentStore(identifier: identifier, context: context)
                if let userStep = userStep, userStep != userStepRep {
                    // if we have a User then update it
                    userStep.created_at = userStepRep.created_at
                    userStep.steps_id = userStepRep.steps_id
                    userStep.user_id = userStepRep.user_id
                    userStep.id = userStepRep.id
                    
                } else if userStep == nil {
                    // if we have no User then create one
                    _ = User_steps_completed(userStepsCompletedRepresentation: userStepRep, context: context)
                }
            }
        }
    }
    
    func fetchUserStepsFromServer(completion: @escaping CompletionHandler = { _ in}){
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
                let userStepRepresentationDict = try JSONDecoder().decode([String: UserStepsCompletedRepresentation].self, from: data)
                let userStepRepresentation = Array(userStepRepresentationDict.values)
                
                self.updateUserCompletedStesp(with: userStepRepresentation, in: backgroundContext)
                
                // save changes to disk
                try CoreDataStack.shared.save(context: backgroundContext)
            } catch {
                NSLog("Error decoding tasks: \(error)")
                return completion(error)
            }
            completion(nil)
            }.resume()
    }
}

