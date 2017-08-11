//
//  SignUpRentOutSpaceViewController.swift
//  Parking
//
//  Created by Manveer Dodiya on 28/06/17.
//  Copyright © 2017 Manveer Dodiya. All rights reserved.
//

import UIKit
import Firebase

class SignUpRentOutSpaceViewController: UIViewController {

    let Delegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var scroller:TPKeyboardAvoidingScrollView!
    @IBOutlet var btnRentOutSpace:UIButton!
    @IBOutlet var btnAgreed:UIButton!
    
    @IBOutlet var txtName:UITextField!
    @IBOutlet var txtEmail:UITextField!
    @IBOutlet var txtPhone:UITextField!
    @IBOutlet var txtStreet:UITextField!
    @IBOutlet var txtCity:UITextField!
    @IBOutlet var txtState:UITextField!
    @IBOutlet var txtCountry:UITextField!
    @IBOutlet var txtZipCode:UITextField!
    @IBOutlet var txtPassword:UITextField!
    @IBOutlet var txtVerifyPassword:UITextField!
    
    var arrUserList:NSMutableArray!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        arrUserList = NSMutableArray()
        
        // Do any additional setup after loading the view.
         scroller.contentSizeToFit()
        setupUI()
        
        getAllUserListFromServer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Custom Methods
    
    func setupUI()
    {
        self.view.backgroundColor = Utility.color(withHexString: appConstants.viewBackgroundColor)
        btnRentOutSpace.layer.cornerRadius = 5
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }

    
    
    func getAllUserListFromServer()
    {
        
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let parentRef = FIRDatabase.database().reference().child("Users")
        parentRef.observe(.value, with: { snapshot in
            
            // NSLog("chil %@", snapshot.value! as! NSDictionary)
            
            self.arrUserList.removeAllObjects()
            
            /* if snapshot.value != nil
             {
             if !(snapshot.value  is NSNull)
             {
             self.arrBookingList = (snapshot.value as! NSArray).mutableCopy() as! NSMutableArray
             }
             }*/
            
            
            parentRef.removeAllObservers()
            
            
            
            
            
            for child in snapshot.children {
                
                
                self.arrUserList.add((child as! FIRDataSnapshot).value ?? "")
                
                
               
                
                
            }
            
            
            
            print(self.arrUserList)
            
            
            
            
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            
        })
    }

    
    //MARK: - IBActions
    
