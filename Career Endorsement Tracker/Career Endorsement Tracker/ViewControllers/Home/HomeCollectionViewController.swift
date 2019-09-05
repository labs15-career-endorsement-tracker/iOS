//
//  HomeCollectionViewController.swift
//  Career Endorsement Tracker
//
//  Created by Victor  on 8/27/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit

class HomeCollectionViewController: UICollectionViewController {
    
    // MARK: - Instances
    let server = Server()
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRequirementsFromServer()
        updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    // MARK: - Collection View
    
    //gets count from task array
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return server.requirements.count
    }
    
    //configures each cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HomeCollectionViewCell
        
        let requirement = server.requirements[indexPath.item]
        cell.requirement = requirement
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 15
        return cell
    }
    
    // MARK: - UI
    
    func updateView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/1.1, height: UIScreen.main.bounds.width/3)
        layout.minimumLineSpacing = 30
        
        collectionView.collectionViewLayout = layout
    }
    
    func fetchRequirementsFromServer() {
        let token = UserDefaults.standard.object(forKey: "token") as! String
        server.fetchRequirements(withId: token) { (error) in
            if let error = error {
                print(error)
                return
            }
            print("Fucking success bitches")
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}
