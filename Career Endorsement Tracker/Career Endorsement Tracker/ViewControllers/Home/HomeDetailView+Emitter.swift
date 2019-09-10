//
//  HomeDetailView+Emitter.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 9/9/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

extension HomeDetailTableViewController {
    
    // MARK: - Emitter
    
    func generateEmitterCells() -> [CAEmitterCell] {
        var cells:[CAEmitterCell] = [CAEmitterCell]()
        for index in 0..<16 {
            
            let cell = CAEmitterCell()
            
            cell.birthRate = 4.0
            cell.lifetime = 14.0 //14.0
            cell.lifetimeRange = 0
            cell.velocity = CGFloat(getRandomVelocity())
            cell.velocityRange = 0
            cell.emissionLongitude = CGFloat(Double.pi)
            cell.emissionRange = 0.8 //5
            cell.spin = 3.5
            cell.spinRange = 0
            cell.color = getNextColor(i: index)
            cell.contents = getNextImage(i: index)
            cell.scaleRange = 0.25
            cell.scale = 0.1
            
            cells.append(cell)
        }
        return cells
    }
    
    private func getRandomVelocity() -> Int {
        return emitt.velocities[getRandomNumber()] //velocities[getRandomNumber()]
    }
    
    private func getRandomNumber() -> Int {
        return Int(arc4random_uniform(4))
    }
    
    private func getNextColor(i:Int) -> CGColor {
        if i <= 4 {
            return emitt.colors[0].cgColor
        } else if i <= 8 {
            return emitt.colors[1].cgColor
        } else if i <= 12 {
            return emitt.colors[2].cgColor
        } else {
            return emitt.colors[3].cgColor
        }
    }
    
    private func getNextImage(i:Int) -> CGImage {
        return emitt.images[i % 4].cgImage!
    }
}



