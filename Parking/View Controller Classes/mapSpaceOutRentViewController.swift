//
//  mapSpaceOutRentViewController.swift
//  Parking
//
//  Created by Manveer Dodiya on 04/07/17.
//  Copyright © 2017 Manveer Dodiya. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase

class mapSpaceOutRentViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

      let Delegate = UIApplication.shared.delegate as! AppDelegate
    
    var arrData:NSMutableArray!
    var mapView:GMSMapView!
    
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    
    
    @IBOutlet var viewMapContainer:UIView!
    @IBOutlet var viewPopC1A:UIView!
    @IBOutlet var lblAddressC1A:UILabel!
    @IBOutlet var lblNoteC1A:UILabel!
    
    var selectedKey:String = ""
    
    override func viewDidLoad() {
        
        arrData=NSMutableArray()
        
        super.viewDidLoad()
        
        setupUI()

        // Do any additional setup after loading the view.
        
       let camera = GMSCameraPosition.camera(withLatitude:0 , longitude: 0, zoom: 10.0)
      
         mapView = GMSMapView.map(withFrame: viewMapContainer.bounds, camera: camera)
        mapView.delegate = self
        
          viewMapContainer.addSubview(mapView)
        
      //  view = mapView
        
       /* // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -26.9124, longitude: 75.7873)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView*/
        
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation() // start location manager
            
        }
        
       // mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
    override func viewWillAppear(_ animated: Bool) {
        getMapDataFromServer()
    }
    
    
    
    
    
     // MARK: - Custom Methods
    func setupUI()
    {
        self.view.backgroundColor = Utility.color(withHexString: appConstants.viewBackgroundColor)
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.barTintColor = Utility.color(withHexString: appConstants.navColor)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.view.backgroundColor = Utility.color(withHexString: appConstants.viewBackgroundColor)
    }
    
    
    
    func getMapDataFromServer()
    {
        
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let parentRef = FIRDatabase.database().reference().child("RentOutSpace")
        parentRef.observe(.value, with: { snapshot in
            
            // NSLog("chil %@", snapshot.value! as! NSDictionary)
            
            self.arrData.removeAllObjects()
            
            
            let arrTempData = NSMutableArray()
            
            parentRef.removeAllObservers()
            
            for child in snapshot.children {
                
                print((child as! FIRDataSnapshot).key)
                
                let dataDict = NSMutableDictionary()
                
                dataDict.setValue((child as! FIRDataSnapshot).key, forKey: "Key")
                
                dataDict.setValue((child as! FIRDataSnapshot).value ?? "", forKey: "Value")
                
                arrTempData.add(dataDict)
            }
            
            
            
            NSLog("before filter %@", arrTempData)
            
            
            // self.mapView.clear()
            
            for i:Int in 0..<arrTempData.count
            {
                let tempDict=(arrTempData.object(at: i) as! NSDictionary).value(forKey: "Value") as! NSDictionary
                
                
                let strDate = tempDict["avail_date"]as! String
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MMM-yyyy"
                
                let today:Date = Date()
                
               // if(today != dateFormatter.date(from: strDate))
               // {
                    
                    self.arrData.add(arrTempData.object(at: i) as! NSDictionary)
                    
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: Double(tempDict["lat"]as! String)!, longitude: Double(tempDict["long"]as! String)!)
                    marker.title = ""
                    marker.snippet = ""
                    marker.map = self.mapView
                    marker.userData = arrTempData.object(at: i) as! NSDictionary
                //}
            }
            
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            
        })    }
    
    
    
    
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
        
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        
        self.mapView?.animate(to: camera)
        
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        marker.title = "Current Location"
        marker.snippet = ""
        marker.icon = GMSMarker.markerImage(with: UIColor.blue)
        marker.map = mapView
        
        
        
        
        
        
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
    //MARK: - IBActions
    
    @IBAction func SignOut(sender: AnyObject)
    {
        //self.navigationController?.popToRootViewController(animated: true)
        Delegate.moveToLogin()
    }
    
    @IBAction func AddMorePlaces(sender: AnyObject)
    {
       
    }
    
    @IBAction func hidePopups(sender: AnyObject)
    {
        viewPopC1A.isHidden = true
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool
    {
        print(marker.userData ?? " ")
        
        
        
        
        let tempDict = (marker.userData as? NSDictionary)?.value(forKey: "Value") as? NSDictionary
        
        selectedKey = (marker.userData as? NSDictionary)?.value(forKey: "Key") as! String
        
        if tempDict == nil
        {
            return false
        }
        
        viewPopC1A.isHidden = false
        
        let location = CLLocation(latitude: Double(tempDict?["lat"]as! String)!, longitude: Double(tempDict?["long"]as! String)!) //changed!!!
        print(location)
        
        
        
        let timeIntervals = tempDict?["timeIntervals"]as! NSArray
        
        if(timeIntervals.count>0)
        {
            let dictInterval = timeIntervals.firstObject as! NSDictionary
            lblNoteC1A.text = dictInterval["note"]as? String
        }
        
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
        

        return false
    }

}
