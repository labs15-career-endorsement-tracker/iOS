//
//  CoachSearchTableViewCell.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 9/23/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class CoachSearchTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    
    // MARK: - VC Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
