//
//  AddDetailsViewController.swift
//  Parking
//
//  Created by Manveer Dodiya on 06/07/17.
//  Copyright © 2017 Manveer Dodiya. All rights reserved.
//

import UIKit
import JTCalendar
import Firebase
import SpaceView


class AddDetailsViewController: UIViewController, JTCalendarDelegate,UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate {
    
    let Delegate = UIApplication.shared.delegate as! AppDelegate
    
    var strLat:String!
    var strLong:String!
    
    var strFromSignupLogin:String = ""
    
    //var arrTimeIntervalList:NSMutableArray!
    
    var calendarManager:JTCalendarManager!
    
    @IBOutlet var calendarMenuView:JTCalendarMenuView!
    @IBOutlet var calendarContentView:JTHorizontalCalendarView!
    
    @IBOutlet var tblList:UITableView!
    @IBOutlet var btnSave:UIButton!
    
    @IBOutlet var lblPrice:UILabel!
    //    @IBOutlet var lblNumberOfSpace:UILabel!
    
    @IBOutlet var myPicker: UIPickerView!
    
    //    let pickerDataNumberOfSpace = ["1", "2", "3", "4"]
    let pickerDataHPrice = ["1", "2", "3", "4","5", "6", "7", "8","9", "10", "11", "12","13", "14", "15", "16","17", "18", "19", "20"]
    
    var selectedNumberOfSpace:String! = "1"
    var selectedPrice:String! = "3"
    
    var dateSelected = NSDate()
    
    var startDatePickerView:UIDatePicker!
    var endDatePickerView:UIDatePicker!
    
    
    var startTime = "00:00"
    var endTime = "00:00"
    
    
    var dictMainData:NSMutableDictionary = [:]
    var serverMainData:NSMutableDictionary = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        
        
        calendarManager = JTCalendarManager()
        calendarManager.delegate = self
        calendarManager.menuView = calendarMenuView
        calendarManager.contentView = calendarContentView
        
        let mydate = Date()
        calendarManager.setDate(mydate)
        
        
        //        createDataOnDate(strDate: dateSelected)
        // print(strLat+" "+strLong)
        
        
        
        //        lblNumberOfSpace.text = String.init(format: "Number of spaces to rent %@", selectedNumberOfSpace);
        lblPrice.text = String.init(format: "Price per hour per space $%@", selectedPrice);
        
       
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        getDataFromServer()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Custom Methods
    func setupUI()
    {
        /* self.view.backgroundColor = Utility.color(withHexString: appConstants.viewBackgroundColor)
         // self.navigationItem.hidesBackButton = true
         self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)*/
        
        self.view.backgroundColor = Utility.color(withHexString: appConstants.viewBackgroundColor)
        
        if strFromSignupLogin == "Yes"
        {
            self.navigationItem.hidesBackButton = true
        }
        else
        {
            self.navigationItem.hidesBackButton = false
        }
        
        self.navigationController?.navigationBar.barTintColor = Utility.color(withHexString: appConstants.navColor)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.view.backgroundColor = Utility.color(withHexString: appConstants.viewBackgroundColor)
        
        btnSave.layer.cornerRadius = 5
    }
    
    
    
