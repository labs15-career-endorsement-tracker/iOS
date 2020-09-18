//
//  ResourcesViewController.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 9/17/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class ResourcesViewController: UIViewController {

    // MARK: - Properties
    
    var requirement: Requirement?
    let emitt = Emitter()
    var intensity: Float = 0.5
    private var audioLevel : Float = 0.0
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        title = "Resources"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listenVolumeButton()
    }

    // MARK: - Observer
    
    func listenVolumeButton(){
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(true, options: [])
            audioSession.addObserver(self, forKeyPath: "outputVolume", options: NSKeyValueObservingOptions.new, context: nil)
            audioLevel = audioSession.outputVolume
        } catch {
            print("Error")
        }
    }
    
    var timesClickedUp = 0
    var timesClickedDown = 0
    var upResult = 3
    var downResult = 2

    // MARK: - Do Not Delete
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "outputVolume"{
            let audioSession = AVAudioSession.sharedInstance()
            
            if audioSession.outputVolume > audioLevel {timesClickedUp += 1}
            else if audioSession.outputVolume < audioLevel {timesClickedDown += 1}
            if upResult == timesClickedUp, downResult == timesClickedDown {
                print("Secret code run.")
                startConfetti()
                timesClickedUp = 0
                timesClickedDown = 0
            }
            if timesClickedDown > downResult {timesClickedDown = 0}
            if timesClickedUp > upResult {timesClickedUp = 0}
            
            if audioSession.outputVolume > audioLevel {
                print("Hello")
                audioLevel = audioSession.outputVolume
            }
            if audioSession.outputVolume < audioLevel {
                print("GoodBye")
                audioLevel = audioSession.outputVolume
            }
            if audioSession.outputVolume > 0.999 {
                print("Max Volume")
                (MPVolumeView().subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider)?.setValue(0.9375, animated: false)
                audioLevel = 0.9375
            }
            
            if audioSession.outputVolume < 0.001 {
                print("Min Volume")
                (MPVolumeView().subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider)?.setValue(0.0625, animated: false)
                audioLevel = 0.0625
            }
        }
    }

    private func startConfetti(){
        emitt.emitter.emitterShape = CAEmitterLayerEmitterShape.line
        emitt.emitter.emitterCells = generateEmitterCells()
        emitt.emitter.emitterPosition = CGPoint(x: self.view.frame.size.width / 2, y: -10)
        emitt.emitter.emitterSize = CGSize(width: self.view.frame.size.width, height: 2.0)
        print("HERE. Running confetti")
        DispatchQueue.main.async {
            let currentWindow: UIWindow? = UIApplication.shared.keyWindow
            currentWindow?.layer.addSublayer(self.emitt.emitter)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            self.emitt.endParticles()
        }
    }
}

extension ResourcesViewController: UITableViewDelegate {
    
}

extension ResourcesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requirement?.resources.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ResourcesTableViewCell", owner: self, options: nil)?.first as! ResourcesTableViewCell

        cell.resource = requirement?.resources[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

extension ResourcesViewController {
    // MARK: - Emitter
    
    func generateEmitterCells() -> [CAEmitterCell] {
        var cells:[CAEmitterCell] = [CAEmitterCell]()
        for index in 0..<3 {
            
            let cell = CAEmitterCell()
            
            cell.birthRate = 4 * emitt.intensity
            cell.lifetime = 10
            cell.velocity = CGFloat(350 * emitt.intensity)
            cell.velocityRange = CGFloat(80.0 * emitt.intensity)
            cell.emissionLongitude = CGFloat(Double.pi)// CGFloat(0)
            cell.emissionRange = CGFloat(Double.pi / 12)
            cell.scale = 0.3
            cell.scaleRange = 0.5
            cell.color = getNextColor(i: index)
            cell.contents = getNextImage(i: index)

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
