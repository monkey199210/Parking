//
//  SelectRentOutSpaceViewController.swift
//  Parking
//
//  Created by Manveer Dodiya on 06/07/17.
//  Copyright © 2017 Manveer Dodiya. All rights reserved.
//

import UIKit
import GoogleMaps

class SelectRentOutSpaceViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {

      let Delegate = UIApplication.shared.delegate as! AppDelegate
    
    var mapView:GMSMapView!
    
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupUI()
        
        // Do any additional setup after loading the view.
        
        let camera = GMSCameraPosition.camera(withLatitude: 51.5033640, longitude: -0.1276250, zoom: 10.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        mapView.delegate = self
        // Creates a marker in the center of the map.
       /* let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -26.9124, longitude: 75.7873)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView*/
        
        
       /* let longPressRecognizer =  UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
       
        longPressRecognizer.minimumPressDuration = 0.5
        longPressRecognizer.delaysTouchesBegan = true
       
        self.mapView.addGestureRecognizer(longPressRecognizer)*/
        
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation() // start location manager
            
        }
        
      //  mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Custom Methods
    func setupUI()
    {
        self.view.backgroundColor = Utility.color(withHexString: appConstants.viewBackgroundColor)
       // self.navigationItem.hidesBackButton = true
         self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
    
    
    @IBAction func SignOut(sender: AnyObject)
    {
       // self.navigationController?.popToRootViewController(animated: true)
        Delegate.moveToLogin()
    }
    
   
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        
        
        print("didLongPressAt")
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.mapView.clear()
        self.mapView.isMyLocationEnabled = false
        marker.map = self.mapView
       /* getAddressForLatLng(coordinate.latitude, longitude: coordinate.longitude) { (addrs) in
            
            marker.title = addrs
            marker.snippet = "\(coordinate.latitude),\(coordinate.longitude)"
            
        }*/
        
        
        print(coordinate.latitude)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let objController = storyBoard.instantiateViewController(withIdentifier: "addDetails") as! AddDetailsViewController
        objController.strLat = String(format: "%lf", coordinate.latitude);
        
        objController.strLong = String(format: "%lf", coordinate.longitude);
        
        self.navigationController?.pushViewController(objController, animated: true)
    }
    
    
   /* func getAddressForLatLng(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completionBlock : ((addrs : String)->Void)) {
        let url = NSURL(string: "\(baseUrl)latlng=\(latitude),\(longitude)&key=\(serverKey)")
        print(url)
        
        
        let data = NSData(contentsOfURL: url!)
        let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
        if let result = json["results"] as? NSArray {
            if let address = result[0]["address_components"] as? NSArray {
                let number = address[0]["short_name"] as! String
                let street = address[1]["short_name"] as! String
                let city = address[2]["short_name"] as! String
                let state = address[4]["short_name"] as! String
                let zip = address[6]["short_name"] as! String
                print("\(number) \(street), \(city), \(state) \(zip)")
                completionBlock(addrs: "\(number) \(street), \(city), \(state) \(zip)")
                
            }
        }
    }*/
    
    
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


}
