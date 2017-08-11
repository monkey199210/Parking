//
//  TimeIntervalTableViewCell.swift
//  Parking
//
//  Created by Manveer Dodiya on 06/07/17.
//  Copyright © 2017 Manveer Dodiya. All rights reserved.
//

import UIKit

class TimeIntervalTableViewCell: UITableViewCell {

    
    @IBOutlet var btnStartTime:UIButton!
    @IBOutlet var btnEndTime:UIButton!
    
    @IBOutlet var txtNote:UITextField!
    
    @IBOutlet var lblStartDate:UILabel!
    @IBOutlet var lblEndDate:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
