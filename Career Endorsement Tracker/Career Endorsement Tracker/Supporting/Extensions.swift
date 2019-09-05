//
//  Extensions.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 8/28/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit

struct UIViewExtensionConstants {
    static let CornerRadiusForCell : CGFloat = 25
    static let CornerRadiusForLabel : CGFloat = 20
}

extension UITextField {
    func underlined(color: UIColor){
        var border = CALayer()
        let width = CGFloat(3.0)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension UIView {
    func shadowCell(){
        self.layer.cornerRadius = UIViewExtensionConstants.CornerRadiusForCell
        self.layer.masksToBounds = true
        self.layer.shadowRadius = 5.0
        self.layer.shadowColor = UIColor(red:0.37, green:0.37, blue:0.37, alpha:1).cgColor
        self.layer.shadowOpacity = 0.34
        self.layer.shadowOffset = CGSize(width: 2, height: 5)
        self.layer.masksToBounds = false
    }
}
