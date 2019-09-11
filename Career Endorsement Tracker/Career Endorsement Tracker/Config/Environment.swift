//
//  Environment.swift
//  endrsd-ios
//
//  Created by Mikis Woodwinter on 9/5/19.
//  Copyright © 2019 Labs15SuperTeam. All rights reserved.
//

import Foundation

public enum Environment {
    // MARK: - Keys
    enum Keys {
        enum Plist {
            static let apiBaseUrl = "API_BASE_URL"
        }
    }
    
    // MARK: - Plist
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    
    // MARK: - Plist values
    static let apiBaseUrl: URL = {
        guard let apiBaseUrlString = Environment.infoDictionary[Keys.Plist.apiBaseUrl] as? String else {
            fatalError("Root URL not set in plist for this environment")
        }
        guard let url = URL(string: apiBaseUrlString) else {
            fatalError("Root URL is invalid")
        }
        return url
    }()
}
