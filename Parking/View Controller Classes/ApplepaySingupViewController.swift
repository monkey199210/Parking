//
//  ApplepaySingupViewController.swift
//  Parking
//
//  Created by Manveer Dodiya on 17/07/17.
//  Copyright © 2017 Manveer Dodiya. All rights reserved.
//

import UIKit
import PassKit
import Firebase
import Stripe

class ApplepaySingupViewController: UIViewController, PKPaymentAuthorizationViewControllerDelegate {

    
        let Delegate = UIApplication.shared.delegate as! AppDelegate
    let SupportedPaymentNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]
    let ApplePaySwagMerchantID = "merchant.pineapple.computer"//"<TODO - Your merchant ID>" // This should be <your> merchant ID
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping ((PKPaymentAuthorizationStatus) -> Void)) {
        completion(PKPaymentAuthorizationStatus.success)
        
        STPAPIClient.shared().createToken(with: payment) { (token: STPToken?, error: Error?) in
            
            
            //            submitTokenToBackend(token, completion: { (error: Error?) in
            if let _ = error {
                // Present error to user...
                print(token?.tokenId ?? "")
                // Notify payment authorization view controller
                completion(.failure)
            }
            else {
                // Save payment success
                //                    paymentSucceeded = true
                
                // Notify payment authorization view controller
                completion(.success)
                let userID = FIRAuth.auth()?.currentUser?.uid
                let databaseRef = FIRDatabase.database().reference()
                
                databaseRef.child("Users").child(userID!).child("ApplePay").setValue("Yes")
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let strDate =  dateFormatter.string(from: NSDate() as Date)
                databaseRef.child("Users").child(userID!).child("PurchasedDate").setValue(strDate)
                self.Delegate.setUID(strUID: userID!)
                self.Delegate.setLoginType(strType: "RentOutSpace")
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let objController = storyBoard.instantiateViewController(withIdentifier: "detailsView") as! DetailsViewController
                
                //        objController.strFromSignupLogin = "Yes"
                
                
                
                self.navigationController?.pushViewController(objController, animated: true)

            }
            //            })
        }
        
        

    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    private func checkApplePayAvaliable() -> Bool {
        if !PKPaymentAuthorizationViewController.canMakePayments() {
            let alertController = UIAlertController(
                title: "error",
                message: "This device does not support Apple Pay",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            // buttonArea.isHidden = true
            
            return false
        }
        return true
    }
    
    private var supportedPaymentNetworks: [PKPaymentNetwork] {
        get {
            if #available(iOS 10.0, *) {
                return PKPaymentRequest.availableNetworks()
            } else {
                return [.visa, .masterCard, .amex]
            }
        }
    }
    
    private func checkPaymentNetworksAvaliable(usingNetworks networks: [PKPaymentNetwork]) {
        if !PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: networks) {
            let alertController = UIAlertController(
                title: "The settlement method is not registered",
                message: "Would you like to register payment method now",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { action in
                if #available(iOS 8.3, *) {
                    PKPassLibrary().openPaymentSetup()
                }
            }))
            alertController.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func makePayment(sender: AnyObject)
    {
        
        
        if checkApplePayAvaliable() {
            checkPaymentNetworksAvaliable(usingNetworks: SupportedPaymentNetworks)
            let request = PKPaymentRequest()
            request.merchantIdentifier = ApplePaySwagMerchantID
            request.supportedNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]
            request.merchantCapabilities = PKMerchantCapability.capability3DS
            request.countryCode = "US";
            request.currencyCode = "USD";
            request.paymentSummaryItems = [PKPaymentSummaryItem(label: "", amount: NSDecimalNumber.init(string: String(4.99)))]
            
            let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
            applePayController.delegate = self
            if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: supportedPaymentNetworks) {
                self.present(applePayController, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(
                    title: "The settlement method is not registered",
                    message: "Would you like to register payment method now",
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { action in
                    if #available(iOS 8.3, *) {
                        PKPassLibrary().openPaymentSetup()
                    }
                }))
                alertController.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel, handler: nil))
                self.navigationController?.present(alertController, animated: true, completion: nil)
            }
        }
        else
        {
            
        }
        
        
        
        
        
        
        
        
        
        
        
        /* for i:Int in 0..<arrData.count
         {
         
         if (arrData.object(at: i) as! NSDictionary).value(forKey: "Key") as? String == selectedKey
         {
         
         print(arrData.object(at: i) as! NSDictionary)
         
         let databaseRef = FIRDatabase.database().reference()
         
         // let  locationRef = databaseRef.child("Users").childByAutoId()
         //locationRef.setValue(post)
         
         databaseRef.child("RentOutSpace").child(selectedKey).child("availability").setValue("Booked")
         
         viewPopD1.isHidden =  false
         viewPopC1A.isHidden = true
         
         runTimer()
         break;
         }
         
         }*/
        
        
        
    }
    


}
