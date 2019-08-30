//
//  TaskTracksController.swift
//  Career Endorsement Tracker
//
//  Created by Victor  on 8/30/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class TaskTracksController {
    
    // MARK: - Init
    
    init() {
        fetchTasksTracksFromServer { (error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            print("HERE users pulled down: ", self.tasksTracks.count)
        }
        
    }
    // MARK: - Properties
    
    let baseURL = URL(string: "https://endrsd-api-staging.herokuapp.com/api/v0/requirements")!
    
    var tasksTracks: [TasksTracks] {
        let request: NSFetchRequest<TasksTracks> = TasksTracks.fetchRequest()
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
    
    func fetchSingleTaskTrackFromPersistentStore(identifier: String, context: NSManagedObjectContext) -> TasksTracks? {
        // 1. create fetch request from User
        let fetchRequest: NSFetchRequest<TasksTracks> = TasksTracks.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        
        var result: TasksTracks?
        
        do {
            result = try context.fetch(fetchRequest).first
        } catch let fetchError {
            print("Error fetching single task: \(fetchError.localizedDescription)")
        }
        return result
    }
    
    private func updateTasksTracks(with representations: [TaskTracksRepresentation], in context: NSManagedObjectContext) {
        context.performAndWait {
            for tasksTracksRep in representations {
                let identifier = tasksTracksRep.id
                
                let taskTrack = self.fetchSingleTaskTrackFromPersistentStore(identifier: identifier, context: context)
                if let taskTrack = taskTrack, taskTrack != tasksTracksRep {
                    // if we have a User then update it
                    taskTrack.tasks_id = tasksTracksRep.tasks_id
                    taskTrack.tracks_id = tasksTracksRep.tracks_id
                } else if taskTrack == nil {
                    // if we have no User then create one
                    _ = TasksTracks(taskTracksRepresentation: tasksTracksRep, context: context)
                }
            }
        }
    }
    
    func fetchTasksTracksFromServer(completion: @escaping CompletionHandler = { _ in}){
        var requestURL = URLRequest(url: baseURL)
        requestURL.httpMethod = "GET"
        requestURL.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
        
        URLSession.shared.dataTask(with: requestURL)  { (data, _, error) in
            if let error = error {
                return NSLog("Error fetching tasks tracks: \(error)")
            }
            
            guard let data = data else {
                NSLog("No data returned by data task")
                return completion(NSError())
            }
            
            do {
                let taskTracksRepresentationDict = try JSONDecoder().decode([String: TaskTracksRepresentation].self, from: data)
                let taskTracksRepresentation = Array(taskTracksRepresentationDict.values)
                
                self.updateTasksTracks(with: taskTracksRepresentation, in: backgroundContext)
                
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

