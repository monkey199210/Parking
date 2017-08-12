//
//  DetailTableViewCell.swift
//  Parking
//
//  Created by Manveer Dodiya on 25/07/17.
//  Copyright © 2017 Manveer Dodiya. All rights reserved.
//

import UIKit
import Firebase

class DetailTableViewCell: UITableViewCell {

    
    @IBOutlet var lblStartTime:UILabel!
    @IBOutlet var lblEndTime:UILabel!
    
    @IBOutlet var btnCancel:UIButton!
    
    @IBOutlet weak var phoneNumber: UIButton!
    @IBOutlet weak var bookedname: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        btnCancel.layer.borderColor = Utility.color(withHexString: appConstants.viewBackgroundColor).cgColor
        btnCancel.layer.borderColor = UIColor.red.cgColor
        btnCancel.layer.borderWidth = 1
        btnCancel.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setBookedInfo(_ UserID: String)
    {
        
        
        
    }

    @IBAction func callAction(_ sender: Any) {
        let btnCall = sender as! UIButton
        
        if let url = URL(string: "tel://\(String(describing: btnCall.titleLabel?.text))"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
