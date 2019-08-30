//
//  ResourcesController.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 8/30/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class ResourcesController {
    
    // MARK: - Init
    
    init(){
        fetchResourcesFromServer { (error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            print("HERE resources pulled down: ", self.resources.count)
        }
    }
    // MARK: - Properties
    
    let baseURL = URL(string: "https://backend.com/")!
    
    var resources: [Resources] {
        let request: NSFetchRequest<Resources> = Resources.fetchRequest()
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
    
    func fetchSingleResourceFromPersistentStore(identifier: String, context: NSManagedObjectContext) -> Resources? {
        // 1. create fetch request from User
        let fetchRequest: NSFetchRequest<Resources> = Resources.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        
        var result: Resources?
        
        do {
            result = try context.fetch(fetchRequest).first
        } catch let fetchError {
            print("Error fetching single user: \(fetchError.localizedDescription)")
        }
        return result
    }
    
    private func updateResources(with representations: [ResourcesRepresentation], in context: NSManagedObjectContext) {
        context.performAndWait {
            for resourceRep in representations {
                let identifier = resourceRep.id
                
                let resource = self.fetchSingleResourceFromPersistentStore(identifier: identifier, context: context)
                if let resource = resource, resource != resourceRep {
                    // if we have a Resource then update it
                    
                    resource.tasks_id = resourceRep.tasks_id
                    resource.title = resourceRep.title
                    resource.type = resourceRep.type
                    resource.url = resourceRep.url
                    resource.id = resourceRep.id
                    
                } else if resource == nil {
                    // if we have no Resource then create one
                    _ = Resources(resourcesRepresentation: resourceRep, context: context)
                }
            }
        }
    }
    
    func fetchResourcesFromServer(completion: @escaping CompletionHandler = { _ in}){
        let requestURL = baseURL.appendingPathExtension("json")
        let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
        
        URLSession.shared.dataTask(with: requestURL)  { (data, _, error) in
            if let error = error {
                return NSLog("Error fetching resources: \(error)")
            }
            
            guard let data = data else {
                NSLog("No data returned by data task")
                return completion(NSError())
            }
            
            do {
                let resourceRepresentationDict = try JSONDecoder().decode([String: ResourcesRepresentation].self, from: data)
                let resourceRepresentation = Array(resourceRepresentationDict.values)
                
                self.updateResources(with: resourceRepresentation, in: backgroundContext)
                
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