    @IBAction func Showterm_Condition(sender: AnyObject)
    {
        //Utility.alert("Terms and Condition data", andTitle: appConstants.AppName, andController: self)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let objController = storyBoard.instantiateViewController(withIdentifier: "termsCondition") as! TermsConditionViewController
        objController.conditionType = "RentOutSpace"
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
    
    @IBAction func SubmitSignUpRentOutSpace(sender: AnyObject)
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
        
        
        
        let street=txtStreet.text;
        if(street?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            Utility.alert("Please enter street", andTitle: appConstants.AppName, andController: self)
            return;
        }
        
        
        let city=txtCity.text;
        if(city?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            Utility.alert("Please enter city", andTitle: appConstants.AppName, andController: self)
            return;
        }
        
        
        let state=txtState.text;
        if(state?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            Utility.alert("Please enter state", andTitle: appConstants.AppName, andController: self)
            return;
        }
        
        
        let country=txtCountry.text;
        if(country?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            Utility.alert("Please enter country", andTitle: appConstants.AppName, andController: self)
            return;
        }
        
        
        let zipCode=txtZipCode.text;
        if(zipCode?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            Utility.alert("Please enter zip code", andTitle: appConstants.AppName, andController: self)
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
        
       var isTrue = true
        
        for tempDict in arrUserList
        {
            if ((tempDict as! NSDictionary).value(forKey: "Street") as? String == street)
                && ((tempDict as! NSDictionary).value(forKey: "City") as? String == city)
                && ((tempDict as! NSDictionary).value(forKey: "State") as? String == state)
            && ((tempDict as! NSDictionary).value(forKey: "Country") as? String == country)
            {
                  //Utility.alert("This Address Already Exists", andTitle: "", andController: self)
                isTrue = false
                break
            }
            
            

        }
        
        
        
        
        
        if isTrue
        {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            (FIRAuth.auth()?.createUser(withEmail: txtEmail.text!, password: txtPassword.text!, completion: {
                
                (user, error) in
                
                // NSLog("error %@", error!.localizedDescription)
                
                guard let user = user, error == nil else {
                    
                    Utility.alert(error?.localizedDescription, andTitle: "", andController: self)
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    return
                }
                
                // Finally, save their profile
                self.saveUserInfo(user, withUsername: self.txtName.text!)
                
                
                
                
                
                
            }))!
            
        }
        else
        {
           Utility.alert("This Address Already Exists", andTitle: "", andController: self) 
        }
        
        
        
        
        
        
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
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                return
            }
            
            
            
         
            let addressString = String.init(format: "%@, %@, %@, %@, %@", self.txtStreet.text!, self.txtCity.text!, self.txtState.text!, self.txtCountry.text!, self.txtZipCode.text!)
            
            print(addressString)
            
            
            let cordinates = Utility.getLocationFromAddressString(addressString) as CLLocationCoordinate2D
            
            print(Utility.getLocationFromAddressString(addressString))
            

            
            
           
            
            // [START basic_write]
            let post : [String: AnyObject] = ["Name" : self.txtName.text as AnyObject, "EmailAddress" : self.txtEmail.text as AnyObject, "Phone" : self.txtPhone.text as AnyObject , "Street" : self.txtStreet.text as AnyObject, "City" : self.txtCity.text as AnyObject, "State" : self.txtState.text as AnyObject, "Country" : self.txtCountry.text as AnyObject, "ZipCode" : self.txtZipCode.text as AnyObject, "Password" : self.txtPassword.text as AnyObject, "UserType" : "RentOutSpace" as AnyObject, "availCount" : "0" as AnyObject, "lat" : cordinates.latitude as AnyObject, "long" : cordinates.longitude as AnyObject , "ApplePay" : "No" as AnyObject, "Enable" : "Yes" as AnyObject]
            
            var databaseRef = FIRDatabase.database().reference()
            
            // let  locationRef = databaseRef.child("Users").childByAutoId()
            //locationRef.setValue(post)
            
            databaseRef.child("Users").child(user.uid).setValue(post)
            
            //Utility.alert("Registraion Succesfull", andTitle: "", andController: self)
            
            
            ///// notification
             databaseRef = FIRDatabase.database().reference()
            let  locationRef = databaseRef.child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).child("deviceToken")
            var token = FIRInstanceID.instanceID().token()
            
            token = token?.replacingOccurrences(of: "Optional(\"", with: "")
            token = token?.replacingOccurrences(of: "\")", with: "")
            
            locationRef.setValue(token)
            
              FIRMessaging.messaging().subscribe(toTopic: (FIRAuth.auth()?.currentUser?.uid)!)
            
            
            ////////////////////////
            
            
            self.Delegate.setUID(strUID: user.uid)
            self.Delegate.setLoginType(strType: "RentOutSpace")
            
            
            self.txtName.text = ""
            self.txtPassword.text = ""
            self.txtVerifyPassword.text = ""
            self.txtEmail.text = ""
            self.txtPhone.text = ""
            self.txtState.text = ""
            self.txtStreet.text = ""
            self.txtCity.text = ""
            self.txtCountry.text = ""
            self.txtZipCode.text = ""
            // [END basic_write]
            
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            
            //Utility.alert("Succesfully Register", andTitle: appConstants.AppName, andController: self)
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
           // let objController = storyBoard.instantiateViewController(withIdentifier: "mapSpaceOut") as! mapSpaceOutRentViewController
           // let objController = storyBoard.instantiateViewController(withIdentifier: "addDetails") as! AddDetailsViewController
            let objController = storyBoard.instantiateViewController(withIdentifier: "applePaySignup") as! ApplepaySingupViewController
            
            
            //objController.strFromSignupLogin = "Yes"
            
            self.navigationController?.pushViewController(objController, animated: true)
            
            //            self.appDelegate.setIsLoginStatus()
            //
            //            let objController = NewsViewController()
            //            self.navigationController?.pushViewController(objController, animated: true)
            
        }
        
    }
    
    
    
    
    
    
    


}
