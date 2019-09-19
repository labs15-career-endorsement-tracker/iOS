//
//  DataGetter.swift
//  Career Endorsement Tracker
//
//  Created by Victor  on 8/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//


import Foundation
import UIKit

class DataGetter {
    
    enum NetworkError: Error {
        case noAuth
        case otherError
        case badData
        case noDecode
        case httpNon200StatusCode(code: Int)
    }
    
    //setting constants
    enum HTTPError: Error {
        case non200StatusCode
        case noData
        case conflict
        case unauthorized
        case notFound
    }
    
    //retrieves data
    func fetchData(with request: URLRequest, requestID: String? = nil, completion: @escaping (String?, Data?, Error?) -> Void) {
        // bob_ross@happylittlemistakes.com
        //data task
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            //error handling     
            if let error = error {
                print(error)
                completion(requestID, nil, error)
                return
            } else if let response = response as? HTTPURLResponse, !(200...201).contains(response.statusCode) {
                print("non 200 http response: \(response.statusCode)")
                print(String(data: data!, encoding: .utf8))
//                let myError = response.statusCode == 409 ?  HTTPError.conflict :  HTTPError.non200StatusCode  // Must check if user already exists (response 409)
                // Capture and pass actual error
                var myError: Error
                switch(response.statusCode) {
                case 401:
                    myError = HTTPError.unauthorized
                case 404:
                    myError = HTTPError.notFound
                case 409:
                    myError = HTTPError.conflict
                default:
                    myError =  HTTPError.non200StatusCode
                }
                completion(requestID, nil, myError)
                return
            }
            
            guard let data = data else {
                completion(requestID, nil, HTTPError.noData)
                return
            }
            completion(requestID, data, nil)
            }.resume()
    }
}
