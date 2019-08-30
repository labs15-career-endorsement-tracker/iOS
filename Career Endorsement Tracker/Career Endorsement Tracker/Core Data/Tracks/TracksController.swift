//
//  TracksController.swift
//  Career Endorsement Tracker
//
//  Created by Victor  on 8/30/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class TracksController {
    
    // MARK: - Init
    
    init(){
        fetchTracksFromServer { (error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            print("HERE users pulled down: ", self.track.count)
        }
        
    }
    // MARK: - Properties
    
    let baseURL = URL(string: "https://endrsd-api-staging.herokuapp.com/api/v0/users")!
    
    var track: [Tracks] {
        let request: NSFetchRequest<Tracks> = Tracks.fetchRequest()
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
    
    func fetchSingleTrackFromPersistentStore(identifier: String, context: NSManagedObjectContext) -> Tracks? {
        // 1. create fetch request from User
        let fetchRequest: NSFetchRequest<Tracks> = Tracks.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        
        var result: Tracks?
        
        do {
            result = try context.fetch(fetchRequest).first
        } catch let fetchError {
            print("Error fetching single user: \(fetchError.localizedDescription)")
        }
        return result
    }
    
    private func updateTracks(with representations: [TracksRepresentation], in context: NSManagedObjectContext) {
        context.performAndWait {
            for tracksRep in representations {
                let identifier = tracksRep.id
                
                let track = self.fetchSingleTrackFromPersistentStore(identifier: identifier, context: context)
                if let track = track, track != tracksRep {
                    // if we have a User then update it
                    track.track_name = tracksRep.track_name
                    track.id = tracksRep.id
                } else if track == nil {
                    // if we have no User then create one
                    _ = Tracks(tracksRepresentation: tracksRep, context: context)
                }
            }
        }
    }
    
    func fetchTracksFromServer(completion: @escaping CompletionHandler = { _ in}){
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
                let tracksRepresentationDict = try JSONDecoder().decode([String: TracksRepresentation].self, from: data)
                let tracksRepresentation = Array(tracksRepresentationDict.values)
                
                self.updateTracks(with: tracksRepresentation, in: backgroundContext)
                
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

