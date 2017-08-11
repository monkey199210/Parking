//
//  UserDefaultHelper.swift
//  CellRepair
//
//  Created by zinzu on 29/03/2017.
//  Copyright © 2017 zinzu. All rights reserved.
//

import UIKit


let userInfo=UserDefaultHelper()

class UserDefaultHelper: NSObject {
    
    
    let userDefaults = UserDefaults.standard
    
    var loginType:String? {
        get {
            let type=userDefaults.string(forKey: "loginType");
            return type!;
        }
        set(newtype) {
            userDefaults.set(newtype, forKey: "loginType");userDefaults.synchronize();
        }
    }
    var username:String? {
        get {
            let value=userDefaults.string(forKey: "username");
            return value!;
        }
        set(value) {
            userDefaults.set(value, forKey: "username");userDefaults.synchronize();
        }

    }
    var passkey:String? {
        get {
            let value=userDefaults.string(forKey: "pass");
            return value!;
        }
        set(value) {
            userDefaults.set(value, forKey: "pass");userDefaults.synchronize();
        }
    };
    var avatar:String? {
        get {
            let value=userDefaults.string(forKey: "avatar");
            return value!;
        }
        set(value) {
            userDefaults.set(value, forKey: "avatar");userDefaults.synchronize();
        }
    };
    var userid:String? {
        get {
            let value=userDefaults.string(forKey: "id");
            return value!;
        }
        set(value) {
            userDefaults.set(value, forKey: "id");
            userDefaults.synchronize();
        }
    };
    
    var firstName:String? {
        get {
            let type=userDefaults.string(forKey: "first");
            return type!;
        }
        set(newtype) {
            userDefaults.set(newtype, forKey: "first");userDefaults.synchronize();
        }
    }
    
    var lastName:String? {
        get {
            let type=userDefaults.string(forKey: "last");
            return type!;
        }
        set(newtype) {
            userDefaults.set(newtype, forKey: "last");userDefaults.synchronize();
        }
    }
    
    var lastAccess:String? {
        get {
            let type=userDefaults.string(forKey: "lastAccess");
            return type!;
        }
        set(newtype) {
            userDefaults.set(newtype, forKey: "lastAccess");userDefaults.synchronize();
        }
    }
    
    var mommy:String? {
        get {
            let type=userDefaults.string(forKey: "mommy");
            return type!;
        }
        set(newtype) {
            userDefaults.set(newtype, forKey: "mommy");userDefaults.synchronize();
        }
    }
    
    var fbtoken:String? {
        get {
            let type=userDefaults.string(forKey: "fbtoken");
            return type!;
        }
        set(newtype) {
            userDefaults.set(newtype, forKey: "fbtoken");userDefaults.synchronize();
        }
    }
    
    var activeDoctor:String? {
        get {
            let type=userDefaults.string(forKey: "activeDoctor");
            return type!;
        }
        set(newtype) {
            userDefaults.set(newtype, forKey: "activeDoctor");userDefaults.synchronize();
        }
    }
    
    var doctor:String? {
        get {
            let type=userDefaults.string(forKey: "doctor");
            return type!;
        }
        set(newtype) {
            userDefaults.set(newtype, forKey: "doctor");userDefaults.synchronize();
        }
    }
    
    var doctorName:String? {
        get {
            let type=userDefaults.string(forKey: "doctorName");
            return type!;
        }
        set(newtype) {
            userDefaults.set(newtype, forKey: "doctorName");userDefaults.synchronize();
        }
    }


    
    
    
    
    override init() {
        super.init();
        init_info();
    }
    
    func init_info()->(){
        self.loginType=userDefaults.string(forKey: "loginType") ?? "none";
        self.userid=userDefaults.string(forKey: "id") ?? "";
        self.username=userDefaults.string(forKey: "username") ?? "";
        self.avatar=userDefaults.string(forKey: "avatar") ?? "";
        self.firstName=userDefaults.string(forKey: "firstName") ?? "";
        self.lastName=userDefaults.string(forKey: "lastName") ?? "";
        self.mommy=userDefaults.string(forKey: "mommy") ?? "";
        self.activeDoctor=userDefaults.string(forKey: "activeDoctor") ?? "none";
        self.doctor=userDefaults.string(forKey: "doctor") ?? "";
        self.doctorName=userDefaults.string(forKey: "doctorName") ?? "";
        self.lastAccess=userDefaults.string(forKey: "lastAccess") ?? "";
        self.fbtoken=userDefaults.string(forKey: "fbtoken") ?? "";
        
    }
    
    func clear()->(){
        self.loginType="none";
        self.userid="";
        self.username="";
        self.avatar="";
        self.firstName="";
        self.lastName="";
        self.mommy="";
        self.activeDoctor="none";
        self.doctor="";
        self.doctorName="";
        self.lastAccess="";
        self.fbtoken="";

    }
}
