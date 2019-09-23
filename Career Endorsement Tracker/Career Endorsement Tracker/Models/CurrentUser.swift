//
//  CurrentUser.swift
//  Career Endorsement Tracker
//
//  Created by Victor  on 8/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit

// With device_token
struct CurrentUser: Codable {
    
    var first_name: String = ""
    var last_name: String = ""
    var email: String
    var id: Int
    var tracks_id: Int = 0
    var progress: Int
    var is_admin: Bool
    var tracks_title: String
    
    init( first_name: String, last_name: String, email: String, id: Int, tracks_id: Int, progress: Int, is_admin: Bool, tracks_title: String) {
        (self.first_name, self.last_name, self.email, self.id, self.tracks_id, self.progress, self.is_admin, self.tracks_title) = (first_name, last_name, email, id, tracks_id, progress, is_admin, tracks_title)
    }
    
}

struct LoggedInUser: Encodable {
    var email: String
    var password: String
}
