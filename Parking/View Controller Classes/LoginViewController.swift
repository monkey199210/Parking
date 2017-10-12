//
//  LoginViewController.swift
//  Parking
//
//  Created by Manveer Dodiya on 28/06/17.
//  Copyright © 2017 Manveer Dodiya. All rights reserved.
//

import UIKit
import Firebase


class LoginViewController: UIViewController {
    
    let Delegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var btnRentSpace:UIButton!
    @IBOutlet var btnRentOutSpace:UIButton!
    
    @IBOutlet var txtEmail:UITextField!
    @IBOutlet var txtPassword:UITextField!
    
    var strLoginType:String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setupUI()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.callNavigationController), name: Notification.Name("callNavigation"), object: nil)
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        txtEmail.text = ""
        txtPassword.text = ""
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    
    //MARK: - Custom Methods
    
    func setupUI()
    {
        self.navigationController?.navigationBar.barTintColor = Utility.color(withHexString: appConstants.navColor)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.view.backgroundColor = Utility.color(withHexString: appConstants.viewBackgroundColor)
        
        self.title = "Sign In"
        
        
        // let btnSingUp = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 50))
        
        // btnSingUp.setTitle("Sign Up", for: .normal)
        //btnSingUp.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btnSingUp)
        
        
        btnRentSpace.layer.cornerRadius = 5
        btnRentOutSpace.layer.cornerRadius = 5
        
        
    }
    
    
    func showTutorial2() {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let objController = storyBoard.instantiateViewController(withIdentifier: "mapSpaceOut") as! mapSpaceOutRentViewController
        
        self.navigationController?.pushViewController(objController, animated: true)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    func callNavigationController()
    {
        self.performSegue(withIdentifier: "test", sender: self)
        /*let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
         let objController = storyBoard.instantiateViewController(withIdentifier: "mapSpaceOut") as! mapSpaceOutRentViewController
         
         self.navigationController?.pushViewController(objController, animated: true)*/
    }
    
    
    
    
    
    
    
    //MARK: - IBActions
    
    @IBAction func SubmitLogin(sender: AnyObject)
    {
        
        
        
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
        
        
        self.view.endEditing(true)
        
        
        
        if(sender as! NSObject == btnRentSpace)
        {
            strLoginType = "RentSpace"
        }
        else if(sender as! NSObject == btnRentOutSpace)
        {
            strLoginType = "RentOutSpace"
        }
        
        
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let usersessionIfActive = FIRAuth.auth()?.currentUser
        if usersessionIfActive != nil
        {
            try! FIRAuth.auth()?.signOut()
        }
        
        
        
        
        
        
        FIRAuth.auth()?.signIn(withEmail: txtEmail.text!, password: txtPassword.text!, completion: { (user, error) in
            
            
            
            if user == nil
            {
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                Utility.alert(error?.localizedDescription, andTitle: "", andController: self)
                
            }
            else
            {
                
                
                
                // self.appDelegate.setIsLoginStatus()
                
                
                
                
                //let objController = NewsViewController()
                //self.navigationController?.pushViewController(objController, animated: true)
                
                /* let databaseRef = FIRDatabase.database().reference()
                 
                 
                 
                 databaseRef.child("Users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                 
                 // Check if user already exists
                 NSLog("snapshot %@", snapshot.description)
                 
                 guard !snapshot.exists() else {
                 // self.performSegue(withIdentifier: "signIn", sender: nil)
                 // Utility.alert("Login Successful", andTitle: "", andController: self)
                 //return
                 
                 NSLog("during login uniqu key %@", self.appDelegate.getUniqueInstallKey())
                 let databaseRef = FIRDatabase.database().reference()
                 
                 let  locationRef = databaseRef.child("Users").child((user?.uid)!).child("UniqueInstallKey")
                 locationRef.setValue(self.appDelegate.getUniqueInstallKey())
                 
                 
                 
                 MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                 self.appDelegate.setIsLoginStatus()
                 
                 let objController = NewsViewController()
                 self.navigationController?.pushViewController(objController, animated: true)
                 return
                 }
                 })*/
                
                
                
                
                
                
                ////// for device token /////
                let databaseRef = FIRDatabase.database().reference()
                let  locationRef = databaseRef.child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).child("deviceToken")
                
                var token = FIRInstanceID.instanceID().token()
                
                token = token?.replacingOccurrences(of: "Optional(\"", with: "")
                token = token?.replacingOccurrences(of: "\")", with: "")
                
                locationRef.setValue(token)
                
                FIRMessaging.messaging().subscribe(toTopic: (FIRAuth.auth()?.currentUser?.uid)!)
                
                ////// for device token /////
                
                
                
                
                let ref = FIRDatabase.database().reference()
                
                let userID = FIRAuth.auth()?.currentUser?.uid
                ref.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    let value = snapshot.value as? NSDictionary
                    let userType = value?["UserType"] as? String ?? ""
                    //let user = User.init(username: username)
                    print(value)
                    
                    // Utility.alert("Successfully Login as", andTitle: appConstants.AppName, andController: self)
                    
                    
                    
                    
                    
                    
                    
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    
                    var overDate = true
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    
                    if let purchasedDateStr = value?["PurchasedDate"] as? String
                    {
                        if  let purchasedDate = dateFormatter.date(from: purchasedDateStr)
                        {
                            if Int(NSDate().timeIntervalSince1970 - purchasedDate.timeIntervalSince1970) < 60 * 60 * 24 * 30
                            {
                                overDate = false
                            }
                        }
                    }
                    
                    
                    if value?["Enable"] as? String ?? "" == "Yes"
                    {
                        if (userType == self.strLoginType)
                        {
                            if userType == "RentOutSpace" && (value?["ApplePay"] as? String ?? "" != "Yes" || overDate)
                            {
                                self.showPurchase()
                                return;
                            }
                            //  navigate depends on login type
                            
                            
                            self.Delegate.setUID(strUID: userID!)
                            
                            if(userType == "RentSpace")
                            {
                                
                                self.Delegate.setLoginType(strType: "RentSpace")
                                
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                let objController = storyBoard.instantiateViewController(withIdentifier: "mapSpace") as! mapSpaceRentViewController
                                self.navigationController?.pushViewController(objController, animated: true)
                            }
                            else
                            {
                                
                                self.Delegate.setLoginType(strType: "RentOutSpace")
                                
                                
                                //                           if  value?["availCount"] as? String == "0"
                                //                           {
                                //                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                //                          //  let objController = storyBoard.instantiateViewController(withIdentifier: "mapSpaceOut") as! mapSpaceOutRentViewController
                                //                            let objController = storyBoard.instantiateViewController(withIdentifier: "addDetails") as! AddDetailsViewController
                                //                             objController.strFromSignupLogin = "Yes"
                                //                            self.navigationController?.pushViewController(objController, animated: true)
                                //                            }
                                //                            else
                                //                           {
                                
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                //  let objController = storyBoard.instantiateViewController(withIdentifier: "mapSpaceOut") as! mapSpaceOutRentViewController
                                let objController = storyBoard.instantiateViewController(withIdentifier: "detailsView") as! DetailsViewController
                                self.navigationController?.pushViewController(objController, animated: true)
                                
                                //                            }
                                
                            }
                        }
                        else
                        {
                            //  navigate depends on login type
                            Utility.alert("Invalid Login", andTitle: appConstants.AppName, andController: self)
                        }
                    }
                        
                    else
                    {
                        Utility.alert("Your account is deactivated", andTitle: appConstants.AppName, andController: self)
                    }
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                    // ...
                }) { (error) in
                    print(error.localizedDescription)
                    
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                }
                
            }
            
        })
        
    }
    
    
    
    
    
    @IBAction func ForgetPassword(sender: AnyObject)
    {
        Utility.alert("If you forgot your password please visit our website and contact us.", andTitle: "", andController: self)
    }
    
    
    
    
    
    
    
    @IBAction func DeactivateAccount(sender: AnyObject)
    {
        
        
        
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
        
        
        self.view.endEditing(true)
        
        
        
        if(sender as! NSObject == btnRentSpace)
        {
            strLoginType = "RentSpace"
        }
        else if(sender as! NSObject == btnRentOutSpace)
        {
            strLoginType = "RentOutSpace"
        }
        
        
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let usersessionIfActive = FIRAuth.auth()?.currentUser
        if usersessionIfActive != nil
        {
            try! FIRAuth.auth()?.signOut()
        }
        
        
        
        
        
        
        FIRAuth.auth()?.signIn(withEmail: txtEmail.text!, password: txtPassword.text!, completion: { (user, error) in
            
            
            
            if user == nil
            {
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                Utility.alert(error?.localizedDescription, andTitle: "", andController: self)
                
            }
            else
            {
                
                
                
                
                let databaseRef = FIRDatabase.database().reference()
                
                // let  locationRef = databaseRef.child("Users").childByAutoId()
                //locationRef.setValue(post)
                
                databaseRef.child("Users").child((user?.uid)!).child("Enable").setValue("No")
                
                
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                
                
                Utility.alert("Your account is deactivated. Please visit our website and contact us if you would like to reactivate your account.", andTitle: appConstants.AppName, andController: self)
                
                
            }
            
        })
        
    }
    
    func showPurchase()
    {
        let alert = UIAlertController(title: appConstants.AppName, message: "Your rent out space account have to purchase", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(defaultAction)
        alert.addAction(UIAlertAction(title: "Purchase Now", style: .default) { action in
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "applePaySignup") as! ApplepaySingupViewController
            self.navigationController?.pushViewController(vc, animated: true)
        })
        self.present(alert, animated: true)
    }
    
    
    /* func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
     {
     if segue.identifier == "test"{
     var vc = segue.destination as! mapSpaceOutRentViewController
     //vc.data = "Data you want to pass"
     //Data has to be a variable name in your RandomViewController
     }
     }*/
    
    
}
