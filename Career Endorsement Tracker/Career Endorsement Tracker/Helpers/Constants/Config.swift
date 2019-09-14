//
//  Config.swift
//  Career Endorsement Tracker
//
//  Created by Victor  on 8/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import JGProgressHUD

class Config {

    // MARK:- Object Customizations
    static let buttonTitleFontSize: CGFloat = 18
    static let buttonTitleColor = UIColor.white
    static let buttonCornerRadius: CGFloat = 7
    static let lightGreenDesignColor = UIColor(red: 119/255, green: 232/255, blue: 121/255, alpha: 1)
    
    
    // App theme colors
    // Textfield highlight color
    static let textFieldBorderColor = UIColor(red: 173.0/256.0, green: 216.0/256.0, blue: 144/256.0, alpha: 1.0).cgColor
    
    static let cellColor = UIColor(red: 251.0/256.0, green: 254.0/256.0, blue: 255/256.0, alpha: 1.0).cgColor
    
    // Greens
    static var themeDarkGreen = UIColor(red: 0.0/256.0, green: 147.0/256.0, blue: 30.0/256.0, alpha: 1.0)
    static var themeGreen = UIColor(red: 33.0/256.0, green: 92.0/256.0, blue: 89/256.0, alpha: 1.0)
    static var themeLightGreen = UIColor(red: 0.0/256.0, green: 147.0/256.0, blue: 30.0/256.0, alpha: 1.0)
    
    // Grays
    static var themeDarkGray = UIColor(red: 201.0/256.0, green: 207.0/256.0, blue: 209.0/256.0, alpha: 1.0)
    static var themeLightGray = UIColor(red: 233.0/256.0, green: 237.0/256.0, blue: 240.0/256.0, alpha: 1.0)
    
    // White-ish
    static var themeWhite = UIColor(red: 251.0/256.0, green: 254.0/256.0, blue: 255.0/256.0, alpha: 1.0)
    
    // Blues
    static var themeDarkBlue = UIColor(red: 16.0/256.0, green: 25.0/256.0, blue: 83.0/256.0, alpha: 1.0)
    static var themeBlueGren = UIColor(red: 16.0/256.0, green: 71.0/256.0, blue: 83.0/256.0, alpha: 1.0)
    static var themeLightPurple = UIColor(red: 172.0/256.0, green: 179.0/256.0, blue: 223.0/256.0, alpha: 1.0)
    
    // Orange
    static var themeOrange = UIColor(red: 224.0/256.0, green: 106.0/256.0, blue: 63.0/256.0, alpha: 1.0)


    
    static func showAlert(on: UIViewController, style: UIAlertController.Style, title: String?, message: String?, actions: [UIAlertAction] = [ UIAlertAction(title: "OK", style: .default, handler: nil)], completion: (() -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions {
            alert.addAction(action)
        }
        on.present(alert, animated: true, completion: completion)
    }
    
    static func dissmissHud(_ hud: JGProgressHUD, text: String, detailText: String, delay: TimeInterval) {
        hud.textLabel.text = text
        hud.detailTextLabel.text = detailText
        hud.dismiss(afterDelay: delay, animated: true)
    }
}
