//
//  HomeViewController.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 9/5/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import JGProgressHUD

class HomeViewController: UIViewController {

    // MARK: - Instances
    let server = Server()
    var requirements: [Requirement] = []
    
    //displays progress sign
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hud.textLabel.text = "Loading Requirements..."
        hud.show(in: view, animated: true)
        fetchRequirementsFromServer()
        updateView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
            guard let destinationVC = segue.destination as? HomeDetailTableViewController else {return print("NO destination")}
            guard let indexPath = collectionView.indexPathsForSelectedItems?.first else {return}
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
