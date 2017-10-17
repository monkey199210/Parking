//
//  SignUpRentSpaceViewController.swift
//  Parking
//
//  Created by Manveer Dodiya on 28/06/17.
//  Copyright © 2017 Manveer Dodiya. All rights reserved.
//

import UIKit

import Firebase

class SignUpRentSpaceViewController: UIViewController {

    let Delegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var scroller:TPKeyboardAvoidingScrollView!
    @IBOutlet var btnRentSpace:UIButton!
    @IBOutlet var btnAgreed:UIButton!
    
    @IBOutlet var txtName:UITextField!
    @IBOutlet var txtEmail:UITextField!
    @IBOutlet var txtPhone:UITextField!
    @IBOutlet var txtLicenseNumber:UITextField!
    @IBOutlet var txtPassword:UITextField!
    @IBOutlet var txtVerifyPassword:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         scroller.contentSizeToFit()
        setupUI()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    // MARK: - Custom Methods

    func setupUI()
    {
        self.view.backgroundColor = Utility.color(withHexString: appConstants.viewBackgroundColor)
        btnRentSpace.layer.cornerRadius = 5
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        
       
        
    }
    
    
    
    
    
    
    
    
    
    //MARK: - IBActions
    
    
    
    
     @IBAction func Showterm_Condition(sender: AnyObject)
    {
           // Utility.alert("Terms and Condition data", andTitle: appConstants.AppName, andController: self)
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let objController = storyBoard.instantiateViewController(withIdentifier: "termsCondition") as! TermsConditionViewController
        objController.conditionType = "RentSpace"
       // self.presentViewController(nextViewController, animated:true, completion:nil)
        self.navigationController?.pushViewController(objController, animated: true)
    }
    
    @IBAction func textLimit(sender: AnyObject)
    {
       
       let txtField = sender as! UITextField
        
        
        let text=txtField.text;
        
        
        if ((text?.characters.count)!>25)
        {
            //print("manveer")
            txtField.text = text?.substring(to: (text?.index(before: (text?.endIndex)!))!)
            
        }
    }
    
    
    
    @IBAction func AgreedTermCondition(sender: AnyObject)
    {
        
        if btnAgreed.isSelected
        {
             btnAgreed.isSelected = false
        }
        else
        {
             btnAgreed.isSelected = true
        }
      
        
    }
    
    @IBAction func SubmitSignUpRentSpace(sender: AnyObject)
    {
        
        
        let name=txtName.text;
        if(name?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            Utility.alert("Please enter name", andTitle: appConstants.AppName, andController: self)
            return;
        }
        
        
        let email=txtEmail.text;
        if(email?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            Utility.alert("Please enter email", andTitle: appConstants.AppName, andController: self)
            return;
        }
        
        
        if(appConstants.isValidEmailAddress(emailAddressString: email!)==false){
            
            Utility.alert("Invalid email format", andTitle: appConstants.AppName, andController: self)
            return;
        }
        
        
        let phone=txtPhone.text;
        if(phone?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            Utility.alert("Please enter phone number", andTitle: appConstants.AppName, andController: self)
            return;
        }
        
        
        
        let licenseNumber=txtLicenseNumber.text;
        if(licenseNumber?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            Utility.alert("Please enter license plate number", andTitle: appConstants.AppName, andController: self)
            return;
        }
        
        
        
        let password=txtPassword.text;
        if(password?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            Utility.alert("Please enter password", andTitle: appConstants.AppName, andController: self)
            return;
        }
        
        if !(Utility.validatePassword(withString: txtPassword)) {
            Utility.alert("Password length shoud be 8 character and atleast have one numeric digit", andTitle: appConstants.AppName, andController: self)
            return;
        }
        
        
        let verifyPassword = txtVerifyPassword.text;
        if(verifyPassword?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            Utility.alert("Please enter verify password", andTitle: appConstants.AppName, andController: self)
            return;
        }
        
        
        if (password != verifyPassword)
        {
            Utility.alert("Password not match", andTitle: appConstants.AppName, andController: self)
            return;
        }
        
        
        if (btnAgreed.isSelected == false)
        {
            Utility.alert("Please agreed with terms and conditions", andTitle: appConstants.AppName, andController: self)
            return;
        }

        
        self.view.endEditing(true)
        
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
       
            (FIRAuth.auth()?.createUser(withEmail: txtEmail.text!, password: txtPassword.text!, completion: {
                
                (user, error) in
                
                // NSLog("error %@", error!.localizedDescription)
                
                guard let user = user, error == nil else {
                    
                    Utility.alert(error?.localizedDescription, andTitle: "", andController: self)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    return
                }
                
                // Finally, save their profile
                self.saveUserInfo(user, withUsername: self.txtName.text!)
                
                
                
                
                
                
            }))!
        
        
    }
    
    
    
