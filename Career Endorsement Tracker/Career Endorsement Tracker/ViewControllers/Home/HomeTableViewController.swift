//
//  HomeTableViewController.swift
//  Career Endorsement Tracker
//
//  Created by Victor  on 8/26/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit
import FoldingCell

class HomeTableViewController: UITableViewController {
    
    fileprivate struct C {
        struct CellHeight {
            static let close: CGFloat = 75
            static let open: CGFloat = 210
        }
    }
    
    var CELLCOUNT = 5
    var cellHeights = (0..<5).map { _ in C.CellHeight.close }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? FoldingCell else { return UITableViewCell() }
        var myLabel: UILabel {
            let label = UILabel()
            label.text = "Hello World"
            return label
        }
        cell.foregroundView.addSubview(myLabel)
        cell.containerView.addSubview(myLabel)
        return cell
    }
   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let cell as FoldingCell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        var duration = 0.0
        if cell.isUnfolded {
            cellHeights[indexPath.row] = C.CellHeight.open
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = C.CellHeight.close
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }

        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if case let cell as FoldingCell = cell {
            if cellHeights[indexPath.row] == C.CellHeight.close {
                FoldingCell.setAnimationsEnabled(false)
            } else {
                FoldingCell.setAnimationsEnabled(true)
            }
        }
    }
    
}
