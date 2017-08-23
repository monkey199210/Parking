//
//  mapSpaceRentViewController.swift
//  Parking
//
//  Created by Manveer Dodiya on 13/07/17.
//  Copyright © 2017 Manveer Dodiya. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import PassKit

class mapSpaceRentViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, PKPaymentAuthorizationViewControllerDelegate, UIPickerViewDelegate, UINavigationControllerDelegate{
    
    
    let Delegate = UIApplication.shared.delegate as! AppDelegate
    
    
    let SupportedPaymentNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]
    let ApplePaySwagMerchantID = "merchant.com.Parking.ios"//"<TODO - Your merchant ID>" // This should be <your> merchant ID
    
    
    var arrBookingList:NSMutableArray!
    var arrData:NSMutableArray!
    var dictMainData:NSMutableDictionary!
    var mapView:GMSMapView!
    
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    var selectedKey:String = ""
    var currentParkingOwnerUID:String = ""
    
    var currentBookingData:NSMutableDictionary = [:]
    var currentBookingPrimaryKey:String = ""
    var currentBookingPrimaryKeys = [""]
    
    @IBOutlet var viewMapContainer:UIView!
    
    
    
    
    @IBOutlet var viewPopC1A:UIView!
    @IBOutlet var lblAddressC1A:UILabel!
    @IBOutlet var lblNoteC1A:UILabel!
    @IBOutlet var lblPriceC1A:UILabel!
    @IBOutlet var lblHourC1A:UILabel!
    @IBOutlet var btnApplePay:UIButton!
    
    
    @IBOutlet var viewPopD1:UIView!
    @IBOutlet var lblTimerD1:UILabel!
    @IBOutlet var lblPriceD1:UILabel!
    @IBOutlet var lblHourD1:UILabel!
    @IBOutlet var lblContactNameD1:UILabel!
    @IBOutlet var btnSelectHourD1:UIButton!
    @IBOutlet var btnContactNumberD1:UIButton!
    
    
    var amount:Int = 0
    var seconds = 14400
    
    
    //var seconds = 60
    var timer:Timer?
    
    
    let pickerDataHours:NSMutableArray = []
    
    var myPicker:UIPickerView!
    
    var myFlag:NSString!
    
    var BookingHours:Int=0
    
    override func viewDidLoad()
    {
        
        arrData=NSMutableArray()
        arrBookingList=NSMutableArray()
        
        
        
        super.viewDidLoad()
        setupUI()
        
        
        let camera = GMSCameraPosition.camera(withLatitude:51.5033640 , longitude: -0.1276250, zoom: 10.0)
        mapView = GMSMapView.map(withFrame: viewMapContainer.bounds, camera: camera)
        mapView.delegate = self
        viewMapContainer.addSubview(mapView)
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation() // start location manager
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        myFlag=""
        Delegate.mySeconds=0
        
        
        
        
        getBookingListFromServer()
        
    }
    
    
    
    // MARK: - Custom Methods
    func setupUI()
    {
        self.view.backgroundColor = Utility.color(withHexString: appConstants.viewBackgroundColor)
        self.navigationItem.hidesBackButton = true
        
        
        self.view.layoutIfNeeded()
        self.navigationController?.navigationBar.barTintColor = Utility.color(withHexString: appConstants.navColor)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.view.backgroundColor = Utility.color(withHexString: appConstants.viewBackgroundColor)
        
        lblHourD1.text=Delegate.getHour()
        lblPriceD1.text=Delegate.getPrice()
    }
    
    
    func getStringFromDate(strDate: NSDate)-> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        
        return dateFormatter.string(from: strDate as Date)
    }
    
    
    func getDateFromTime(strDate: String)-> Date?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy hh:mm a"
        if let time = dateFormatter.date(from: strDate)
        {
            return time
        }
        return nil
    }
    
    func getMapDataFromServer()
    {
        
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let parentRef = FIRDatabase.database().reference().child("RentOutSpace")
        parentRef.observe(.value, with: { snapshot in
            
            // NSLog("chil %@", snapshot.value! as! NSDictionary)
            
            self.arrData.removeAllObjects()
            
            if snapshot.value != nil
            {
                if !(snapshot.value  is NSNull)
                {
                    self.dictMainData = (snapshot.value as! NSDictionary).mutableCopy() as! NSMutableDictionary
                }
            }
            _ = NSMutableArray()
            
            parentRef.removeAllObservers()
            
            
            print(self.arrData)
            
            
            /*for child in snapshot.children {
             
             print((child as! FIRDataSnapshot).key)
             
             let dataDict = NSMutableDictionary()
             
             dataDict.setValue((child as! FIRDataSnapshot).key, forKey: "Key")
             
             dataDict.setValue((child as! FIRDataSnapshot).value ?? "", forKey: "Value")
             
             arrTempData.add(dataDict)
             }*/
            
            
            
            
            
            
            // self.mapView.clear()
            
            if self.dictMainData != nil
            {
                
                print( self.dictMainData)
                
                let allUserKey = self.dictMainData.allKeys as NSArray
                
                for i:Int in 0..<allUserKey.count
                {
                    
                    
                    let dictUserInfo = self.dictMainData.value(forKey: allUserKey.object(at: i) as! String) as! NSMutableDictionary
                    
                    
                    let today = NSDate()
                    
                    if (dictUserInfo.allKeys as NSArray).contains(self.getStringFromDate(strDate:today ))
                    {
                        if( ((dictUserInfo.value(forKey: self.getStringFromDate(strDate:today )) as! NSDictionary).allKeys as NSArray).contains("timeIntervals"))
                        {
                            var availablePin = false
                            var availableIndex = 0
                            let arrTimeIntervals = (dictUserInfo.value(forKey: self.getStringFromDate(strDate:today )) as! NSDictionary).value(forKey: "timeIntervals") as! NSArray
                            var j = 0
                            for item in arrTimeIntervals
                            {
                                if let bookStatus = (item as! NSDictionary).value(forKey: "BookingStatus") as? String
                                {
                                    if bookStatus != "available"
                                    {
                                        continue
                                    }
                                }
                                if let strTime = self.getDateFromTime(strDate: self.getStringFromDate(strDate:today ) + " " + ((item as! NSDictionary).value(forKey: "StartTime") as! String))
                                {
                                    if let endTime = self.getDateFromTime(strDate: self.getStringFromDate(strDate:today ) + " " + ((item as! NSDictionary).value(forKey: "EndTime") as! String))
                                    {
                                        print(endTime.timeIntervalSince(strTime))
                                        if today.timeIntervalSinceNow < endTime.timeIntervalSinceNow && today.timeIntervalSinceNow > strTime.timeIntervalSinceNow && endTime.timeIntervalSinceNow > (60*60 - 1)
                                        {
                                            availablePin = true
                                            availableIndex = j;
                                            break
                                        }
                                    }
                                }
                                j = j + 1
                            }
                            
                            
                            
                            if availablePin
                            {
                                let dictPinData = arrTimeIntervals.object(at: availableIndex) as! NSMutableDictionary
                                
                                
                                if dictPinData["BookingStatus"] as! String == "available"
                                {
                                    // self.arrData.add(arrTempData.object(at: i) as! NSDictionary)
                                    
                                    print(Double((dictUserInfo.value(forKey: self.getStringFromDate(strDate:today )) as! NSDictionary).value(forKey: "lat")as! Double))
                                    
                                    let marker = GMSMarker()
                                    marker.position = CLLocationCoordinate2D(latitude: Double((dictUserInfo.value(forKey: self.getStringFromDate(strDate:today )) as! NSDictionary).value(forKey: "lat")as! Double), longitude: Double((dictUserInfo.value(forKey: self.getStringFromDate(strDate:today )) as! NSDictionary).value(forKey: "long")as! Double))
                                    
                                    
                                    marker.title = ""
                                    marker.snippet = ""
                                    marker.map = self.mapView
                                    
                                    
                                    dictPinData.setObject(allUserKey.object(at: i) as! String, forKey: "UID" as NSCopying)
                                    dictPinData.setObject(marker.position.latitude, forKey: "lat" as NSCopying)
                                    dictPinData.setObject(marker.position.longitude, forKey: "long" as NSCopying)
                                    dictPinData.setObject((dictUserInfo.value(forKey: self.getStringFromDate(strDate:today )) as! NSDictionary).value(forKey: "NumberOfSpace")as! String, forKey: "NumberOfSpace" as NSCopying)
                                    dictPinData.setObject((dictUserInfo.value(forKey: self.getStringFromDate(strDate:today )) as! NSDictionary).value(forKey: "PricePerSpace")as! String, forKey: "PricePerSpace" as NSCopying)
                                    
                                    marker.userData = dictPinData
                                }
                            }
                            
                            
                            
                            
                            
                            
                            
                        }
                    }
                    
                    
                    
                    
                }
            }
            
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            
        })
    }
    
    
    
    
    
    func getBookingListFromServer()
    {
        
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let parentRef = FIRDatabase.database().reference().child("Booking")
        parentRef.observe(.value, with: { snapshot in
            
            // NSLog("chil %@", snapshot.value! as! NSDictionary)
            
            self.arrBookingList.removeAllObjects()
            
            /* if snapshot.value != nil
             {
             if !(snapshot.value  is NSNull)
             {
             self.arrBookingList = (snapshot.value as! NSArray).mutableCopy() as! NSMutableArray
             }
             }*/
            
            
            parentRef.removeAllObservers()
            
            
            
            
            
            self.BookingHours = 0
            var bookDate:NSDate?
            
            for child in snapshot.children {
                
                print((child as! FIRDataSnapshot).key)
                
                let dataDict = NSMutableDictionary()
                
                dataDict.setValue((child as! FIRDataSnapshot).key, forKey: "Key")
                
                dataDict.setValue((child as! FIRDataSnapshot).value ?? "", forKey: "Value")
                
                self.arrBookingList.add(dataDict)
                
                
                let userID = FIRAuth.auth()?.currentUser?.uid
                if ((child as! FIRDataSnapshot).value as! NSDictionary).value(forKey: "Book_UID") as? String == userID
                {
                    
                    if ((child as! FIRDataSnapshot).value as! NSDictionary).value(forKey: "BookingStatus") as? String == "available"
                    {
                        
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd-MMM-yyyy HH:mm"
                        if bookDate == nil
                        {
                            bookDate = dateFormatter.date(from: ((child as! FIRDataSnapshot).value as! NSDictionary).value(forKey: "bookingDate") as! String)! as NSDate
                        }else{
                            let tempBookDate = dateFormatter.date(from: ((child as! FIRDataSnapshot).value as! NSDictionary).value(forKey: "bookingDate") as! String)! as NSDate
                            if (bookDate?.timeIntervalSince1970)! > tempBookDate.timeIntervalSince1970
                            {
                                bookDate = tempBookDate
                            }
                        }
                        
                        
                        
                        self.BookingHours = self.BookingHours + Int((((child as! FIRDataSnapshot).value as! NSDictionary).value(forKey: "bookingHours") as? String)!)!*3600
                        
                        
                        
                        self.currentParkingOwnerUID = (((child as! FIRDataSnapshot).value as! NSDictionary).value(forKey: "UID") as? String)!
                        
                        
                        
                        self.getOwnerInfo(self.currentParkingOwnerUID)
                        
                        
                        self.currentBookingPrimaryKeys.append((child as! FIRDataSnapshot).key)
                        self.currentBookingData = (child as! FIRDataSnapshot).value as! NSMutableDictionary
                        
                        self.viewPopD1.isHidden =  false
                        self.viewPopC1A.isHidden = true
                        
                    }
                    
                    
                    
                }
                
                
            }
            
            
            
            if let firstBookDate = bookDate
            {
                //// get time difference
                
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "hh:mm a"
                
                
                let strStart = timeFormatter.string(from: Date())
                let startTime = timeFormatter.date(from: strStart)
                
                let strEnd = self.currentBookingData["EndTime"] as? String
                let endTime = timeFormatter.date(from: strEnd!)
                
                //                    let strbBookStart = self.currentBookingData["StartTime"] as? String
                //                    let startBookTime = timeFormatter.date(from: strbBookStart!)
                
                let calendar = Calendar.current
                
                let timeDifference = calendar.dateComponents([.hour], from: startTime!, to: endTime!)
                print(timeDifference.hour ?? "")
                
                //                    let timePeriod = calendar.dateComponents([.hour], from: startBookTime!, to: endTime!)
                //                    if timePeriod.hour != nil
                //                    {
                //                    self.lblHourD1.text = timePeriod.hour?.description
                //                    }else
                //                    {
                //                        self.lblHourD1.text = ""
                //                    }
                if let price = self.currentBookingData["PricePerSpace"] as? String
                {
                    self.lblPriceD1.text = price
                }
                
                
                
                self.pickerDataHours.removeAllObjects()
                if let difHours = timeDifference.hour
                {
                    self.lblHourD1.text =  "\(difHours - self.BookingHours/3600)"
                    if Int(self.lblHourD1.text!)! > 0
                    {
                        
                        for i in 1...Int(self.lblHourD1.text!)!
                        {
                            self.pickerDataHours.add(String(i))
                            
                            
                        }
                    }
                    
                    if(self.pickerDataHours.count > 0)
                    {
                        self.lblHourC1A.text = "\(self.pickerDataHours.count)"
                        //                        self.lblHourD1.text = self.pickerDataHours.lastObject as? String
                        //                        self.lblHourC1A.text = self.pickerDataHours.lastObject as? String
                    }
                    else
                    {
                        
                        self.lblHourD1.text = "0"
                        self.lblHourC1A.text = "0"
                    }
                }
                ////////////////////////////
                

                self.Delegate.setBookingFlag(strDate: "no")
                self.Delegate.setBookingTime(strDate: Int(firstBookDate.timeIntervalSince1970))
                if  Date() < firstBookDate.addingTimeInterval(TimeInterval(self.BookingHours)) as Date
                {
                    
                    
                    
                    self.seconds = Int(firstBookDate.addingTimeInterval(TimeInterval(self.BookingHours)).timeIntervalSince(Date()))
                    
                    self.Delegate.mySeconds=Int(Date().timeIntervalSince1970)-self.Delegate.getBookingTime()
                    
                    //                    self.seconds=BookingHours-self.Delegate.mySeconds
                    
                    
                    
                    //                    print (self.seconds)
                    
                    
                    if (self.BookingHours-(15*60)) > 0
                    {
                        if NSDate().timeIntervalSince1970 < (firstBookDate.addingTimeInterval(TimeInterval((self.BookingHours-(15*60)))) as Date).timeIntervalSince1970
                        {
                        self.Delegate.ScheduleLocalNotification(strMessage: "Your parking time on Driveway is up in 15 minutes, go to the Driveway app to add more time.", time: firstBookDate.addingTimeInterval(TimeInterval((self.BookingHours-(15*60)))) as Date)
                        }
                    }
                    
                    
                    if (self.BookingHours-(5*60)) > 0
                    {
                         if NSDate().timeIntervalSince1970 < (firstBookDate.addingTimeInterval(TimeInterval((self.BookingHours-(5*60)))) as Date).timeIntervalSince1970
                         {
                        self.Delegate.ScheduleLocalNotification(strMessage: "Your parking time on Driveway is up in 5 minutes, if you have not returned to your space or purchased more time, your car may be towed.", time:firstBookDate.addingTimeInterval(TimeInterval((self.BookingHours-(5*60)))) as Date)
                        }
                    }
                    self.runTimer()
                }else{
                    self.endRentPlace()
                }
            }
            
            
            
            print(self.arrBookingList)
            
            
            
            
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            
        })
    }
    
    
    //MARK: - location delegates
    
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapView.isMyLocationEnabled = true
        }
    }
    
    
    func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutableRawPointer) {
        if !didFindMyLocation {
            print(change)
            /*let myLocation: CLLocation = change[NSKeyValueChangeNewKey] as CLLocation
             mapView.camera = GMSCameraPosition.camera(withTarget: myLocation.coordinate, zoom: 10.0)
             mapView.settings.myLocationButton = true
             
             didFindMyLocation = true*/
        }
    }
    
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        mapView.clear()
        
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        
        self.mapView?.animate(to: camera)
        
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        marker.title = "Current Location"
        marker.snippet = ""
        marker.icon = GMSMarker.markerImage(with: UIColor.blue)
        marker.map = mapView
        
        
        
        
        getMapDataFromServer()
        
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
    //MARK: - IBActions
    
    @IBAction func moveReportSpace(sender: AnyObject)
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let objController = storyBoard.instantiateViewController(withIdentifier: "reportSpace") as! ReportSpaceViewController
        objController.UID = currentParkingOwnerUID
        self.navigationController?.pushViewController(objController, animated: true)
    }
    
    @IBAction func SelectHours(sender: AnyObject)
    {
        
        self.view.endEditing(true)
        
        
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        let defaultAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.cancel, handler: {(action:UIAlertAction) in
            
            
            /*if(self.selectedDropDown<self.pickerData.count)
             {
             print("selected value after done \(self.pickerData[self.selectedDropDown])")
             self.txtDropDown.text=self.pickerData[self.selectedDropDown]
             }*/
            
        })
        alertController.addAction(defaultAction)
        
        
        
        
        
        myPicker=UIPickerView()
        myPicker.frame=CGRect(x:0, y:0, width:alertController.view.frame.size.width-20, height:250)
        
        self.myPicker.delegate=self
        
        
        if sender as! NSObject == btnSelectHourD1
        {
            self.myPicker.tag = 20
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "hh:mm a"
            
            
            let strStart = timeFormatter.string(from: Date())
            let startTime = timeFormatter.date(from: strStart)
            
            let strEnd = currentBookingData["EndTime"] as? String
            let endTime = timeFormatter.date(from: strEnd!)
            
            let calendar = Calendar.current
            
            let timeDifference = calendar.dateComponents([.hour], from: startTime!, to: endTime!)
            print(timeDifference.hour ?? "")
            
            //            pickerDataHours.removeAllObjects()
            //            let value = Int(timeDifference.hour!) - Int(lblHourC1A.text!)!
            
        }
        else
        {
            self.myPicker.tag = 10
        }
        
        alertController.view.addSubview(self.myPicker)
        present(alertController, animated: true, completion: nil)
        
        
        
        
        /*  [alertController addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
         // Called when user taps outside
         
         
         if (sortIndex<arrDoctor.count)
         {
         Doctor *objDoctor=arrDoctor[sortIndex];
         txtMedicalDoctor.text= [NSString stringWithFormat:@"%@ %@", objDoctor.firstName, objDoctor.lastName];
         txtTelephone.text=objDoctor.phone;
         }
         
         
         
         }]];
         
         /* UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
         action:@selector(closeAlert)];
         [alertController.view.superview addGestureRecognizer:tapGestureRecognizer];*/
         
         
         
         UIPopoverPresentationController *popoverController = alertController.popoverPresentationController;
         popoverController.sourceView = sender;
         popoverController.sourceRect = [sender bounds];
         
         
         [self presentViewController:alertController  animated:YES completion:nil];*/
    }
    
    
    
    
    
    
    
    
    @IBAction func SignOut(sender: AnyObject)
    {
        //self.navigationController?.popToRootViewController(animated: true)
        Delegate.moveToLogin()
    }
    
    @IBAction func hidePopups(sender: AnyObject)
    {
        viewPopC1A.isHidden = true
    }
    
    @IBAction func makeCall(sender: AnyObject)
    {
        let btnCall = sender as! UIButton
        
        if let url = URL(string: "tel://\(String(describing: btnCall.titleLabel?.text))"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func alreadyLeftAction(sender: AnyObject?)
    {
        lblTimerD1.font = UIFont.systemFont(ofSize: 37)
        Delegate.mySeconds=0
        //        Delegate.setBookingTime(myValue: 0)
        
        Delegate.setBookingTime(strDate: Int(Date().timeIntervalSince1970))
        Delegate.setBookingFlag(strDate: "")
        
        myFlag=""
        
        viewPopC1A.isHidden = true
        viewPopD1.isHidden = true
        Delegate.removeReportSubmitText()
        if sender != nil
        {
            Delegate.API_SendNotfication(userID: currentParkingOwnerUID, message: "Congratulations! Someone has finished using your space on Driveway.")
        }
        
        self.seconds = 0
        let databaseRef = FIRDatabase.database().reference()
        for key in currentBookingPrimaryKeys
        {
            if key != ""
            {
                databaseRef.child("Booking").child(key).child("BookingStatus").setValue("Left")
            }
        }
        
        if timer != nil
        {
            timer?.invalidate()
        }
        
        
        
        if self.dictMainData != nil
        {
            let dictUserInfo = self.dictMainData.value(forKey: currentBookingData.value(forKey: "UID") as! String) as! NSMutableDictionary
            
            let today = NSDate()
            
            if (dictUserInfo.allKeys as NSArray).contains(self.getStringFromDate(strDate:today ))
            {
                if( ((dictUserInfo.value(forKey: self.getStringFromDate(strDate:today )) as! NSDictionary).allKeys as NSArray).contains("timeIntervals"))
                {
                    let arrTimeIntervals = (dictUserInfo.value(forKey: self.getStringFromDate(strDate:today )) as! NSDictionary).value(forKey: "timeIntervals") as! NSArray
                    
                    
                    
                    
                    
                    for tempDict in arrTimeIntervals
                    {
                        if ((tempDict as! NSDictionary).value(forKey: "StartTime") as! String == currentBookingData.value(forKey: "StartTime") as! String) && ((tempDict as! NSDictionary).value(forKey: "EndTime") as! String == currentBookingData.value(forKey: "EndTime") as! String)
                        {
                            (tempDict as! NSDictionary).setValue("available", forKey: "BookingStatus")
                            
                            MBProgressHUD.showAdded(to: self.view, animated: true)
                            let databaseRef = FIRDatabase.database().reference()
                            
                            databaseRef.child("RentOutSpace").child(currentBookingData.value(forKey: "UID") as! String).child(getStringFromDate(strDate: today)).child("timeIntervals").setValue(arrTimeIntervals)
                            
                            
                            
                            //                            Delegate.API_SendNotfication(userID: currentBookingData.value(forKey: "UID") as! String, message: "Congratulations! The space you put up for rent has been rented on Driveway!")
                            
                            
                            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                            
                            
                            
                            
                            
                            break
                            
                        }
                    }
                    
                    
                    
                    
                    
                }
            }
            
        }
        
        
        getMapDataFromServer()
        
    }
    
    
    
    @IBAction func BuyMoreTime(sender: AnyObject)
    {
        
        if Int(lblHourD1.text!)! == 0
        {
            Utility.alert("There is no more time available in this space.", andTitle: appConstants.AppName, andController: self)
            return
        }
        //// get time difference
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        
        
        let strStart = timeFormatter.string(from: Date())
        let startTime = timeFormatter.date(from: strStart)
        
        let strEnd = currentBookingData["EndTime"] as? String
        let endTime = timeFormatter.date(from: strEnd!)
        
        let calendar = Calendar.current
        
        let timeDifference = calendar.dateComponents([.hour], from: startTime!, to: endTime!)
        print(timeDifference.hour ?? "")
        
        var value = 0
        if Int(timeDifference.hour!) > pickerDataHours.count
        {
            value = pickerDataHours.count - Int(lblHourD1.text!)!
        }else
        {
            value = Int(timeDifference.hour!) - Int(lblHourD1.text!)!
        }
        
        var currentBookingHour = 0
        
        if (currentBookingData.allKeys as NSArray).contains("bookingHours")
        {
            currentBookingHour = Int( currentBookingData.value(forKey: "bookingHours") as! String)!
        }
        
        if((Int(timeDifference.hour!)-currentBookingHour) >= Int(lblHourD1.text!)!)
        {
            
            
            amount = Int((lblPriceC1A.text?.replacingOccurrences(of: "$", with: ""))!)! *  Int(lblHourD1.text!)!
            
            if checkApplePayAvaliable() {
                checkPaymentNetworksAvaliable(usingNetworks: SupportedPaymentNetworks)
                let request = PKPaymentRequest()
                request.merchantIdentifier = ApplePaySwagMerchantID
                request.supportedNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]
                request.merchantCapabilities = PKMerchantCapability.capability3DS
                request.countryCode = "US";
                request.currencyCode = "USD";
                request.paymentSummaryItems = [PKPaymentSummaryItem(label: "", amount: NSDecimalNumber.init(string: String(amount)))]
                
                let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
                applePayController.delegate = self
                // self.present(applePayController, animated: true, completion: nil)
                
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
            
            
            
            
            
            print(currentBookingData)
            Delegate.API_SendNotfication(userID: currentParkingOwnerUID, message: "Someone has gone overtime using your space in Driveway. Contact the driver and check that this is the case before taking further action.")
        }
        else
        {
            Utility.alert("No additional time available in this space", andTitle: "", andController: self)
        }
        
        
        
        
    }
    
    
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping ((PKPaymentAuthorizationStatus) -> Void)) {
        completion(PKPaymentAuthorizationStatus.success)
    
        gotoMine()
        
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
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
            //            let alertController = UIAlertController(
            //                title: "The settlement method is not registered",
            //                message: "Would you like to register payment method now",
            //                preferredStyle: .alert
            //            )
            //            alertController.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { action in
            //                if #available(iOS 8.3, *) {
            //                    PKPassLibrary().openPaymentSetup()
            //                }
            //            }))
            //            alertController.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel, handler: nil))
            //            self.present(alertController, animated: true, completion: nil)
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
            request.paymentSummaryItems = [PKPaymentSummaryItem(label: "", amount: NSDecimalNumber.init(string: String(amount)))]
            
            let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
            applePayController.delegate = self
            // self.present(applePayController, animated: true, completion: nil)
            
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
        
        
        
        
        
    }
    
    func getOwnerInfo(_ uid: String)
    {
        let ref = FIRDatabase.database().reference()
        //        MBProgressHUD.showAdded(to: self.view, animated: true)
        ref.child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            //            let userType = value?["UserType"] as? String ?? ""
            //            //let user = User.init(username: username)
            //            print(value)
            
            // Utility.alert("Successfully Login as", andTitle: appConstants.AppName, andController: self)
            
            
            self.lblContactNameD1.text = value?["Name"] as? String ?? ""
            self.btnContactNumberD1.setTitle(value?["Phone"] as? String ?? "", for: .normal)
            
            
            //            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
            
            //            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool
    {
        
        
        print(marker.userData ?? " ")
        
        
        if marker.userData == nil
        {
            return false
        }
        
        let tempDict = marker.userData as? NSDictionary
        
        /*selectedKey = (marker.userData as? NSDictionary)?.value(forKey: "Key") as! String
         
         if tempDict == nil
         {
         return false
         }*/
        
        viewPopC1A.isHidden = false
        
        let location = CLLocation(latitude: Double(tempDict?["lat"]as! Double), longitude: Double(tempDict?["long"]as! Double)) //changed!!!
        
        // let location = CLLocatio/Volumes/Data/Knollinfo Data/KnollInfo data/Parking Application/Application/Parking/Parking/View Controller Classes/TermsConditionViewController.swift:24:15: Expression implicitly coerced from 'String?' to Anyn(latitude: Double(26.9124), longitude: Double(75.7873)) //changed!!!
        print(location)
        
        
        
        //// get time difference
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        let strStart = timeFormatter.string(from: Date())
        let startTime = timeFormatter.date(from: strStart)
        
        let strEnd = tempDict?["EndTime"] as? String
        let endTime = timeFormatter.date(from: strEnd!)
        
        let calendar = Calendar.current
        
        let timeDifference = calendar.dateComponents([.hour], from: startTime!, to: endTime!)
        print(timeDifference.hour ?? "")
        
        pickerDataHours.removeAllObjects()
        if Int(timeDifference.hour!) > 0
        {
            for i in 1...Int(timeDifference.hour!)
            {
                pickerDataHours.add(String(i))
                
                
            }
        }
        
        if(pickerDataHours.count > 0)
        {
            lblHourC1A.text = pickerDataHours.lastObject as? String
            lblHourD1.text = pickerDataHours.lastObject as? String
        }
        else
        {
            lblHourC1A.text = "0"
            lblHourD1.text = "0"
        }
        
        
        ///////////////
        
        
        currentBookingData = NSMutableDictionary.init(dictionary: tempDict!) // initialize booking data
        
        
        currentParkingOwnerUID = (tempDict?["UID"] as? String)!
        
        lblNoteC1A.text = tempDict?["note"] as? String
        lblPriceC1A.text = String.init(format: "$%@", (tempDict?["PricePerSpace"] as? String)!)
        lblPriceD1.text = String.init(format: "$%@", (tempDict?["PricePerSpace"] as? String)!)
        amount = Int((lblPriceC1A.text?.replacingOccurrences(of: "$", with: ""))!)! * Int(lblHourC1A.text!)!
        
        
        
        
        
        btnApplePay.setTitle(NSString.init(format: "Pay $%d now with Apple Pay", amount) as String, for: .normal)
        
        
        
        
        
        
        self.lblAddressC1A.text = ""
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            print(location)
            
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = placemarks?[0]
                print(pm?.description ?? "")
                if let addrList = pm?.addressDictionary?["FormattedAddressLines"] as? [String]
                {
                    self.lblAddressC1A.text =  addrList.joined(separator: ", ")
                    
                    /*var strAddress:String
                     
                     for str in originAddress as String
                     {
                     strAddress.append(str)
                     strAddress.append(", " )
                     }*/
                    //print(originAddress)
                }
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
        
        
        
        
        
        let ref = FIRDatabase.database().reference()
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ref.child("Users").child((tempDict?["UID"] as? String)!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let userType = value?["UserType"] as? String ?? ""
            //let user = User.init(username: username)
            print(value)
            
            // Utility.alert("Successfully Login as", andTitle: appConstants.AppName, andController: self)
            
            
            self.lblContactNameD1.text = value?["Name"] as? String ?? ""
            self.btnContactNumberD1.setTitle(value?["Phone"] as? String ?? "", for: .normal)
            
            
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
            
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        }
        
        
        
        return false
    }
    
    
    //MARK: - Run Timer
    func runTimer() {
        if timer != nil
        {
            timer?.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    
    
    
    func updateTimer() {
        
        
        self.seconds=BookingHours-(Int(Date().timeIntervalSince1970)-Delegate.getBookingTime())
        
        
        if seconds < 1 {
            
            //Delegate.API_SendNotfication(userID: currentParkingOwnerUID, message: "Congratulations! Someone has finished using your space on Driveway.")
            endRentPlace()
            
        } else {
            seconds -= 1     //This will decrement(count down)the seconds.
            Delegate.mySeconds+=1
            lblTimerD1.text =  timeString(time: TimeInterval(seconds))
        }
        
        
        
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"Timer  %02i:%02i:%02i", hours, minutes, seconds)
    }
    
    
    
    func endRentPlace()
    {
        if timer != nil
        {
            timer?.invalidate()
            timer = nil
        }
        //Send alert to indicate "time's up!"
        
        lblTimerD1.text = "Your time has run out and you are about to be towed. Please buy more time or leave your parking space quickly."
        lblTimerD1.font = UIFont.systemFont(ofSize: 13)
        
        Delegate.setBookingFlag(strDate: "")
        
        if Delegate.getReportSubmitText() != ""
        {
            Delegate.API_SendNotfication(userID: currentParkingOwnerUID, message: Delegate.getReportSubmitText())
            Delegate.removeReportSubmitText()
        }
        if Int(lblHourD1.text!) == 0
        {
            alreadyLeftAction(sender: nil)
        }

    }
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickerDataHours.count
        
    }
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        return pickerDataHours[row] as? String
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //selectedDropDown=row
        
        if pickerView.tag == 20
        {
            lblHourD1.text = pickerDataHours[row] as? String
            self.lblHourC1A.text = pickerDataHours[row] as? String
        }
        else
        {
            
            lblHourC1A.text = pickerDataHours[row] as? String
            lblHourD1.text =  "\(pickerDataHours.count - row - 1)"
            
            amount = Int((lblPriceC1A.text?.replacingOccurrences(of: "$", with: ""))!)! * Int(pickerDataHours[row] as! String)!
            
            btnApplePay.setTitle(NSString.init(format: "Pay $%d now with Apple Pay", amount) as String, for: .normal)
        }
    }
    
    
    
    
    
    func gotoMine()
    {
        
        
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        let databaseRef = FIRDatabase.database().reference()
        
        
        
        
        
        var pp:Int!
        pp=pickerDataHours.count
        pickerDataHours.removeAllObjects()
        
        
        self.myFlag=Delegate.getBookingFlag() as NSString
        
        
        
        if self.myFlag==""
        {
            
            
            Delegate.setBookingTime(strDate: Int(Date().timeIntervalSince1970))
            self.myFlag="no"
            Delegate.setBookingFlag(strDate: "no")
            
            Delegate.setHour(pHour: lblHourD1.text!)
            Delegate.setPrice(pValue: lblPriceD1.text!)
            
        } else {
            
            
            
            self.seconds=self.seconds+(Int(lblHourD1.text!)!*3600)
            pp=pp-Int(lblHourD1.text!)!
            
            print(pickerDataHours.count)
            
            
            lblHourD1.text=String(pp)
            
            
        }
        
        
        if Int(lblHourD1.text!)! > 0
        {
            for i in 1...Int(lblHourD1.text!)!
            {
                pickerDataHours.add(String(i))
                
                
            }
        }
        
        
        
        
        
        //        let userID = FIRAuth.auth()?.currentUser?.uid
        currentBookingData.setValue(lblHourC1A.text, forKey: "bookingHours")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy HH:mm"
        
        
        
        currentBookingData.setValue(dateFormatter.string(from: NSDate() as Date), forKey: "bookingDate")
        currentBookingData.setValue(userID, forKey: "Book_UID")
        
        
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let  locationRef = databaseRef.child("Booking").childByAutoId()
        locationRef.setValue(currentBookingData)
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        
        
        let bookDate = NSDate() as Date
        
        
        //        let BookingHours =  Int(lblHourC1A.text!)!*60*60
        
        let BookingHours =  Int(lblHourD1.text!)!*60*60
        
        if  Date() < bookDate.addingTimeInterval(TimeInterval(BookingHours))
        {
            
            //            self.seconds = Int(bookDate.addingTimeInterval(TimeInterval(BookingHours)).timeIntervalSince(Date()))
        }
        
        
        
        if self.dictMainData != nil
        {
            let dictUserInfo = self.dictMainData.value(forKey: currentBookingData.value(forKey: "UID") as! String) as! NSMutableDictionary
            
            let today = NSDate()
            
            if (dictUserInfo.allKeys as NSArray).contains(self.getStringFromDate(strDate:today ))
            {
                if( ((dictUserInfo.value(forKey: self.getStringFromDate(strDate:today )) as! NSDictionary).allKeys as NSArray).contains("timeIntervals"))
                {
                    let arrTimeIntervals = (dictUserInfo.value(forKey: self.getStringFromDate(strDate:today )) as! NSDictionary).value(forKey: "timeIntervals") as! NSArray
                    
                    
                    
                    
                    
                    for tempDict in arrTimeIntervals
                    {
                        if ((tempDict as! NSDictionary).value(forKey: "StartTime") as! String == currentBookingData.value(forKey: "StartTime") as! String) && ((tempDict as! NSDictionary).value(forKey: "EndTime") as! String == currentBookingData.value(forKey: "EndTime") as! String)
                        {
                            (tempDict as! NSDictionary).setValue("Booked", forKey: "BookingStatus")
                            
                            (tempDict as! NSDictionary).setValue(Int(Date().timeIntervalSince1970), forKey: "BookingStartTime")
                            
                            (tempDict as! NSDictionary).setValue(Delegate.getUID(), forKey: "BookingUserId")
                            MBProgressHUD.showAdded(to: self.view, animated: true)
                            let databaseRef = FIRDatabase.database().reference()
                            
                            databaseRef.child("RentOutSpace").child(currentBookingData.value(forKey: "UID") as! String).child(getStringFromDate(strDate: today)).child("timeIntervals").setValue(arrTimeIntervals)
                            
                            
                            
                            Delegate.API_SendNotfication(userID: currentBookingData.value(forKey: "UID") as! String, message: "Congratulations! The space you put up for rent has been rented on Driveway!")
                            
                            
                            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                            
                            
                            
                            
                            
                            break
                            
                        }
                    }
                    
                    
                    
                    
                    
                }
            }
            
        }
        
        
        
        
        
        if self.dictMainData != nil
        {
            
            print( self.dictMainData)
            
            let allUserKey = self.dictMainData.allKeys as NSArray
            
            for i:Int in 0..<allUserKey.count
            {
                
                
                let dictUserInfo = self.dictMainData.value(forKey: allUserKey.object(at: i) as! String) as! NSMutableDictionary
                
                
                let today = NSDate()
                
                if (dictUserInfo.allKeys as NSArray).contains(self.getStringFromDate(strDate:today ))
                {
                    if( ((dictUserInfo.value(forKey: self.getStringFromDate(strDate:today )) as! NSDictionary).allKeys as NSArray).contains("timeIntervals"))
                    {
                        let arrTimeIntervals = (dictUserInfo.value(forKey: self.getStringFromDate(strDate:today )) as! NSDictionary).value(forKey: "timeIntervals") as! NSArray
                        
                        
                        // self.arrData.add(arrTempData.object(at: i) as! NSDictionary)
                        
                        print(Double((dictUserInfo.value(forKey: self.getStringFromDate(strDate:today )) as! NSDictionary).value(forKey: "lat")as! Double))
                        
                        let marker = GMSMarker()
                        marker.position = CLLocationCoordinate2D(latitude: Double((dictUserInfo.value(forKey: self.getStringFromDate(strDate:today )) as! NSDictionary).value(forKey: "lat")as! Double), longitude: Double((dictUserInfo.value(forKey: self.getStringFromDate(strDate:today )) as! NSDictionary).value(forKey: "long")as! Double))
                        
                        
                        marker.title = ""
                        marker.snippet = ""
                        marker.map = self.mapView
                        
                        let dictPinData = arrTimeIntervals.object(at: 0) as! NSMutableDictionary
                        dictPinData.setObject(allUserKey.object(at: i) as! String, forKey: "UID" as NSCopying)
                        dictPinData.setObject(marker.position.latitude, forKey: "lat" as NSCopying)
                        dictPinData.setObject(marker.position.longitude, forKey: "long" as NSCopying)
                        dictPinData.setObject((dictUserInfo.value(forKey: self.getStringFromDate(strDate:today )) as! NSDictionary).value(forKey: "NumberOfSpace")as! String, forKey: "NumberOfSpace" as NSCopying)
                        dictPinData.setObject((dictUserInfo.value(forKey: self.getStringFromDate(strDate:today )) as! NSDictionary).value(forKey: "PricePerSpace")as! String, forKey: "PricePerSpace" as NSCopying)
                        
                        marker.userData = dictPinData
                    }
                }
                
                
                
                
                
                
            }
        }
        
        
        self.mapView.clear()
        
        // getMapDataFromServer()
        locationManager.startUpdatingLocation()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation() // start location manager
            
        }
        
        
        
        
        getBookingListFromServer()
        
        
    }
    
}



