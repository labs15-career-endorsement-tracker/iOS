//
//  Extensions.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 8/28/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit

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
