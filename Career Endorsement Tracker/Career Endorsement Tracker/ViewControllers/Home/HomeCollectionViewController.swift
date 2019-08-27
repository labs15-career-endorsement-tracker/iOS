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
    //passing data
    let taskController = TaskController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    func updateView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/1.1, height: UIScreen.main.bounds.width/3)
        layout.minimumLineSpacing = 30
        
        collectionView.collectionViewLayout = layout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    //gets count from task array
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return taskController.tasks.count
    }
    
    //configures each cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HomeCollectionViewCell
        
        let task = taskController.tasks[indexPath.item]
        cell.task = task
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 15
        return cell
    }
}
