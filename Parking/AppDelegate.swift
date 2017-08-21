//
//  AppDelegate.swift
//  Parking
//
//  Created by Manveer Dodiya on 28/06/17.
//  Copyright © 2017 Manveer Dodiya. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import GoogleMaps
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging

import Alamofire


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate, FIRMessagingDelegate {

    var window: UIWindow?
    var elapsedTime=0
    var appFlag=2
    var mySeconds=0
    
    var myValue=0


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        
        IQKeyboardManager.sharedManager().enable = true
        
        
        GMSServices.provideAPIKey("AIzaSyCu3tVLj16hExy3XVs_iY8bHoInFD6nqoQ")
      //  GMSPlacesClient.provideAPIKey("AIzaSyCu3tVLj16hExy3XVs_iY8bHoInFD6nqoQ")
        
        
        
        
        if getUID().characters.count > 0
        {
            if getLoginType().characters.count > 0
            {
               if(getLoginType() == "RentSpace")
               {
               
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let objController = storyBoard.instantiateViewController(withIdentifier: "mapSpace") as! mapSpaceRentViewController
                let navController = UINavigationController.init(rootViewController: objController)
                self.window?.rootViewController = navController
                
                }
                else
               {
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
               // let objController = storyBoard.instantiateViewController(withIdentifier: "mapSpaceOut") as! mapSpaceOutRentViewController
                
                
                let objController = storyBoard.instantiateViewController(withIdentifier: "detailsView") as! DetailsViewController
                let navController = UINavigationController.init(rootViewController: objController)
                self.window?.rootViewController = navController
                
                }
            }
        }
        else
        {
            print("not login ")
        }
        
        
        
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        FIRApp.configure()
        
        
       
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM.")
        
//        let date = Date()
//        let calendar = Calendar.current
//        let hour = calendar.component(.hour, from: date)
//        let minutes = calendar.component(.minute, from: date)
//        let seconds=calendar.component(.second, from: date)
    
//        elapsedTime=(hour*3600)+(minutes*60)+seconds
        elapsedTime = Int(Date().timeIntervalSince1970)

        appFlag=1

        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        
//        let date = Date()
//        let calendar = Calendar.current
//        let hour = calendar.component(.hour, from: date)
//        let minutes = calendar.component(.minute, from: date)
//        let seconds=calendar.component(.second, from: date)
//        elapsedTime=((hour*3600)+(minutes*60)+seconds)-elapsedTime
        
        
        elapsedTime=Int(Date().timeIntervalSince1970)-elapsedTime
        
        self.mySeconds=self.mySeconds+elapsedTime
        appFlag=0
        
        
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        
        print ("App is closing now")
    }

    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
        
       
        
        
    }
    
    
    
    func setUID(strUID:String)
    {
        let defaults=UserDefaults.standard
        defaults.setValue(strUID, forKey: "UID")
        defaults.synchronize()
    }
    
    func getUID() -> String
    {
        
        if UserDefaults.standard.value(forKey: "UID") == nil
        {
            return ""
        }
        else
        {
            return UserDefaults.standard.value(forKey: "UID") as! String!
        }
    }
    
    
    
    func getBookingTime()->Int
    {
        if UserDefaults.standard.value(forKey: "BookingTime") == nil
        {
            return 0
        }
        else
        {
            return UserDefaults.standard.value(forKey: "BookingTime") as! Int!
        }

    }
    
    
    func setBookingTime(strDate:Int)
    {
        let defaults=UserDefaults.standard
        defaults.setValue(strDate, forKey: "BookingTime")
        defaults.synchronize()
    }
    
    
    
    func getBookingFlag()->String
    {
        if UserDefaults.standard.value(forKey: "BookingFlag") == nil
        {
            return ""
        }
        else
        {
            return UserDefaults.standard.value(forKey: "BookingFlag") as! String!
        }
        
    }
    
    
    func setBookingFlag(strDate:String)
    {
        let defaults=UserDefaults.standard
        defaults.setValue(strDate, forKey: "BookingFlag")
        defaults.synchronize()
    }

    
    
    func setLoginType(strType:String)
    {
        let defaults=UserDefaults.standard
        defaults.setValue(strType, forKey: "LoginType")
        defaults.synchronize()
    }
    
    func getLoginType() -> String
    {
        
        if UserDefaults.standard.value(forKey: "LoginType") == nil
        {
            return ""
        }
        else
        {
            return UserDefaults.standard.value(forKey: "LoginType") as! String!
        }
    }
    
    func setReportSubmitText(strType:String)
    {
        let defaults=UserDefaults.standard
        defaults.setValue(strType, forKey: "reportText")
        defaults.synchronize()
    }
    
    func getReportSubmitText() -> String
    {
        
        if UserDefaults.standard.value(forKey: "reportText") == nil
        {
            return ""
        }
        else
        {
            return UserDefaults.standard.value(forKey: "reportText") as! String!
        }
    }
    func removeReportSubmitText()
    {
        if UserDefaults.standard.value(forKey: "reportText") != nil
        {
            UserDefaults.standard.removeObject(forKey: "reportText")
        }
    }
    
    

    func moveToLogin()
    {
        
        setUID(strUID: "")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let objController = storyBoard.instantiateViewController(withIdentifier: "login") as! LoginViewController
         let navController = UINavigationController.init(rootViewController: objController)
        window?.rootViewController = navController
        removeReportSubmitText()
        
    }
    
    
    
    
    
    
    
    
    ///notifications
    
    
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print(remoteMessage.appData)
        
        /* let importAlert: UIAlertController = UIAlertController(title: "applicationReceivedRemoteMessage/FIRMessagingRemoteMessage", message: remoteMessage.appData.description, preferredStyle: UIAlertControllerStyle.alert)
         importAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
         importAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler:
         { action in
         
         }))
         
         self.window?.rootViewController?.present(importAlert, animated: true, completion: nil)*/
        
    }

    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        print("Handle push from foreground")
        // custom code to handle push while app is in the foreground
        print("\(notification.request.content.userInfo)")
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Handle push from background or closed")
        // if you set a member variable in didReceiveRemoteNotification, you  will know if this is from closed or background
        print("\(response.notification.request.content.userInfo.description)")
        
        
       
        
        
    }
    
    
    
    
    
    //// new
    
    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Let FCM know about the message for analytics etc.
        FIRMessaging.messaging().appDidReceiveMessage(userInfo)
        // handle your message
    }
    
    
    
    func application(remoteMessage: FIRMessagingRemoteMessage)  {
        
        
        /*let importAlert: UIAlertController = UIAlertController(title: "FIRMessagingRemoteMessage", message: remoteMessage.appData.description, preferredStyle: UIAlertControllerStyle.alert)
         importAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
         importAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler:
         { action in
         
         }))
         
         self.window?.rootViewController?.present(importAlert, animated: true, completion: nil)*/
        
    }
    
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        // let strToken = NSString.init(data: deviceToken, encoding: String.Encoding.utf8.rawValue)
        //  let strToken = NSString(data: deviceToken, encoding: NSUTF8StringEncoding)
        
        let strToken = String(data: deviceToken, encoding: String.Encoding.utf8)
        
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(token)
        
        print("DEVICE TOKEN = \(String(describing: FIRInstanceID.instanceID().token()))")
        
        
        
        
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: .unknown)
        // FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: .sandbox)
        
        
        if getUID().characters.count > 0
        {
            let databaseRef = FIRDatabase.database().reference()
            let  locationRef = databaseRef.child("Users").child(getUID()).child("deviceToken")
            
            
            
            var token = FIRInstanceID.instanceID().token()
            
            token = token?.replacingOccurrences(of: "Optional(\"", with: "")
            token = token?.replacingOccurrences(of: "\")", with: "")
            
            locationRef.setValue(token)
            
            
            FIRMessaging.messaging().subscribe(toTopic: getUID())
            
            //locationRef.setValue(String(describing: FIRInstanceID.instanceID().token()))
        }
        
    }
    
    
    
    
    
    
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    
    
    func connectToFcm() {
        // Won't connect since there is no token
        guard FIRInstanceID.instanceID().token() != nil else {
            return
        }
        
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error?.localizedDescription ?? "")")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        /*if let messageID = userInfo[gcmMessageIDKey] {
         print("Message ID: \(messageID)")
         }*/
        
        // Print full message.
        
        
        
        print(userInfo)
        
        
        
    }
    
    
    
    
    
    
    
    
    
    func API_SendNotfication(userID: String, message: String)
    
    {
        
        
        
        let strURL =  "https://fcm.googleapis.com/fcm/send"
        
        
        let notification = [
            "body" : message,
            
            "sound" : "default",
        ]
        
        let parameters: Parameters = [
            
            "to": String.init(format: "/topics/%@", userID),
            "priority": "high",
            "sound" : "chime.aiff",
            "notification": notification,
            
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Key=AAAAKJ6c0oI:APA91bHX-wfqlvrvTtRHP_asKXHM4ON6XqAdYDj0OSjrrBWwO6N8t41GXpPVcUht5xBaKJPiwov_PTZUWWu-YBFGNIkr4IWidpaIKd8UF9T6zzWib21j-HF1M_mmNtyHS_BS29Aqm-t_",
            "Accept": "application/json"
        ]
        
        
        
       
        
        Alamofire.request(strURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            debugPrint(response)
            
            
            
           /* if let JSON = response.result.value
            {
                print("JSON: \(JSON)")
                
                let jsonDict = JSON as? NSDictionary
                if(jsonDict?["status"]! as! String == "ok")
                {
                    print("Success")
                    self.appDelegate.setUserInfo(dictInfo: (jsonDict?["contact"]! as! NSDictionary?)!)
                    self.appDelegate.setUserName(userName: self.txtUserName.text!)
                    self.appDelegate.setPassword(password: self.txtPassword.text!)
                    
                    self.appDelegate.ShowMainController(index: 0)
                }
                else
                {
                    print("failure")
                    self.Alert(Message: jsonDict?["msg"]! as! String, Title: "")
                }
                
            }*/
            
        }
        
        
    }
    
    
    
    
    func ScheduleLocalNotification(strMessage: String, time: Date)
    {
        if #available(iOS 10.0, *) {
            
            let content = UNMutableNotificationContent()
            
           // content.title = "MultiTimer"
            content.body = strMessage
          //  content.userInfo = userData
            
            let interval = time
            
            content.sound = UNNotificationSound.default()
            
        
                
                
         
            
            
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time.timeIntervalSinceNow, repeats: false)
            
            let request = UNNotificationRequest(identifier: "second", content: content, trigger: trigger)
            
            // Schedule the notification.
            let center = UNUserNotificationCenter.current()
            center.add(request) { (error) in
                print(error)
                
                
                
            }
            print("should have been added")
            
            
            
        } else {
            
            
            
            let localNotification = UILocalNotification()
            
           
                localNotification.soundName = UILocalNotificationDefaultSoundName
           
            
            
            localNotification.alertBody = strMessage
            localNotification.timeZone = NSTimeZone.system
            localNotification.fireDate = time
          //  localNotification.alertTitle = "MultiTimer"
            //localNotification.userInfo = userData
            
            UIApplication.shared.scheduleLocalNotification(localNotification)
        }
    }


}