    func createEmptyRow() -> NSMutableArray
    {
        
        let  arrTimeIntervalList = NSMutableArray()
        
        let dictTemp = NSMutableDictionary()
        dictTemp.setValue(startTime, forKey: "StartTime")
        dictTemp.setValue(endTime, forKey: "EndTime")
        dictTemp.setValue("", forKey: "note")
        dictTemp.setValue("", forKey: "BookingStatus")
        
        arrTimeIntervalList.add(dictTemp)
        
        return arrTimeIntervalList;
        //tblList.reloadData()
    }
    
    
    
    
    func createDataOnDate(strDate: NSDate)
    {
        
        
        print(getStringFromDate(strDate: strDate));
        if !((dictMainData.allKeys as NSArray).contains(getStringFromDate(strDate: strDate)))
        {
            let dictTemp = NSMutableDictionary()
            dictTemp.setValue(selectedNumberOfSpace, forKey: "NumberOfSpace")
            dictTemp.setValue(selectedPrice, forKey: "PricePerSpace")
            dictTemp.setValue(createEmptyRow(), forKey: "timeIntervals")
            
            dictMainData.setValue(dictTemp, forKey: getStringFromDate(strDate: strDate))
        }
        else
        {
            let dictTemp = dictMainData.value(forKey: getStringFromDate(strDate: strDate)) as! NSMutableDictionary
            
            if (dictTemp.allKeys as NSArray).contains("timeIntervals")
            {
                let arrTimeIntervals =  dictTemp.value(forKey: "timeIntervals") as! NSMutableArray
                
                if (arrTimeIntervals.object(at: 0) as! NSDictionary).value(forKey: "StartTime") as! String == "00:00" && (arrTimeIntervals.object(at: 0) as! NSDictionary).value(forKey: "EndTime") as! String == "00:00" {
                    dictMainData.removeObject(forKey: getStringFromDate(strDate: strDate))
                }
            }
            
            if !((serverMainData.allKeys as NSArray).contains(getStringFromDate(strDate: strDate)))
            {
                dictMainData.removeObject(forKey: getStringFromDate(strDate: strDate))
            }
        }
        
        
        
        print(dictMainData)
        
        calendarManager.reload()
        
        updateLableValue()
        tblList.reloadData()
    }
    
    
    
    
    
    func updateLableValue()
    {
        
        if (dictMainData.allKeys as NSArray).contains(getStringFromDate(strDate: dateSelected))
        {
            
            let dictTemp =   dictMainData.value(forKey: getStringFromDate(strDate: dateSelected)) as! NSMutableDictionary
            
            
            
            //            lblNumberOfSpace.text = String.init(format: "Number of spaces to rent %@", dictTemp.value(forKey: "NumberOfSpace") as! String);
            lblPrice.text = String.init(format: "Price per hour per space $%@", dictTemp.value(forKey: "PricePerSpace") as! String);
        }
        
        
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
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        if let time = dateFormatter.date(from: strDate)
        {
            return time
        }
        return nil
    }
    
