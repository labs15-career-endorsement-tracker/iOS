//
//  Server.swift
//  Career Endorsement Tracker
//
//  Created by Victor  on 8/27/19.
//  Copyright © 2019 Lambda School. All rights reserved
//

import Foundation

enum HTTPMethods: String {
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case get = "GET"
}

class Server {
    typealias CompletionHandler = (Error?) -> Void
    
    //MARK: Properties
    let dataGetter = DataGetter()
    var bearer: Bearer?
    var encodedBearer: Data?
    
    enum Endpoints: String {
        case login = "/login"
        case users = "/users"
        case tracks = "/tracks"
        case requirements = "/requirements"
        case steps = "/steps"
        case step = "/step"
        case resetPassword = "/reset-password"
        case coach = ""
    }
    
    enum HTTPHeaderKeys: String {
        case contentType = "Content-Type"
        case auth = "Authorization"
        
        enum ContentTypes: String {
            case json = "application/json"
        }
    }
    
    let baseURL = URL(string: "https://endrsd-api.herokuapp.com/api/v2")!
    
    //MARK: Welcome Flow

    func loginWith(user: LoggedInUser, completion: @escaping (Error?)->Void) {
        let loginURL = baseURL.appendingPathComponent(Endpoints.login.rawValue)
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
        
        dataGetter.fetchData(with: request) { (response, data, error) in
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
                UserDefaults.standard.set(self.bearer?.token, forKey: "token")
                UserDefaults.standard.set(self.bearer?.userId, forKey: "id")
                UserDefaults.standard.set(self.bearer?.isAdmin, forKey: "isAdmin")
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    
    func signUpWith(firstName: String, lastName: String, email: String, password: String, trackID: Int, completion: @escaping (Error?)->Void) {
      
        let signUpURL = baseURL.appendingPathComponent(Endpoints.users.rawValue)

        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethods.post.rawValue
        request.setValue(HTTPHeaderKeys.ContentTypes.json.rawValue, forHTTPHeaderField: HTTPHeaderKeys.contentType.rawValue)
        
        do {
            let userParams = ["first_name": firstName, "last_name": lastName, "email": email, "password": password, "tracks_id": trackID] as [String: Any]
            let json = try JSONSerialization.data(withJSONObject: userParams, options: .prettyPrinted)
            request.httpBody = json
        } catch {
            completion(error)
            return
        }
        
        dataGetter.fetchData(with: request) { (_, data, error) in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
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
                UserDefaults.standard.set(self.bearer?.token, forKey: "token")
                UserDefaults.standard.set(self.bearer?.userId, forKey: "id")
                UserDefaults.standard.set(firstName, forKey: "firstName")
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    
    // MARK: - Forgot password request
    func resetPasswordFor(user: ResetPassword, completion: @escaping (Error?)->Void) {
        let resetPasswordURL = baseURL.appendingPathComponent(Endpoints.resetPassword.rawValue)
        print("resetPasswordURL = \(resetPasswordURL)")
        var request = URLRequest(url: resetPasswordURL)
        request.httpMethod = HTTPMethods.post.rawValue
        request.addValue(HTTPHeaderKeys.ContentTypes.json.rawValue, forHTTPHeaderField: HTTPHeaderKeys.contentType.rawValue)
        
        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(user)
        } catch {
            completion(error)
            return
        }
        
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
            
            //            let decoder = JSONDecoder()
            do {
                //                self.bearer = try decoder.decode(Bearer.self, from: data)
                //                UserDefaults.standard.set(self.bearer?.token, forKey: "token")
                //                UserDefaults.standard.set(self.bearer?.userId, forKey: "id")
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    
    //MARK: Fetch
    
    //Fetches all requirements
    func fetchRequirements(withId id: String, completion: @escaping ([Requirement]?, Error?)->Void) {

        let requirementsURL = baseURL.appendingPathComponent(Endpoints.requirements.rawValue)
        print(id)
        var request = URLRequest(url: requirementsURL)
        request.httpMethod = HTTPMethods.get.rawValue
        request.addValue("Bearer \(id)", forHTTPHeaderField: "Authorization")
        
        dataGetter.fetchData(with: request) { (_, data, error) in
            if let error = error {
                completion(nil, error)
            } else {
                completion(nil, nil)
            }
            
            guard let data = data else {
                completion(nil, DataGetter.NetworkError.badData)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let data = try decoder.decode([Requirement].self, from: data)
                completion(data, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    //fetches single requirement
    func fetchRequirement(withId id: String, withReqId reqId: Int, completion: @escaping (Requirement?, Error?)->Void) {
        
        let requirementURL = baseURL.appendingPathComponent("\(Endpoints.requirements.rawValue)/\(reqId)")
        print(requirementURL)
        var request = URLRequest(url: requirementURL)
        request.httpMethod = HTTPMethods.get.rawValue
        request.addValue("Bearer \(id)", forHTTPHeaderField: "Authorization")
        
        dataGetter.fetchData(with: request) { (_, data, error) in
            if let error = error {
                completion(nil, error)
            } else {
                completion(nil, nil)
            }
            
            guard let data = data else {
                completion(nil, DataGetter.NetworkError.badData)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let data = try decoder.decode(Requirement.self, from: data)
                completion(data, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    //fetches all steps to complete for a requirement
    func fetchSteps(withId id: String, withReqId reqId: Int, completion: @escaping ([Step]?, Error?)->Void) {
        
        let stepsURL = baseURL.appendingPathComponent("/requirements/\(reqId)\(Endpoints.steps.rawValue)")
        print(stepsURL)
        print(id)
        var request = URLRequest(url: stepsURL)
        request.httpMethod = HTTPMethods.get.rawValue
        request.addValue("Bearer \(id)", forHTTPHeaderField: "Authorization")
        
        dataGetter.fetchData(with: request) { (_, data, error) in
            if let error = error {
                completion(nil, error)
            } else {
                completion(nil, nil)
            }
            
            guard let data = data else {
                completion(nil, DataGetter.NetworkError.badData)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let data = try decoder.decode([Step].self, from: data)
                completion(data, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    //fetches current user
    func fetchUser(withId id: String, withUserId userId: Int, completion: @escaping (CurrentUser?, Error?)->Void) {
        
        let userURL = baseURL.appendingPathComponent("users/\(userId)")
        print(userURL)
        var request = URLRequest(url: userURL)
        request.httpMethod = HTTPMethods.get.rawValue
        request.addValue("Bearer \(id)", forHTTPHeaderField: "Authorization")
        
        dataGetter.fetchData(with: request) { (_, data, error) in
            if let error = error {
                print("error fetching data - users/")
                completion(nil, error)
            } else {
                completion(nil, nil)
            }
            
            guard let data = data else {
                print("data no good")
                completion(nil, DataGetter.NetworkError.badData)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let data = try decoder.decode(CurrentUser.self, from: data)
                completion(data, nil)
            } catch {
                print(error.localizedDescription)
                completion(nil, error)
            }
        }
    }

    //MARK: Update
    
    //updates step for completion status
    func updateStep(withId id: String, withReqId reqId: Int, withStepId stepId: Int, isComplete: Bool, completion: @escaping (Error?)->Void) {
        
        let postUpdatedStepURL = baseURL.appendingPathComponent("/requirements/\(reqId)\(Endpoints.steps.rawValue)/\(stepId)")
        print(postUpdatedStepURL)
        var request = URLRequest(url: postUpdatedStepURL)
        request.httpMethod = HTTPMethods.put.rawValue
        request.addValue("Bearer \(id)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print("request: \(request)")
        do {
            let params = ["is_complete": isComplete] as [String: Any]
            print(params)
            let json = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            request.httpBody = json
        } catch {
            print("Error encoding item object: \(error)")
        }
        
        dataGetter.fetchData(with: request) { (_, data, error) in
            if let error = error {
                print("error updating step")
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    //fetches users
    func searchUser(withId id: String, withName name: String, completion: @escaping ([CurrentUser]?, Error?)->Void) {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "endrsd-api.herokuapp.com"
        components.path = "/api/v2/users"
        //adds query items
        let queryItemQuery = URLQueryItem(name: "search", value: "\(name)")
        components.queryItems = [queryItemQuery]
        print(components.url ?? "no url")
        
        guard let url = components.url else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethods.get.rawValue
        request.addValue("Bearer \(id)", forHTTPHeaderField: "Authorization")
        
        dataGetter.fetchData(with: request) { (_, data, error) in
            if let error = error {
                print("error fetching data - users/")
                completion(nil, error)
            } else {
                completion(nil, nil)
            }
            
            guard let data = data else {
                print("data no good")
                completion(nil, DataGetter.NetworkError.badData)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let data = try decoder.decode([CurrentUser].self, from: data)
                completion(data, nil)
            } catch {
                print(error.localizedDescription)
                completion(nil, error)
            }
        }
    }
    
    //pins student
    func pinStudent(withToken token: String, withStudentId id: Int, completion: @escaping (Error?)->Void) {
        
        
        let pinStudentURL = baseURL.appendingPathComponent("/students/\(id)")
    
        var request = URLRequest(url: pinStudentURL)
        request.httpMethod = HTTPMethods.put.rawValue
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        dataGetter.fetchData(with: request) { (_, data, error) in
            if let error = error {
                print("error fetching data - users/")
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    //fetches pinned students
    
    func fetchPinnedStudents(withToken token: String, completion: @escaping ([CurrentUser]?, Error?)->Void) {
        
        let allPinnedStudentsURL = baseURL.appendingPathComponent("students")
        var request = URLRequest(url: allPinnedStudentsURL)
        request.httpMethod = HTTPMethods.get.rawValue
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        dataGetter.fetchData(with: request) { (_, data, error) in
            if let error = error {
                completion(nil, error)
            } else {
                completion(nil, nil)
            }
            
            guard let data = data else {
                completion(nil, DataGetter.NetworkError.badData)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let data = try decoder.decode([CurrentUser].self, from: data)
                completion(data, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    
    //fetches user requirements in coach views
    
    func fetchUserRequirements(withToken token: String, userID: Int, completion: @escaping ([Requirement]?, Error?)->Void) {
        
        let studentsReqURL = baseURL.appendingPathComponent("users/\(userID)/requirements")
        var request = URLRequest(url: studentsReqURL)
        request.httpMethod = HTTPMethods.get.rawValue
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        dataGetter.fetchData(with: request) { (_, data, error) in
            if let error = error {
                completion(nil, error)
            } else {
                completion(nil, nil)
            }
            
            guard let data = data else {
                completion(nil, DataGetter.NetworkError.badData)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let data = try decoder.decode([Requirement].self, from: data)
                completion(data, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    //deletes user
    
    func deleteUser(withToken token: String, completion: @escaping (Error?) -> Void) {
        let deleteURL = baseURL.appendingPathComponent("users")
        var request = URLRequest(url: deleteURL)
        request.httpMethod = HTTPMethods.delete.rawValue
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        dataGetter.fetchData(with: request) { (_, data, error) in
            if let error = error {
                print("error updating step")
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    
    func addCalendlyLink(withToken token: String, withLink link: String, completion: @escaping (Error?) -> Void) {
        let calendlyURL = baseURL.appendingPathComponent("users")
        var request = URLRequest(url: calendlyURL)
        request.httpMethod = HTTPMethods.put.rawValue
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue(HTTPHeaderKeys.ContentTypes.json.rawValue, forHTTPHeaderField: HTTPHeaderKeys.contentType.rawValue)
        
        print(link)
        do {
            let userParams = ["calendly_link": link] as [String: Any]
            let json = try JSONSerialization.data(withJSONObject: userParams, options: .prettyPrinted)
            request.httpBody = json
        } catch {
            print("496")
            completion(error)
            return
        }
        
        dataGetter.fetchData(with: request) { (_, data, error) in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
        
    }
    
    
    
}
