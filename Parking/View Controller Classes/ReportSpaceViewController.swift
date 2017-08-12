//
//  ReportSpaceViewController.swift
//  Parking
//
//  Created by Manveer Dodiya on 13/07/17.
//  Copyright © 2017 Manveer Dodiya. All rights reserved.
//

import UIKit

class ReportSpaceViewController: UIViewController {

    let Delegate = UIApplication.shared.delegate as! AppDelegate
    var UID = ""
    
     @IBOutlet var txtNumPlate:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setupUI()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Custom Methods

    func setupUI()
    {
        self.view.backgroundColor = Utility.color(withHexString: appConstants.viewBackgroundColor)
        
        
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
    
    
    
    
    
    @IBAction func SubmitReport(sender: AnyObject)
    {
          self.view.endEditing(true)
        
//        let msg = String.init(format: "Someone with license plate number %@ is illegally occupying your parking space on Driveway. Check that this is the case before taking further action.", txtNumPlate.text!)
        
//        Delegate.API_SendNotfication(userID: UID, message: txtNumPlate.text!)
        if txtNumPlate.text! == ""
        {
            return
        }
        
        Delegate.setReportSubmitText(strType: txtNumPlate.text!)
        
        txtNumPlate.text = ""
        Utility.alert("Successfully sent message", andTitle: "", andController: self)
    }
}
