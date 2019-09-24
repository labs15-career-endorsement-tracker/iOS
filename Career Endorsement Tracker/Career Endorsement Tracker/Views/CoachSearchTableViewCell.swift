//
//  CoachSearchTableViewCell.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 9/24/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

protocol CoachSearchCellDelegate {
    func didPinStudent(cell: UITableViewCell, indexPath: IndexPath)
}

class CoachSearchTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    var student: CurrentUser? {
        didSet {
            updateViews()
        }
    }
    var delegate: CoachSearchCellDelegate?
    var currentIndexPath: IndexPath?
    
    // MARK: - Outlets
    
    @IBOutlet weak var pinStudentBtn: UIButton!
    @IBOutlet weak var studentNameLbl: UILabel!
    
    // MARK: - Actions
    
    @IBAction func pinStudentBtnPressed(_ sender: UIButton) {
        guard let currentIndexPath = currentIndexPath else {return print("ERROR passing indexPath")}
        delegate?.didPinStudent(cell: self, indexPath: currentIndexPath)
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

    // MARK: - Setup UI
    
    func updateViews(){
        guard let student = student else {return}
        studentNameLbl.text = student.first_name + " " + student.last_name
        
    }
}
