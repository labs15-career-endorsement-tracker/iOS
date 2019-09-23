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
