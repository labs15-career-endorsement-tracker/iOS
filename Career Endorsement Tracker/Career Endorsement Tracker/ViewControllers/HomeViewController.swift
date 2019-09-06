//
//  HomeViewController.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 9/6/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import JGProgressHUD

class HomeViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Actions
    
    @IBAction func logoutBtnPressed(_ sender: UIBarButtonItem) {
        let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive) {
            (action) in
            UserDefaults.standard.set(nil, forKey: "token")
            UserDefaults.standard.set(nil, forKey: "id")
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
        updateView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchRequirementsFromServer()
    }


    // MARK: - Helper Method
    
    func updateView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/1.1, height: UIScreen.main.bounds.width/3)
        layout.minimumLineSpacing = 30
        
        collectionView.collectionViewLayout = layout
        
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
