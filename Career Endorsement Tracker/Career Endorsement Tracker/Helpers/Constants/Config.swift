//
//  Config.swift
//  Career Endorsement Tracker
//
//  Created by Victor  on 8/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
//import LBTAComponents
//import JGProgressHUD

class Config {

    // MARK:- Object Customizations
    static let buttonTitleFontSize: CGFloat = 18
    static let buttonTitleColor = UIColor.white
    static let buttonCornerRadius: CGFloat = 7

    // App theme colors
    static var themeNavBarTint = UIColor(red: 41.0/256.0, green: 110.0/256.0, blue: 108.0/256.0, alpha: 1.0)
    static var themeButtonColor = UIColor(red: 33.0/256.0, green: 92.0/256.0, blue: 89.0/256.0, alpha: 1.0)
//    static var themeAlertBox = UIColor(red: x.0/256.0, green: x.0/256.0, blue: x.0/256.0, alpha: 1.0)
    
    static var themeTextRed = UIColor(red: 223.0/256.0, green: 16.0/256.0, blue: 65.0/256.0, alpha: 1.0)
    static var themeDarkRed = UIColor(red: 188.0/256.0, green: 50.0/256.0, blue: 51.0/256.0, alpha: 1.0)
    static var themeDarkGreen = UIColor(red: 41.0/256.0, green: 110.0/256.0, blue: 108.0/256.0, alpha: 1.0)
    static var themeGreen = UIColor(red: 33.0/256.0, green: 92.0/256.0, blue: 89/256.0, alpha: 1.0)
//    static var themeLightGreen = UIColor(red: x.0/256.0, green: x.0/256.0, blue: x.0/256.0, alpha: 1.0)

    
    static func showAlert(on: UIViewController, style: UIAlertController.Style, title: String?, message: String?, actions: [UIAlertAction] = [ UIAlertAction(title: "OK", style: .default, handler: nil)], completion: (() -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions {
            alert.addAction(action)
        }
        on.present(alert, animated: true, completion: completion)
    }
    
//    static func dissmissHud(_ hud: JGProgressHUD, text: String, detailText: String, delay: TimeInterval) {
//        hud.textLabel.text = text
//        hud.detailTextLabel.text = detailText
//        hud.dismiss(afterDelay: delay, animated: true)
//    }
}
