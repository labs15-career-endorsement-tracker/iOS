//
//  ResourcesTableViewCell.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 9/17/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class ResourcesTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var textViewLink: UITextView!
    
    // MARK: - VC Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Add link
        UIApplication.shared.openURL(NSURL(string: "https://google.com")! as URL)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Setup
    
    private func updateViews(){
        
    }
}

extension ResourcesViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}
