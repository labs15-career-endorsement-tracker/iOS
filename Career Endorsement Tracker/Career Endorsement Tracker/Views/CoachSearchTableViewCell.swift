//
//  CoachSearchTableViewCell.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 9/24/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

protocol CoachSearchCellDelegate {
    func didPinStudent(cell: CoachSearchTableViewCell, indexPath: IndexPath, isPinned: Bool)
}

class CoachSearchTableViewCell: UITableViewCell {

    // MARK: - Properties
    let server = Server()
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
    @IBOutlet weak var studentTrackLabel: UILabel!
    // MARK: - Actions
    
    @IBAction func pinStudentBtnPressed(_ sender: UIButton) {
        guard let currentIndexPath = currentIndexPath else {return print("ERROR passing indexPath")}
        
        if pinStudentBtn.titleLabel?.text == "Not Pinned" {
            pinStudentBtn.setTitle("Pinned", for: .normal)
            delegate?.didPinStudent(cell: self, indexPath: currentIndexPath, isPinned: true)
        } else {
            pinStudentBtn.setTitle("Not Pinned", for: .normal)
            delegate?.didPinStudent(cell: self, indexPath: currentIndexPath, isPinned: false)
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

    // MARK: - Setup UI
    
    func updateViews(){
        guard let student = student else {return}
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("no token")
            return
        }
        studentNameLbl.text = student.first_name + " " + student.last_name
        if student.isPinnedBy == nil {
            pinStudentBtn.setTitle("Not Pinned", for: .normal)
        } else {
            pinStudentBtn.setTitle("Pinned", for: .normal)
        }
        server.fetchUser(withId: token, withUserId: student.id) { (user, error) in
            if let error = error {
                print(error)
                return
            }
            if let user = user {
                DispatchQueue.main.async {
                    self.studentTrackLabel.text = user.tracks_title
                }
            }
        }
    }
}
