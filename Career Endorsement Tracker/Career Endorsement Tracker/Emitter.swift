//
//  sfgsda.swift
//  Career Endorsement Tracker
//
//  Created by Alex Mata on 9/9/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class Emitter {
    
    enum Colors {
        static let red = UIColor(red: 1.0, green: 0.0, blue: 77.0/255.0, alpha: 1.0)
        static let blue = UIColor.blue
        static let green = UIColor(red: 35.0/255.0 , green: 233/255, blue: 173/255.0, alpha: 1.0)
        static let yellow = UIColor(red: 1, green: 209/255, blue: 77.0/255.0, alpha: 1.0)
    }
    
    enum Images {
        static let box = UIImage(named: "Alex")!
        static let triangle = UIImage(named: "Sameera")!
        static let circle = UIImage(named: "Victor")!
        static let swirl = UIImage(named: "Spiral")!
    }
    
    // MARK: - Properties
    
    var emitter = CAEmitterLayer()
    
    var colors:[UIColor] = [
        Colors.red,
        Colors.blue,
        Colors.green,
        Colors.yellow
    ]
    
    var images:[UIImage] = [
        Images.box,
        Images.triangle,
        Images.circle,
        Images.swirl
    ]
    
    var icons:[String] = [
        "Alex",
        "Sameera",
        "Victor"
    ]
    
    var velocities:[Int] = [200,190,250,300]//[100,90,150,200]
    
    // MARK: - Methods
    
    func endParticles() {
        emitter.lifetime = 0.0
    }
    
    public var intensity: Float = 0.5

    func confettiWithColor() -> CAEmitterCell {
        let confetti = CAEmitterCell()
        confetti.birthRate = 4 * intensity
        confetti.lifetime = 10
        confetti.velocity = CGFloat(350 * intensity)
        confetti.velocityRange = CGFloat(80.0 * intensity)
        confetti.emissionLongitude = CGFloat(M_PI)// CGFloat(0)
        confetti.emissionRange = CGFloat(M_PI / 12)
        confetti.scale = 1
        confetti.scaleRange = 0.5
//        confetti.contents = getNextImage(i: index)
        return confetti
    }
    
    func generateEmitterCells() -> [CAEmitterCell] {
        var cells:[CAEmitterCell] = [CAEmitterCell]()
        for index in 0..<2 {
            
            let cell = CAEmitterCell()
            
            cell.birthRate = 4 * intensity
            cell.lifetime = 10
            cell.velocity = CGFloat(350 * intensity)
            cell.velocityRange = CGFloat(80.0 * intensity)
            cell.emissionLongitude = CGFloat(M_PI)// CGFloat(0)
            cell.emissionRange = CGFloat(M_PI / 12)
            cell.scale = 1
            cell.scaleRange = 0.5
            
//            cell.birthRate = 14.0
//            cell.lifetime = 14.0 //14.0
//            cell.lifetimeRange = 0
//            cell.velocity = CGFloat(getRandomVelocity())
//            cell.velocityRange = 0
//            cell.emissionLongitude = CGFloat(Double.pi)
//            cell.emissionRange = 0.8
//            cell.spin = 3.5
//            cell.spinRange = 0
            cell.color = getNextColor(i: index)
            cell.contents = getNextImage(i: index)
//            cell.scaleRange = 0.25
//            cell.scale = 0.1
            
            cells.append(cell)
        }
        return cells
    }
    
    private func getRandomVelocity() -> Int {
        return velocities[getRandomNumber()]
    }
    
    private func getRandomNumber() -> Int {
        return Int(arc4random_uniform(4))
    }
    
    private func getNextColor(i:Int) -> CGColor {
        if i <= 4 {
            return colors[0].cgColor
        } else if i <= 8 {
            return colors[1].cgColor
        } else if i <= 12 {
            return colors[2].cgColor
        } else {
            return colors[3].cgColor
        }
    }
    
    private func getNextImage(i:Int) -> CGImage {
        return images[i % 4].cgImage!
    }
    
    private func getNextIcon(i:Int) -> String {
        return icons[i % 4]
    }
}
