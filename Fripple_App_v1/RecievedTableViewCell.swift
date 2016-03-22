//
//  RecievedTableViewCell.swift
//  Fripple_App_v1
//
//  Created by Bob McGinn on 12/6/15.
//  Copyright © 2015 REM Designs. All rights reserved.
//

import UIKit

class RecievedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var surveySender: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var surveyType: UIImageView!
    @IBOutlet weak var takeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
