//
//  SupportTableViewCell.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 9/19/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class SupportTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    var iconImage: UIImage?
    var url: String?
    
    // MARK: - Outlets
    
    @IBOutlet weak var linkTextView: UITextView!
    @IBOutlet weak var iconImageView: UIImageView! {
        didSet {
            setupUI()
        }
    }
    
    // MARK: - VC Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - UI
    
    private func setupUI(){
        guard let iconImage = iconImage else {return print("Missing icon.")}
        guard let url = url else {return print("Missing url.")}
        
        linkTextView.text = url
        iconImageView.image = iconImage
    }
}

// MARK: - Text View Delegate

extension SupportTableViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}