    func getTime(strDate: String)-> Date?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        if let time = dateFormatter.date(from: strDate)
        {
            return time
        }
        return nil
    }
    
    
    
    
    func getDataFromServer()
    {
        
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let parentRef = FIRDatabase.database().reference().child("RentOutSpace").child((FIRAuth.auth()?.currentUser?.uid)!)
        parentRef.observe(.value, with: { snapshot in
            
            // NSLog("chil %@", snapshot.value! as! NSDictionary)
            
            print(snapshot.value ?? "")
            
            parentRef.removeAllObservers()
            
            
            if !(snapshot.value is NSNull)
            {
                self.dictMainData = (snapshot.value as! NSDictionary).mutableCopy() as! NSMutableDictionary
                self.serverMainData = (snapshot.value as! NSDictionary).mutableCopy() as! NSMutableDictionary
            } else {
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                return
            }
            if let _ = self.dictMainData.value(forKey: self.getStringFromDate(strDate: self.dateSelected)) as? NSMutableDictionary
            {
                if let arrInterval = (self.dictMainData.value(forKey: self.getStringFromDate(strDate: self.dateSelected)) as! NSMutableDictionary).value(forKey: "timeIntervals") as? NSMutableArray
                {
                    if arrInterval.count == 0
                    {
                        self.createDataOnDate(strDate: self.dateSelected);
                    }
                }
            }else{
                self.createDataOnDate(strDate: self.dateSelected);
            }
            /*for child in snapshot.children {
             
             print((child as! FIRDataSnapshot).key)
             
             // let dataDict = NSMutableDictionary()
             
             //dataDict.setValue((child as! FIRDataSnapshot).key, forKey: "Key")
             
             // dataDict.setValue((child as! FIRDataSnapshot).value ?? "", forKey: "Value")
             
             
             
             self.dictMainData = ((child as! FIRDataSnapshot).value as! NSDictionary).mutableCopy() as! NSMutableDictionary
             }*/
            
            
            
            NSLog("before filter %@", self.dictMainData)
            
            
            
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            
            self.calendarManager.reload()
            self.tblList.reloadData()
            
        })
    }
    
    
    
    
    
    // MARK: - MapView Delegates
    
    
    
    /* - (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
     self.calloutView.hidden = YES;
     }*/
    
    
    
    // MARK: - IBActions
    
    @IBAction func SignOut(sender: AnyObject)
    {
        //self.navigationController?.popToRootViewController(animated: true)
        Delegate.moveToLogin()
    }
    
    @IBAction func textFieldTextChange(sender: AnyObject)
    {
        let txtField:UITextField = sender as! UITextField
        
        
        let arrInterval = (dictMainData.value(forKey: (dictMainData.allKeys as NSArray).object(at: txtField.tag/100) as! String) as! NSMutableDictionary).value(forKey: "timeIntervals") as! NSMutableArray
        
        
        let dataDict = arrInterval.object(at: txtField.tag%100) as! NSMutableDictionary
        
        dataDict.setValue(txtField.text, forKey: "note")
        print(dataDict)
    }
    
    
    @IBAction func AddMore(sender: AnyObject)
    {
        
        if (dictMainData.allKeys as NSArray).contains(getStringFromDate(strDate: dateSelected))
        {
            
            if  ((self.dictMainData.value(forKey: getStringFromDate(strDate: dateSelected)) as! NSMutableDictionary).allKeys as NSArray).contains("timeIntervals")
            {
                
                let arrInterval = (dictMainData.value(forKey: getStringFromDate(strDate: dateSelected)) as! NSMutableDictionary).value(forKey: "timeIntervals") as! NSMutableArray
                
                
                let dictTemp = NSMutableDictionary()
                dictTemp.setValue("00:00", forKey: "StartTime")
                dictTemp.setValue("00:00", forKey: "EndTime")
                dictTemp.setValue("", forKey: "note")
                dictTemp.setValue("", forKey: "BookingStatus")
                
                arrInterval.add(dictTemp)
                tblList.reloadData()
            }
            else
            {
                let  arrTimeIntervalList = NSMutableArray()
                
                let dictTemp = NSMutableDictionary()
                dictTemp.setValue("00:00", forKey: "StartTime")
                dictTemp.setValue("00:00", forKey: "EndTime")
                dictTemp.setValue("", forKey: "note")
                dictTemp.setValue("", forKey: "BookingStatus")
                
                arrTimeIntervalList.add(dictTemp)
                (self.dictMainData.value(forKey: getStringFromDate(strDate: dateSelected)) as! NSMutableDictionary).setValue(arrTimeIntervalList, forKey: "timeIntervals")
                tblList.reloadData()
            }
        }
        else
        {
            createDataOnDate(strDate: dateSelected)
        }
    }
    
    
    @IBAction func SaveData(sender: AnyObject)
    {
        print("Save Data")
        
        
        
        
        
        let ref = FIRDatabase.database().reference()
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let lat = value?["lat"] as? Double
            let long = value?["long"] as? Double
            //let user = User.init(username: username)
            //            print(value)
            
            
            
            let dict = self.dictMainData.value(forKey: self.getStringFromDate(strDate: self.dateSelected)) as! NSMutableDictionary
            
            
            
            dict.setValue(lat, forKey: "lat")
            dict.setValue(long, forKey: "long")
            
            
            
            
            
            
            print(self.dictMainData)
            
            var avalCount = 0
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let arrKeys = self.dictMainData.allKeys as NSArray
            
            for strkey in arrKeys
            {
                var dataCountForValue = 0
                if  ((self.dictMainData.value(forKey: strkey as! String) as! NSMutableDictionary).allKeys as NSArray).contains("timeIntervals")
                {
                    let arrInterval = (self.dictMainData.value(forKey: strkey as! String) as! NSMutableDictionary).value(forKey: "timeIntervals") as! NSMutableArray
                    
                    
                    let duplicateArray = NSMutableArray.init(array: arrInterval)
                    
                    for dictTemp in duplicateArray
                    {
                        if (dictTemp as! NSMutableDictionary).value(forKey: "StartTime") as! String == "00:00" || (dictTemp as! NSMutableDictionary).value(forKey: "EndTime") as! String == "00:00"
                        {
                            arrInterval.remove(dictTemp)
                        }
                        else
                        {
                            dataCountForValue += 1
                            if (dictTemp as! NSMutableDictionary).value(forKey: "BookingStatus") as! String == ""
                            {
                                (dictTemp as! NSMutableDictionary).setObject("available", forKey: "BookingStatus" as NSCopying)
                                
                                avalCount += 1
                                
                            }
                        }
                        
                    }
                    if dataCountForValue == 0
                    {
                        self.dictMainData.removeObject(forKey: strkey)
                    }
                    
                    
                }
                
                
                
                
            }
            
            
            
            
            print(self.dictMainData)
            
            
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            
            
            
            /* let post : [String: AnyObject] = ["lat" : strLat as AnyObject, "long" : strLong as AnyObject, "avail_date" : dateFormatter.string(from: self.dateSelected as Date) as AnyObject , "timeIntervals" : arrTimeIntervalList , "userId" : FIRAuth.auth()?.currentUser?.uid as AnyObject, "availability": "available" as AnyObject]*/
            
            let databaseRef = FIRDatabase.database().reference()
            
            databaseRef.child("RentOutSpace").child((FIRAuth.auth()?.currentUser?.uid)!).setValue(self.dictMainData)
            
            databaseRef.child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).child("availCount").setValue(avalCount)
            
            //    locationRef.setValue(dictMainData)
            
            
            
            // databaseRef.child("Users").child(user.uid).setValue(post)
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            
            
            Utility.alert("Data Saved Successfully", andTitle: "", andController: self)
            self.dateSelected = NSDate()
            self.getDataFromServer()
            //self.navigationController?.popToViewController((self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)!-3])!, animated: true)
            
            
            
        }) { (error) in
            print(error.localizedDescription)
            
            
        }
        
        
        
        
    }
    
    
    
    @IBAction func SelectStartTime(sender: AnyObject)
    {
        print("start time")
        self.view.endEditing(true)
        
        let btn = sender as! UIButton
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        let defaultAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.cancel, handler: {(action:UIAlertAction) in
            
            
            /*if(self.selectedDropDown<self.pickerData.count)
             {
             print("selected value after done \(self.pickerData[self.selectedDropDown])")
             self.txtDropDown.text=self.pickerData[self.selectedDropDown]
             }*/
            
            
            
            
            
            
            
            btn.setTitle(dateFormatter.string(from: self.startDatePickerView.date), for: .normal)
            
            
            let arrInterval = (self.dictMainData.value(forKey: (self.dictMainData.allKeys as NSArray).object(at: btn.tag/100) as! String) as! NSMutableDictionary).value(forKey: "timeIntervals") as! NSMutableArray
            
            let dictTemp = arrInterval.object(at: btn.tag%100) as! NSMutableDictionary
            dictTemp.setValue(dateFormatter.string(from: self.startDatePickerView.date), forKey: "StartTime")
            if let _ = (dictTemp.object(forKey: "EndTime")) as? String
            {
                let strStartTime = (dictTemp.object(forKey: "StartTime")) as! String
                let strStart = "09-Aug-2017" + " " + strStartTime
                let strEndTime = (dictTemp.object(forKey: "EndTime")) as! String
                let strEnd = "09-Aug-2017" + " " + strEndTime
                if let startDate = self.getDateFromTime(strDate: strStart)
                {
                    if let endDate = self.getDateFromTime(strDate: strEnd)
                    {
                        for dic in arrInterval as! [NSDictionary]
                        {
                            let strTimeStart = dic.object(forKey: "StartTime") as! String
                            let tempStart = "09-Aug-2017" + " " + strTimeStart
                            let strTimeEnd = dic.object(forKey: "EndTime") as! String
                            let tempEnd = "09-Aug-2017" + " " + strTimeEnd
                            if let tempDateTimeStart = self.getDateFromTime(strDate: tempStart)
                            {
                                if let tempDateTimeEnd = self.getDateFromTime(strDate: tempEnd)
                                {
                                    if self.checkOverlapTime(startDate, endTime: endDate, startTime2: tempDateTimeStart, endTime2: tempDateTimeEnd)
                                    {
                                        dictTemp.setValue("00:00", forKey: "StartTime")
                                        btn.setTitle("00:00", for: .normal)
                                        self.showSpace(title: "Toast", description: "Rent out time overlapped.", spaceOptions: [.spacePosition(position: .bot)])
                                        //                                        self.tblList.reloadData()
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
            }
            //            self.endDatePickerView.minimumDate = self.startDatePickerView.date
            //                        self.startTime = dateFormatter.string(from: self.startDatePickerView.date)
            
            
        })
        alertController.addAction(defaultAction)
        
        
        
        
        
        startDatePickerView = UIDatePicker()
        startDatePickerView.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        
        
        startDatePickerView.datePickerMode = UIDatePickerMode.time
                let arrInterval = (self.dictMainData.value(forKey: (self.dictMainData.allKeys as NSArray).object(at: btn.tag/100) as! String) as! NSMutableDictionary).value(forKey: "timeIntervals") as! NSMutableArray
                let date = (self.dictMainData.allKeys as NSArray).object(at: btn.tag/100) as! String
                let dictTemp = arrInterval.object(at: btn.tag%100) as! NSMutableDictionary
                if let strStartTime = (dictTemp.object(forKey: "EndTime")) as? String
                {
                    let str = date + " " + strStartTime
                    if let minimum = getDateFromTime(strDate: str)
                    {
                        startDatePickerView.maximumDate = minimum
                    }
                }else{
                    startDatePickerView.maximumDate = getDateFromTime(strDate: date + " " + "11:59 PM")
        }
        startDatePickerView.minimumDate = getDateFromTime(strDate: date + " " + "12:00 AM")
        
        //sender.inputView = datePickerView
        // datePickerView.addTarget(self, action: #selector(ViewController.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
        
        alertController.view.addSubview(startDatePickerView)
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
    
    @IBAction func SelectEndTime(sender: AnyObject)
    {
        print("end time")
        self.view.endEditing(true)
        let btn = sender as! UIButton
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        let defaultAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.cancel, handler: {(action:UIAlertAction) in
            
            
            /*if(self.selectedDropDown<self.pickerData.count)
             {
             print("selected value after done \(self.pickerData[self.selectedDropDown])")
             self.txtDropDown.text=self.pickerData[self.selectedDropDown]
             }*/
            
            
            
            
            
            
            
            
            
            
            btn.setTitle(dateFormatter.string(from: self.endDatePickerView.date), for: .normal)
            
            
            let arrInterval = (self.dictMainData.value(forKey: (self.dictMainData.allKeys as NSArray).object(at: btn.tag/100) as! String) as! NSMutableDictionary).value(forKey: "timeIntervals") as! NSMutableArray
            
            let dictTemp = arrInterval.object(at: btn.tag%100) as! NSMutableDictionary
            dictTemp.setValue(dateFormatter.string(from: self.endDatePickerView.date), forKey: "EndTime")
            if let strStartTime = (dictTemp.object(forKey: "StartTime")) as? String
            {
                let strStart = "09-Aug-2017" + " " + strStartTime
                let strEndTime = (dictTemp.object(forKey: "EndTime")) as! String
                let strEnd = "09-Aug-2017" + " " + strEndTime
                if let startDate = self.getDateFromTime(strDate: strStart)
                {
                    if let endDate = self.getDateFromTime(strDate: strEnd)
                    {
                        for dic in arrInterval as! [NSDictionary]
                        {
                            let strTimeStart = dic.object(forKey: "StartTime") as! String
                            let tempStart = "09-Aug-2017" + " " + strTimeStart
                            let strTimeEnd = dic.object(forKey: "EndTime") as! String
                            let tempEnd = "09-Aug-2017" + " " + strTimeEnd
                            if let tempDateTimeStart = self.getDateFromTime(strDate: tempStart)
                            {
                                if let tempDateTimeEnd = self.getDateFromTime(strDate: tempEnd)
                                {
                                    if self.checkOverlapTime(startDate, endTime: endDate, startTime2: tempDateTimeStart, endTime2: tempDateTimeEnd)
                                    {
                                        dictTemp.setValue("00:00", forKey: "EndTime")
                                        //                                        self.tblList.reloadData()
                                        btn.setTitle("00:00", for: .normal)
                                        self.showSpace(title: "Toast", description: "Rent out time overlapped.", spaceOptions: [.spacePosition(position: .bot)
                                            ])
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            //                        self.endTime = dateFormatter.string(from: self.endDatePickerView.date)
            
            
        })
        alertController.addAction(defaultAction)
        
        
        
        
        
        endDatePickerView = UIDatePicker()
        endDatePickerView.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        
        endDatePickerView.datePickerMode = UIDatePickerMode.time
                let arrInterval = (self.dictMainData.value(forKey: (self.dictMainData.allKeys as NSArray).object(at: btn.tag/100) as! String) as! NSMutableDictionary).value(forKey: "timeIntervals") as! NSMutableArray
                let date = (self.dictMainData.allKeys as NSArray).object(at: btn.tag/100) as! String
                let dictTemp = arrInterval.object(at: btn.tag%100) as! NSMutableDictionary
                if let strStartTime = (dictTemp.object(forKey: "StartTime")) as? String
                {
                     let str = date + " " + strStartTime
                    if let minimum = getDateFromTime(strDate: str)
                    {
        
                        endDatePickerView.minimumDate = minimum
                    }
                }else{
                    endDatePickerView.minimumDate = getDateFromTime(strDate: date + " " + "12:00 AM")
        }
        
                endDatePickerView.maximumDate = getDateFromTime(strDate: date + " " + "11:59 PM")
        
        //sender.inputView = datePickerView
        
        // datePickerView.addTarget(self, action: #selector(ViewController.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
        
        alertController.view.addSubview(endDatePickerView)
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    //    @IBAction func SelectHours(sender: AnyObject)
    //    {
    //
    //        self.view.endEditing(true)
    //
    //
    //
    //        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
    //        let defaultAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.cancel, handler: {(action:UIAlertAction) in
    //
    //
    //            /*if(self.selectedDropDown<self.pickerData.count)
    //             {
    //             print("selected value after done \(self.pickerData[self.selectedDropDown])")
    //             self.txtDropDown.text=self.pickerData[self.selectedDropDown]
    //             }*/
    //
    //        })
    //        alertController.addAction(defaultAction)
    //
    //
    //
    //
    //
    //        myPicker=UIPickerView()
    //        myPicker.frame=CGRect(x:0, y:0, width:alertController.view.frame.size.width-20, height:250)
    //
    //        self.myPicker.delegate=self
    //        self.myPicker.tag = 10
    //
    //        alertController.view.addSubview(self.myPicker)
    //        present(alertController, animated: true, completion: nil)
    //
    //
    //
    //
    //        /*  [alertController addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    //         // Called when user taps outside
    //
    //
    //         if (sortIndex<arrDoctor.count)
    //         {
    //         Doctor *objDoctor=arrDoctor[sortIndex];
    //         txtMedicalDoctor.text= [NSString stringWithFormat:@"%@ %@", objDoctor.firstName, objDoctor.lastName];
    //         txtTelephone.text=objDoctor.phone;
    //         }
    //
    //
    //
    //         }]];
    //
    //         /* UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
    //         action:@selector(closeAlert)];
    //         [alertController.view.superview addGestureRecognizer:tapGestureRecognizer];*/
    //
    //
    //
    //         UIPopoverPresentationController *popoverController = alertController.popoverPresentationController;
    //         popoverController.sourceView = sender;
    //         popoverController.sourceRect = [sender bounds];
    //
    //
    //         [self presentViewController:alertController  animated:YES completion:nil];*/
    //    }
    
    
    
    
    
    
    @IBAction func SelectPrice(sender: AnyObject)
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
        self.myPicker.tag = 20
        
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
    
    //
    //        func checkEmptyData()
    //        {
    //            for key  in dictMainData.allKeys
    //            {
    //                if let dict = dictMainData.object(forKey: key as! String) as? NSMutableDictionary
    //                {
    //                    if let array = dict.object(forKey: "timeIntervals") as? NSMutableArray
    //                    {
    //                        for item  in array as! [ns]
    //                        {
    //                            if item.object(forKey: "StartTime") as! String == startTime && item.object(forKey: "EndTime") as! String == endTime
    //                            {
    //                                dict.removeObject(forKey: key)
    //                                continue
    //                            }
    //                        }
    //                    }
    //                }
    //            }
    //
    //        }
    
    
    func checkOverlapTime(_ startTime:Date, endTime:Date, startTime2:Date, endTime2:Date) -> Bool
    {
        var overlap = false
        let t1 = startTime.timeIntervalSince1970
        let t2 = endTime.timeIntervalSince1970
        let t3 = startTime2.timeIntervalSince1970
        let t4 = endTime2.timeIntervalSince1970
        if ( (t3 > t1 && t3 < t2) || (t3 < t1 && t4 > t1) )
        {
            overlap = true
        }
        return overlap
    }
    
    
    
    
    // MARK: - calendar delegates
    public func calendar(_ calendar: JTCalendarManager!, prepareDayView dayView: UIView!)
        
    {
        
        // Today
        let mydayview=dayView as! JTCalendarDayView
        if(calendarManager.dateHelper.date(NSDate() as Date!, isTheSameDayThan: mydayview.date))
        {
            mydayview.circleView.isHidden = false;
            mydayview.dotView.backgroundColor = UIColor.blue
            mydayview.textLabel.textColor = UIColor.white
        }
            // Selected date
            /*else if(String(describing: dateSelected) != "" && calendarManager.dateHelper.date(dateSelected as Date!, isTheSameDayThan: mydayview.date))
             {
             mydayview.circleView.isHidden = false;
             mydayview.circleView.backgroundColor = UIColor.yellow
             mydayview.dotView.backgroundColor = UIColor.white
             mydayview.textLabel.textColor = UIColor.red
             }*/
        else if  ((serverMainData.allKeys as NSArray).contains(getStringFromDate(strDate: mydayview.date! as NSDate))) && (getStringFromDate(strDate: dateSelected) != getStringFromDate(strDate: mydayview.date as NSDate))
        {
            if  ((dictMainData.value(forKey: getStringFromDate(strDate: mydayview.date! as NSDate)) as! NSMutableDictionary).allKeys as NSArray).contains("timeIntervals")
            {
                mydayview.circleView.isHidden = false;
                mydayview.circleView.backgroundColor = UIColor.lightGray
                mydayview.dotView.backgroundColor = UIColor.white
                mydayview.textLabel.textColor = UIColor.white
            }
        } else if ((dictMainData.allKeys as NSArray).contains(getStringFromDate(strDate: mydayview.date! as NSDate)))
        {
            if  ((dictMainData.value(forKey: getStringFromDate(strDate: mydayview.date! as NSDate)) as! NSMutableDictionary).allKeys as NSArray).contains("timeIntervals")
            {
                mydayview.circleView.isHidden = false;
                mydayview.circleView.backgroundColor = UIColor.red
                mydayview.dotView.backgroundColor = UIColor.white
                mydayview.textLabel.textColor = UIColor.white
            }
        }
            // Other month
        else if(calendarManager.dateHelper.date(calendarContentView.date, isTheSameMonthThan: mydayview.date))
        {
            mydayview.circleView.isHidden = true;
            mydayview.dotView.backgroundColor = UIColor.red
            mydayview.textLabel.textColor = UIColor.black
            
        }
            // Another day of the current month
        else
        {
            mydayview.circleView.isHidden = true;
            mydayview.dotView.backgroundColor = UIColor.red
            mydayview.textLabel.textColor = UIColor.lightGray
        }
        
    }
    
    
    public func calendar(_ calendar: JTCalendarManager!, didTouchDayView dayView: UIView!)
    {
        
        let mydayview=dayView as! JTCalendarDayView
        
        
        let today = Date()
        print(mydayview.date)
        print(calendarManager.date())
        //        checkEmptyData()
        if (mydayview.date as Date)  < today.addingTimeInterval(-24*60*60)
            
        {
            return
        }
        
        
        dateSelected=mydayview.date as NSDate
        
        
        createDataOnDate(strDate: dateSelected)
        
        
        
        if let _ = dictMainData.value(forKey: getStringFromDate(strDate: dateSelected)) as? NSMutableDictionary
        {
            if let arrInterval = (dictMainData.value(forKey: getStringFromDate(strDate: dateSelected)) as! NSMutableDictionary).value(forKey: "timeIntervals") as?NSMutableArray
            {
                if arrInterval.count > 0
                {
                    let indexPath = IndexPath(row: arrInterval.count - 1, section: (dictMainData.allKeys as NSArray).index(of: getStringFromDate(strDate: dateSelected)))
                    tblList.beginUpdates()
                    tblList.scrollToRow(at: indexPath, at: UITableViewScrollPosition.none, animated: true)
                    tblList.endUpdates()
                    
                }
            }
        }
        
        UIView.transition(with: mydayview, duration: 0.3, options: UIViewAnimationOptions(rawValue: 0), animations: {
            mydayview.circleView.transform = CGAffineTransform.identity
            self.calendarManager.reload()
        }, completion: nil)
        
        if(!calendarManager.dateHelper.date(calendarContentView.date, isTheSameMonthThan: mydayview.date)){
            if(calendarContentView.date.compare(mydayview.date) == ComparisonResult.orderedAscending)
            {
                calendarContentView.loadNextPageWithAnimation()
            }
            else{
                calendarContentView.loadPreviousPageWithAnimation()
            }
        }
    }
    
    
    
    
    // MARK: - table view Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return dictMainData.allKeys.count
    }
    
    //    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return dictMainData.value(forKey: (dictMainData.allKeys as NSArray).object(at: section) as! String)  as? String
    //    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (dictMainData.allKeys as NSArray).object(at: section) as? String
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (dictMainData.allKeys as NSArray).count > 0
        {
            
            if let arrInterval = (dictMainData.value(forKey: (dictMainData.allKeys as NSArray).object(at: section) as! String) as! NSMutableDictionary).value(forKey: "timeIntervals") as?NSMutableArray
            {
                
                return arrInterval.count;
            }else{
                return 0
            }
        }else{
            return 0
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeInterval") as! TimeIntervalTableViewCell;
        
        
        
        let arrInterval = (dictMainData.value(forKey: (dictMainData.allKeys as NSArray).object(at: indexPath.section) as! String) as! NSMutableDictionary).value(forKey: "timeIntervals") as! NSMutableArray
        
        
        
        cell.btnStartTime.setTitle((arrInterval.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "StartTime") as? String, for: .normal)
        
        
        cell.btnEndTime.setTitle((arrInterval.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "EndTime") as? String, for: .normal)
        
        cell.txtNote.text = (arrInterval.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "note") as? String
        
        
        
        cell.btnStartTime.tag = indexPath.section * 100 + indexPath.row
        cell.btnStartTime.addTarget(self,action:#selector(SelectStartTime(sender:)),
                                    for:.touchUpInside)
        
        cell.btnEndTime.tag = indexPath.section * 100 + indexPath.row
        cell.btnEndTime.addTarget(self,action:#selector(SelectEndTime(sender:)),
                                  for:.touchUpInside)
        
        
        cell.txtNote.tag = indexPath.section * 100 + indexPath.row
        cell.txtNote.addTarget(self, action:#selector(textFieldTextChange(sender:)), for: .editingChanged)
        
        
        cell.lblStartDate.text = (dictMainData.allKeys as NSArray).object(at: indexPath.section) as? String
        cell.lblEndDate.text = (dictMainData.allKeys as NSArray).object(at: indexPath.section) as? String
        
        
        return cell;
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let _ = (dictMainData.value(forKey: (dictMainData.allKeys as NSArray).object(at: section) as! String) as! NSMutableDictionary).value(forKey: "timeIntervals") as?NSMutableArray
        {
            
            return 20
        }
        return 0
    }
    
    
    
    
    
    
    
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataHPrice.count
    }
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerDataHPrice[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //selectedDropDown=row
        
        let dictTemp =   dictMainData.value(forKey: getStringFromDate(strDate: dateSelected)) as! NSMutableDictionary
        
        dictTemp.setObject(pickerDataHPrice[row], forKey: "PricePerSpace" as NSCopying)
        
        updateLableValue()
    }
    
    
}







