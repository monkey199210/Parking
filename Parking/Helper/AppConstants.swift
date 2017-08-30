//
//  AppConstants.swift
//  CellRepair
//
//  Created by zinzu on 29/03/2017.
//  Copyright © 2017 zinzu. All rights reserved.
//

import UIKit

let appConstants = AppConstants()
class AppConstants: NSObject {
    let AppName = "Driveway";
    let PLEASE_WAIT =         "Please Wait.";
    let navColor = "e83501"
    let viewBackgroundColor = "f5f4f5"
    //let GOOGLE_API_KEY = "AIzaSyCsO6zscYPsqMkOlMHuhgjcpwIvCBC_dHo";
   
    
    
    let API_URL = "http://mannaplus.ph/manna_api/web/api/v2/";
    
    let DIGITAL_CREATE   =      "digits/create";
    let REGISTER_ACCOUNT  =     "create/app-users";
    let LOGIN =                 "login";
    let STATUS_LIST:[String] = ["Active","Inactive"];
    let APPOINTMENT_TYPE:[String] = ["Check up","Vaccine"];
    let BLOOD_TYPE:[String] = ["A","A+","B","B+","AB","O","O+"];
    let GENDER_TYPE:[String] = ["Male","Female"];
    let VACCINE_SESSIONS:[String] = ["1st","2nd","3rd","Booster 1","Booster 2","Booster 3"];
    let IMAGE_SOURCE:[String] = ["Gallery","Camera"];
    
    var login:String {
        get {
            let value=API_URL+LOGIN;
            return value;
        }
    }
    
    var registerAccount:String {
        get {
            let value=API_URL+REGISTER_ACCOUNT;
            return value;
        }
    }
    
    var TIMES_LIST:[String] {
        get {
            var value:[String]=[String]();
            let calendar = Calendar.current
            let start=6;
            let date=Date();
            let df=DateFormatter();
             df.dateFormat="hh:mm a";
            df.timeZone = NSTimeZone(abbreviation: "GMT")! as TimeZone
            var dt1=calendar.date(bySettingHour: start, minute: 0, second: 0, of: date);
            value.append(df.string(from: dt1!));
            for _ in 0 ..< 30 {
                dt1=calendar.date(byAdding: .minute, value: 30, to: dt1!);
                value.append(df.string(from: dt1!));
            }
            return value;
        }
    }

    
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }

}
