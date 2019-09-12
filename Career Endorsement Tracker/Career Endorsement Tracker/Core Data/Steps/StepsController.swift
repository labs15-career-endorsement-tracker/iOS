//
//  StepsController.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 8/30/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class StepsController {
    
    // MARK: - Init
    
    init(){
        fetchStepsFromServer { (error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            print("HERE steps pulled down: ", self.steps.count)
        }
    }
    // MARK: - Properties
    
    let baseURL = URL(string: "https://endrsd-api-staging.herokuapp.com/api/v0/steps")!

    var steps: [Steps] {
        let request: NSFetchRequest<Steps> = Steps.fetchRequest()
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
    
    func fetchSingleStepsFromPersistentStore(identifier: String, context: NSManagedObjectContext) -> Steps? {
        // 1. create fetch request from User
        let fetchRequest: NSFetchRequest<Steps> = Steps.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        
        var result: Steps?
        
        do {
            result = try context.fetch(fetchRequest).first
        } catch let fetchError {
            print("Error fetching single user: \(fetchError.localizedDescription)")
        }
        return result
    }
    
    private func updateSteps(with representations: [StepsRepresentation], in context: NSManagedObjectContext) {
        context.performAndWait {
            for stepRep in representations {
                let identifier = stepRep.id
                
                let step = self.fetchSingleStepsFromPersistentStore(identifier: identifier, context: context)
                if let step = step, step != stepRep {
                    // if we have a User then update it
                    step.is_required = stepRep.is_required
                    step.number = stepRep.number
                    step.steps_description = stepRep.steps_description
                    step.tasks_id = stepRep.tasks_id
                    step.id = stepRep.id
                
                } else if step == nil {
                    // if we have no User then create one
                    _ = Steps(stepsRepresentation: stepRep, context: context)
                }
            }
        }
    }
    
    func fetchStepsFromServer(completion: @escaping CompletionHandler = { _ in}){
        var requestURL = URLRequest(url: baseURL)
        requestURL.httpMethod = "GET"
        requestURL.setValue("application/json", forHTTPHeaderField: "Content-Type")

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
                let stepRepresentationDict = try JSONDecoder().decode([String: StepsRepresentation].self, from: data)
                let stepRepresentation = Array(stepRepresentationDict.values)
                
                self.updateSteps(with: stepRepresentation, in: backgroundContext)
                
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

