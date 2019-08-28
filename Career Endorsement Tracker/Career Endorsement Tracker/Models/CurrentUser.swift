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
    var first_name: String
    var last_name: String
    var email: String
    var password: String
    var tracks_id: Int
}
