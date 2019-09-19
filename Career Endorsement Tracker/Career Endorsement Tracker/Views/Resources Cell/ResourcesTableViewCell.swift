//
//  ResourcesTableViewCell.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 9/17/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class ResourcesTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    var resource: Resources? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var textViewLink: UITextView!
    
    // MARK: - VC Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Setup
    
    private func updateViews(){
        guard let resource = resource else {return}
        let attributedString = NSAttributedString.hyperLink(originalText: resource.title ?? "Resource", hyperLink: resource.title ?? "Resource", urlString: resource.url)
        textViewLink.attributedText = attributedString
        textViewLink.sizeToFit()
        textViewLink.tintColor = #colorLiteral(red: 0.1607843137, green: 0.6745098039, blue: 0.2666666667, alpha: 1)
    }
}

extension ResourcesViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}
