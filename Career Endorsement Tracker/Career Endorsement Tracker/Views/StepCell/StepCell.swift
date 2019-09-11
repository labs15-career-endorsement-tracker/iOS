//
//  StepCell.swift
//  Career Endorsement Tracker
//
//  Created by Mikis Woodwinter on 9/10/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

protocol StepData {
    var is_complete: Bool { get }
    var steps_description: String { get }
}

extension Step: StepData {}

protocol StepCellDelegate {
    func didSelect(_ cell: StepCell, atIndexPath indexPath: IndexPath)
}

class StepCell: UITableViewCell {
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var shadowView: ShadowView!
    @IBOutlet weak var stepTextView: UITextView!
    @IBOutlet weak var checkmarkView: UIImageView!
    
    var step: StepData?
    var indexPath: IndexPath!
    var delegate: StepCellDelegate?
    
    static let reuseId: String = "StepTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateTextView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupCard()
        updateTextView()
        updateCheckmark()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateCheckmark()
        delegate?.didSelect(self, atIndexPath: indexPath)
    }
}

extension StepCell {
    fileprivate func setupCard() {
        selectionStyle = .none
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        cellBackgroundView.layer.masksToBounds = true
    }
    
    fileprivate func updateTextView() {
        guard let step = step else {
            print("Warning: No step data attached to StepCell!")
            return
        }
        
        stepTextView.text = step.steps_description
        
        let size = CGSize(width: cellBackgroundView.frame.width, height: .infinity)
        let estimatedSize = stepTextView.sizeThatFits(size)
        
        stepTextView.translatesAutoresizingMaskIntoConstraints = false
        stepTextView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
    
    fileprivate func updateCheckmark() {
        guard let step = step else {
            print("Warning: No step data attached to StepCell!")
            return
        }
        
        guard step.is_complete else {
            checkmarkView.image = nil
            checkmarkView.layer.borderWidth = 4
            checkmarkView.layer.borderColor = UIColor(red: 0.34, green: 0.93, blue: 0.46, alpha: 1).cgColor
            return
        }
        
        checkmarkView.image = UIImage(imageLiteralResourceName: "checkbox")
        checkmarkView.layer.borderWidth = 0
        checkmarkView.layer.borderColor = UIColor.clear.cgColor
    }
}
