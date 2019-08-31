//
//  TasksController.swift
//  Career Endorsement Tracker
//
//  Created by Victor  on 8/30/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class TasksController {
    
    // MARK: - Init
    
    init(){
        fetchTasksFromServer { (error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            print("HERE tasks pulled down: ", self.tasks.count)
        }
        
    }
    // MARK: - Properties
    
    let baseURL = URL(string: "https://endrsd-api-staging.herokuapp.com/api/v0/requirements/")!
    
    var tasks: [Tasks] {
        let request: NSFetchRequest<Tasks> = Tasks.fetchRequest()
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
    
    func fetchSingleTaskFromPersistentStore(identifier: String, context: NSManagedObjectContext) -> Tasks? {
        // 1. create fetch request from User
        let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        
        var result: Tasks?
        
        do {
            result = try context.fetch(fetchRequest).first
        } catch let fetchError {
            print("Error fetching single user: \(fetchError.localizedDescription)")
        }
        return result
    }
    
    private func updateTasks(with representations: [TasksRepresentation], in context: NSManagedObjectContext) {
        context.performAndWait {
            for tasksRep in representations {
                let identifier = tasksRep.id
                
                let task = self.fetchSingleTaskFromPersistentStore(identifier: identifier, context: context)
                if let task = task, task != tasksRep {
                    // if we have a User then update it
                    task.id = tasksRep.id
                    task.is_endorsement_requirement = tasksRep.is_endorsement_requirement
                    task.is_required = tasksRep.is_required
                    task.title = tasksRep.title
                    task.tasks_description = tasksRep.tasks_description
                } else if task == nil {
                    // if we have no User then create one
                    _ = Tasks(taskRepresentation: tasksRep, context: context)
                }
            }
        }
    }
    
    func fetchTasksFromServer(completion: @escaping CompletionHandler = { _ in}){
        var requestURL = URLRequest(url: baseURL)
        requestURL.httpMethod = "GET"
        requestURL.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
        
        URLSession.shared.dataTask(with: requestURL)  { (data, _, error) in
            if let error = error {
                return NSLog("Error fetching tasks: \(error)")
            }
            
            guard let data = data else {
                NSLog("No data returned by data task")
                return completion(NSError())
            }
            
            do {
                let tasksRepresentationDict = try JSONDecoder().decode([String: TasksRepresentation].self, from: data)
                let tasksRepresentation = Array(tasksRepresentationDict.values)
                
                self.updateTasks(with: tasksRepresentation, in: backgroundContext)
                
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


