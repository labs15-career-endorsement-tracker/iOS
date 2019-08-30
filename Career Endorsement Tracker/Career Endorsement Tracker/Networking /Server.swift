//
//  Server.swift
//  Career Endorsement Tracker
//
//  Created by Victor  on 8/27/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

enum HTTPMethods: String {
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case get = "GET"
}

class Server {
    
    let dataGetter = DataGetter()
    
    var bearer: Bearer?
    var encodedBearer: Data?
    
    enum Endpoints: String {
        case signup = "/signup"
        case login = "/login"
        case users = "/users"
        case tracks = "/tracks"
        case requirements = "/requirements"
        case steps = "/requirements/:requirementsId/steps"
    }
    
    enum HTTPHeaderKeys: String {
        case contentType = "Content-Type"
        case auth = "Authorization"
        
        enum ContentTypes: String {
            case json = "application/json"
        }
    }
    
    let baseURL = URL(string: "https://endrsd-api-staging.herokuapp.com/api/v0")
    
    
    func loginWith(user: CurrentUser, completion: @escaping (Error?)->Void) {
        let loginURL = baseURL!.appendingPathComponent(Endpoints.login.rawValue)
         print("loginURL = \(loginURL)")
        var request = URLRequest(url: loginURL)
        request.httpMethod = HTTPMethods.post.rawValue
        request.addValue(HTTPHeaderKeys.ContentTypes.json.rawValue, forHTTPHeaderField: HTTPHeaderKeys.contentType.rawValue)
       
        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(user)
        } catch {
            completion(error)
            return
        }
        
        // bob_ross@happylittlemistakes.com
        
        
        dataGetter.fetchData(with: request) { (_, data, error) in
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(DataGetter.NetworkError.badData)
                return
            }
            
            // Save the endoded bearer token so that it can be saved to user defaults
            self.encodedBearer = data
            
            let decoder = JSONDecoder()
            do {
                self.bearer = try decoder.decode(Bearer.self, from: data)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    
    func signUp(with user: CurrentUser, completion: @escaping (Error?)->Void) {
        let signUpURL = baseURL!.appendingPathComponent(Endpoints.signup.rawValue)
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethods.post.rawValue
        request.setValue(HTTPHeaderKeys.ContentTypes.json.rawValue, forHTTPHeaderField: HTTPHeaderKeys.contentType.rawValue)
        
        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(user)
        } catch {
            completion(error)
            return
        }
        
        dataGetter.fetchData(with: request) { (_, _, error) in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    
   func fetch(completion: @escaping (Error?)->Void) {
       let signUpURL = baseURL!.appendingPathComponent(Endpoints.users.rawValue)
     //   let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethods.get.rawValue
        request.setValue(HTTPHeaderKeys.ContentTypes.json.rawValue, forHTTPHeaderField: HTTPHeaderKeys.contentType.rawValue)
    
        dataGetter.fetchData(with: request) { (_, _, error) in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
}
