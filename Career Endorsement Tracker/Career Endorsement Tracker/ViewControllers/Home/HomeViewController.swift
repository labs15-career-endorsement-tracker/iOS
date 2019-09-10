//
//  HomeViewController.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 9/6/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import JGProgressHUD
import UICircularProgressRing

class HomeViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var progressBar: UICircularProgressRing!
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var overallProgressLabel: UILabel!
    
    // MARK: - Actions
    
    @IBAction func logoutBtnPressed(_ sender: UIBarButtonItem) {
        let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive) {
            (action) in
            UserDefaults.standard.removeObject(forKey: "token")
            UserDefaults.standard.removeObject(forKey: "id")
            UserDefaults.standard.removeObject(forKey: "firstName")
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "WelcomeNavigationController")
            self.present(vc, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        Config.showAlert(on: self, style: .actionSheet, title: nil, message: nil, actions: [signOutAction, cancelAction], completion: nil)
    }
    
    // MARK: - Instances
    let server = Server()
    var requirements: [Requirement] = []
    var currentUser: CurrentUser?
    
    //displays progress sign
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        hud.textLabel.text = "Loading Requirements..."
        hud.show(in: view, animated: true)
        fetchRequirementsFromServer()
        updateViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchRequirementsFromServer()
        fetchUserFromServer()
    }


    // MARK: - Helper Method
    
    func updateViews() {
        guard let logo = UIImage(named: "logo-color") else {
            // TODO: - Handle this error somehow
            print("Error: Missing 'logo-color' image file!")
            return
        }
        
        let imageView = UIImageView(image: logo)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 144).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0/5.914).isActive = true
        
        
        self.navigationItem.titleView = imageView
        
        progressBar.maxValue = 100
        progressBar.style = .dashed(pattern: [1.0, 1.0])

        guard let name = UserDefaults.standard.value(forKey: "firstName") as? String else {return print("No Name")}
        userNameLabel.text = "Good evening, \(name)."
    }
    
    private func updateProgress(progress: Int){
        //        progressBar.labelSize = 20
        //        progressBar.safePercent = 10
        //        progressBar.setProgress(to: 10.0, withAnimation: false)
        //        progressBar.animate(toAngle: 90, duration: 2.5, completion: nil)
        
        //        progressBar.trackClr = UIColor.cyan
        //        progressBar.progressClr = UIColor.purple
        //        progressBar.setProgressWithAnimation(duration: 1.0, value: 0.60)
        
        progressBar.startProgress(to: CGFloat(progress), duration: 2.0) {
            print("Done animating!")
        }
    }
    
    //MARK: Network Call
    
    func fetchRequirementsFromServer() {
        let token = UserDefaults.standard.object(forKey: "token") as! String
        server.fetchRequirements(withId: token) { (reqResult, error) in
            if let error = error {
                print(error)
                DispatchQueue.main.async {
                    self.hud.dismiss(animated: true)
                    Config.showAlert(on: self, style: .alert, title: "Fetching Error", message: error.localizedDescription)
                }
                return
            }
            if let reqResult = reqResult {
                self.requirements = reqResult
                DispatchQueue.main.async {
                    self.hud.dismiss(animated: true)
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func fetchUserFromServer() {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("no token")
            return
        }
        guard let id = UserDefaults.standard.object(forKey: "id") as? Int else {
            return
        }
        server.fetchUser(withId: token, withUserId: id) { (CurrentUser, error) in
            if let error = error {
                print(error)
                print("112 error")
                DispatchQueue.main.async {
                    self.hud.dismiss(animated: true)
                    Config.showAlert(on: self, style: .alert, title: "Error Fetching User", message: error.localizedDescription)
                }
                return
            }
            if let currentUser = CurrentUser {
                self.currentUser = currentUser
                DispatchQueue.main.async {
                    self.hud.dismiss(animated: true)
                    self.updateProgress(progress: currentUser.progress)
                    self.overallProgressLabel.text = "\(currentUser.progress)%"
                    if self.userNameLabel.text == "Good evening, Bob." {
                        self.userNameLabel.text = "Good evening, \(currentUser.first_name)."
                    }
                }
            }
            
        }
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSegue" {
            guard let destinationVC = segue.destination as? HomeDetailTableViewController else {
                print("NO destination")
                return
            }
            guard let indexPath = collectionView.indexPathsForSelectedItems?.first else {
                return
            }
            destinationVC.server = server
            destinationVC.id = requirements[indexPath.item].id
            destinationVC.requirement = requirements[indexPath.item]
        }
    }


}

extension HomeViewController: UICollectionViewDelegate {
    
}
extension HomeViewController: UICollectionViewDataSource {
    
    // MARK: - Collection View
    
    //gets count from task array
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return requirements.count
    }
    
    //configures each cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HomeCollectionViewCell
        
        let requirement = requirements[indexPath.item]
        cell.requirement = requirement
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 15
        return cell
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return  CGSize(width: collectionView.bounds.size.width, height: 80)
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 5
//    }
    
    
}
