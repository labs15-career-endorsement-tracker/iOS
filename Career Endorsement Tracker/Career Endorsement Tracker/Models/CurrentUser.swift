//
//  CurrentUser.swift
//  Career Endorsement Tracker
//
//  Created by Victor  on 8/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit

//Model for user signed in
struct CurrentUser: Encodable {
    var first_name: String = ""
    var last_name: String = ""
    var email: String
    var password: String
    var tracks_id: Int = -1
    
    init( first_name: String, last_name: String, email: String, password: String, tracks_id: Int) {
        (self.first_name, self.last_name, self.email, self.password, self.tracks_id) = (first_name, last_name, email, password, tracks_id)
    }
    
    init( email: String, password: String) {
        (self.email, self.password) = (email, password)
    }
}
