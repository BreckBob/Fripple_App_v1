//
//  SentTableViewCell.swift
//  Fripple_App_v1
//
//  Created by Bob McGinn on 12/10/15.
//  Copyright © 2015 REM Designs. All rights reserved.
//

import UIKit

class SentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var numberOfContactsLabel: UILabel!
    @IBOutlet weak var surveyType: UIImageView!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var seeResults: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
