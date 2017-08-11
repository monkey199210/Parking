//
//  Utility.h
//  Fisseha
//
//  Created by Manveer Dodiya on 01/04/17.
//  Copyright © 2017 Manveer Dodiya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface Utility : NSObject

+(UIColor*)colorWithHexString:(NSString*)hex;

+(void)setupButtonStyle:(UIButton*)btn;

+ (BOOL)validateEmailWithString:(NSString*)emailtext;

+(void)Alert:(NSString *)Message andTitle:(NSString *)Title andController:(UIViewController*)objController;

+(BOOL)checkInternetConnection;


+(NSString *)getTimeFromDate:(NSString*)strCreateDate;

+ (NSString*)base64forData:(NSData*)theData;


+ (BOOL)validatePasswordWithString:(UITextField*)textField;

+(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr;

@end