    // Saves user profile information to user database
    func saveUserInfo(_ user: FIRUser, withUsername username: String) {
        
        // Create a change request
        //self.showSpinner {}
        let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest()
        changeRequest?.displayName = username
        
        // Commit profile changes to server
        changeRequest?.commitChanges() { (error) in
            
            // self.hideSpinner {}
            
            if let error = error {
                // self.showMessagePrompt(error.localizedDescription)
                Utility.alert(error.localizedDescription, andTitle: "", andController: self)
                MBProgressHUD.hide(for: self.view, animated: true)
                return
            }
            
            // [START basic_write]
            let post : [String: AnyObject] = ["Name" : self.txtName.text as AnyObject, "EmailAddress" : self.txtEmail.text as AnyObject, "Phone" : self.txtPhone.text as AnyObject , "LicenseNumber" : self.txtLicenseNumber.text as AnyObject, "Password" : self.txtPassword.text as AnyObject, "UserType" : "RentSpace" as AnyObject, "Enable" : "Yes" as AnyObject,"BookingStartTime":"" as AnyObject, "Price":"" as AnyObject, "Hours":"" as AnyObject,"Logined":"" as AnyObject]
            
            var databaseRef = FIRDatabase.database().reference()
            
            // let  locationRef = databaseRef.child("Users").childByAutoId()
            //locationRef.setValue(post)
            
            databaseRef.child("Users").child(user.uid).setValue(post)
            
           
            
            
            ///// for device token
            databaseRef = FIRDatabase.database().reference()
            let  locationRef = databaseRef.child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).child("deviceToken")
            var token = FIRInstanceID.instanceID().token()
            
            token = token?.replacingOccurrences(of: "Optional(\"", with: "")
            token = token?.replacingOccurrences(of: "\")", with: "")
            
            locationRef.setValue(token)
            
              FIRMessaging.messaging().subscribe(toTopic: (FIRAuth.auth()?.currentUser?.uid)!)
            //////////////////////////
            
            
            
            //Utility.alert("Registraion Succesfull", andTitle: "", andController: self)
            
             self.Delegate.setUID(strUID: user.uid)
            self.Delegate.setLoginType(strType: "RentSpace")
            
            
            self.txtName.text = ""
            self.txtPassword.text = ""
            self.txtVerifyPassword.text = ""
            self.txtEmail.text = ""
            self.txtPhone.text = ""
            self.txtLicenseNumber.text = ""
            // [END basic_write]
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            //Utility.alert("Succesfully Register", andTitle: appConstants.AppName, andController: self)
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let objController = storyBoard.instantiateViewController(withIdentifier: "mapSpace") as! mapSpaceRentViewController
            
            self.navigationController?.pushViewController(objController, animated: true)
//            self.appDelegate.setIsLoginStatus()
//            
//            let objController = NewsViewController()
//            self.navigationController?.pushViewController(objController, animated: true)
            
        }
        
    }


}
