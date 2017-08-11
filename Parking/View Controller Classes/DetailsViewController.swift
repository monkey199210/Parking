//
//  DetailsViewController.swift
//  Parking
//
//  Created by Manveer Dodiya on 24/07/17.
//  Copyright © 2017 Manveer Dodiya. All rights reserved.
//

import UIKit
import JTCalendar
import Firebase

class DetailsViewController: UIViewController,JTCalendarDelegate,UITableViewDataSource, UITableViewDelegate {

    let Delegate = UIApplication.shared.delegate as! AppDelegate
    
    var calendarManager:JTCalendarManager!
    
    @IBOutlet var calendarMenuView:JTCalendarMenuView!
    @IBOutlet var calendarContentView:JTHorizontalCalendarView!
    
    @IBOutlet var tblList:UITableView!
    
    @IBOutlet var lblConatctName:UILabel!
    @IBOutlet var btnContactNumber:UIButton!
    
     var dateSelected = NSDate()
    
     var dictMainData:NSMutableDictionary = [:]
    
    
    var arrBookingList:NSMutableArray!
    
    
    
    override func viewDidLoad() {
        
        
        self.lblConatctName.text =  ""
        self.btnContactNumber.setTitle( "", for: .normal)
        
        super.viewDidLoad()
        
         arrBookingList=NSMutableArray()
        
         setupUI()

        
        calendarManager = JTCalendarManager()
        calendarManager.delegate = self
        calendarManager.menuView = calendarMenuView
        calendarManager.contentView = calendarContentView
        
        let mydate = Date()
        calendarManager.setDate(mydate)

        // Do any additional setup after loading the view.
        
        getBookingListFromServer()
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
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.barTintColor = Utility.color(withHexString: appConstants.navColor)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.view.backgroundColor = Utility.color(withHexString: appConstants.viewBackgroundColor)
        
        
    }
    
    
    func getStringFromDate(strDate: NSDate)-> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        
        return dateFormatter.string(from: strDate as Date)
    }
    
    
    
    
    
    func getDataFromServer()
    {
        
        dictMainData = [:]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let parentRef = FIRDatabase.database().reference().child("RentOutSpace").child((FIRAuth.auth()?.currentUser?.uid)!)
        parentRef.observe(.value, with: { snapshot in
            
            // NSLog("chil %@", snapshot.value! as! NSDictionary)
            
           print(snapshot.value ?? "")
            
            parentRef.removeAllObservers()
            
            
            if !(snapshot.value is NSNull)
            {
           let tempDict = (snapshot.value as! NSDictionary).mutableCopy() as! NSMutableDictionary
                
                
                let keysArray = tempDict.allKeys as NSArray
                
                for strkey in keysArray
                {
                    let dictInfo = tempDict.value(forKey: strkey as! String) as! NSDictionary
                    
                    if (dictInfo.allKeys as NSArray).contains("timeIntervals")
                    {
                        self.dictMainData.setValue(dictInfo, forKey: strkey as! String)
                    }
                }
                
                
            }
            
            
            
            
            
           print(self.dictMainData)
            
            
            
            
            
            
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
    
    
    
    
    
    // MARK: - IBActions
    
    @IBAction func SignOut(sender: AnyObject)
    {
       // self.navigationController?.popToRootViewController(animated: true)
        Delegate.moveToLogin()
    }
    
    
    
    @IBAction func AddDetails(sender: AnyObject)
    {
        let objController = storyboard?.instantiateViewController(withIdentifier: "addDetails") as! AddDetailsViewController
        self.navigationController?.pushViewController(objController, animated: true)
    }
    
    
    @IBAction func CancelAvaliblality(sender: AnyObject)
    {
         let arrInterval = (dictMainData.value(forKey: getStringFromDate(strDate: dateSelected)) as! NSMutableDictionary).value(forKey: "timeIntervals") as! NSMutableArray
        
        arrInterval.removeObject(at: sender.tag)
        
       // let dict = arrInterval.object(at: sender.tag) as! NSMutableDictionary
       // dict.setValue("Cancel", forKey: "BookingStatus")
        
        
       MBProgressHUD.showAdded(to: self.view, animated: true)
        let databaseRef = FIRDatabase.database().reference()
        
        databaseRef.child("RentOutSpace").child((FIRAuth.auth()?.currentUser?.uid)!).child(getStringFromDate(strDate: dateSelected)).child("timeIntervals").setValue(arrInterval)
        
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        
        
        tblList.reloadData()
        
        print(dictMainData)
        
        getDataFromServer()
    }
    
    
    
    @IBAction func makeAvaliblality(sender: AnyObject)
    {
        let arrInterval = (dictMainData.value(forKey: getStringFromDate(strDate: dateSelected)) as! NSMutableDictionary).value(forKey: "timeIntervals") as! NSMutableArray
        
        let dict = arrInterval.object(at: sender.tag) as! NSMutableDictionary
        dict.setValue("available", forKey: "BookingStatus")
        
        tblList.reloadData()
        
        print(dictMainData)
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
        else if(String(describing: dateSelected) != "" && calendarManager.dateHelper.date(dateSelected as Date!, isTheSameDayThan: mydayview.date))
        {
           
            mydayview.circleView.isHidden = false;
            mydayview.circleView.backgroundColor = UIColor.red
            mydayview.dotView.backgroundColor = UIColor.white
            mydayview.textLabel.textColor = UIColor.white
           
        }
        else if  ((dictMainData.allKeys as NSArray).contains(getStringFromDate(strDate: mydayview.date! as NSDate)))
        {
            if  ((dictMainData.value(forKey: getStringFromDate(strDate: mydayview.date! as NSDate)) as! NSMutableDictionary).allKeys as NSArray).contains("timeIntervals")
            {
                
                
            let arrInterval = (dictMainData.value(forKey: getStringFromDate(strDate: mydayview.date! as NSDate)) as! NSMutableDictionary).value(forKey: "timeIntervals") as! NSMutableArray

                if arrInterval.count > 0
                {
                    mydayview.circleView.isHidden = false;
                    mydayview.circleView.backgroundColor = UIColor.lightGray
                    mydayview.dotView.backgroundColor = UIColor.white
                    mydayview.textLabel.textColor = UIColor.white
                }
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
        print()
        
        let today = Date()
        
       if (mydayview.date as Date)  < today.addingTimeInterval(-24*60*60)
       {
            return
        }
        
        dateSelected=mydayview.date as NSDate
        
        
        findContactNumberInBookingList(strDate: getStringFromDate(strDate: dateSelected))
        
        
       // createDataOnDate(strDate: dateSelected)
        
        
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
        
        tblList.reloadData()
    }
    
    
    
    
    // MARK: - table view Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if ((dictMainData.allKeys as NSArray).contains(getStringFromDate(strDate: dateSelected)))
        {
            if  ((dictMainData.value(forKey: getStringFromDate(strDate: dateSelected)) as! NSMutableDictionary).allKeys as NSArray).contains("timeIntervals")
            {
            let arrInterval = (dictMainData.value(forKey: getStringFromDate(strDate: dateSelected)) as! NSMutableDictionary).value(forKey: "timeIntervals") as! NSMutableArray
            
            return arrInterval.count;
            }
            else
            {
                return 0;
            }
        }
        else
        {
            return 0;
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell") as! DetailTableViewCell;
        
        
        
        let arrInterval = (dictMainData.value(forKey: getStringFromDate(strDate: dateSelected)) as! NSMutableDictionary).value(forKey: "timeIntervals") as! NSMutableArray
        
        cell.lblStartTime .text = String.init(format: "%@ %@", ((arrInterval.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "StartTime") as? String)! ,  getStringFromDate(strDate: dateSelected))
        
          cell.lblEndTime .text = String.init(format: "%@ %@", ((arrInterval.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "EndTime") as? String)! ,  getStringFromDate(strDate: dateSelected))
        
        
        
        if ((arrInterval.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "BookingStatus") as! String == "available")
        {
            cell.btnCancel.setTitle("Cancel", for: .normal)
            cell.btnCancel.isEnabled = true
            
            cell.btnCancel.tag = indexPath.row
            cell.btnCancel.addTarget(self, action: #selector(CancelAvaliblality(sender:)), for: .touchUpInside)
        }
            
       else  if ((arrInterval.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "BookingStatus") as! String == "Cancel")
        {
            cell.btnCancel.setTitle("Make Avail", for: .normal)
            cell.btnCancel.isEnabled = true
            
            cell.btnCancel.tag = indexPath.row
            cell.btnCancel.addTarget(self, action: #selector(makeAvaliblality(sender:)), for: .touchUpInside)
        }
        else
        {
            cell.btnCancel.setTitle("Booked", for: .normal)
            cell.btnCancel.isEnabled = false
        }
        
        
        
        
        
      /*  cell.btnStartTime.setTitle((arrInterval.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "StartTime") as? String, for: .normal)
        
        
        cell.btnEndTime.setTitle((arrInterval.object(at: indexPath.row) as! NSMutableDictionary).value(forKey: "EndTime") as? String, for: .normal)*/
        
        
        
    
        
        
        
        
        
        return cell;
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
            
            
            
            
            
            for child in snapshot.children {
                
                print((child as! FIRDataSnapshot).key)
                
                let dataDict = NSMutableDictionary()
                
                dataDict.setValue((child as! FIRDataSnapshot).key, forKey: "Key")
                
                dataDict.setValue((child as! FIRDataSnapshot).value ?? "", forKey: "Value")
                
                
                
              
                
                self.arrBookingList.add(dataDict)
               
                
                
                
                
            }
            
            
            
            print(self.arrBookingList)
            
            
            
            
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            
        })
    }
    
    
    
    
    func findContactNumberInBookingList(strDate: String)
    {
        print(strDate)
        
        self.lblConatctName.text = ""
        self.btnContactNumber.setTitle( "", for: .normal)
        
        for dict in arrBookingList
        {
            let dictBooking = dict as! NSDictionary
            
            
            if (dictBooking.value(forKey: "Value") as! NSDictionary).value(forKey: "UID") as? String == FIRAuth.auth()?.currentUser?.uid
            {
                 if (((dictBooking.value(forKey: "Value") as! NSDictionary).value(forKey: "bookingDate") as? String)?.contains(strDate))!
                 {
                   print("hello")
                    
                    
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                    
                    let bookingUID = (dictBooking.value(forKey: "Value") as! NSDictionary).value(forKey: "Book_UID") as? String
                    
                    let parentRef = FIRDatabase.database().reference().child("Users").child(bookingUID!)
                    parentRef.observe(.value, with: { snapshot in
                        
                        // NSLog("chil %@", snapshot.value! as! NSDictionary)
                        
                        
                         if snapshot.value != nil
                         {
                         if !(snapshot.value  is NSNull)
                         {
                            let value = snapshot.value as? NSDictionary
                            
                            self.lblConatctName.text = String.init(format: "Name : %@", value?["Name"] as? String ?? "")
                            self.btnContactNumber.setTitle(String.init(format: "Phone : %@", value?["Phone"] as? String ?? ""), for: .normal)
                         }
                         }
                        
                        
                       
                        
                        
                        
                        
                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                        
                    })

                }
            }
            
            
            
        }
    }

    
}
