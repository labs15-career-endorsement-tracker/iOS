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

    static let buttonTitleFontSize: CGFloat = 18
    static let buttonTitleColor = UIColor.white
    static let buttonCornerRadius: CGFloat = 7
    
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
