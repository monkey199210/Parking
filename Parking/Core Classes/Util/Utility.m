//
//  Utility.m
//  Fisseha
//
//  Created by Manveer Dodiya on 01/04/17.
//  Copyright © 2017 Manveer Dodiya. All rights reserved.
//

#import "Utility.h"


@implementation Utility





#pragma mark Color with Hexa String
+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    //if ([cString length] != 6) return  [UIColor grayColor];
    
    if ([cString length] == 6)
    {
        // Separate into r, g, b substrings
        NSRange range;
        range.location = 0;
        range.length = 2;
        NSString *rString = [cString substringWithRange:range];
        
        range.location = 2;
        NSString *gString = [cString substringWithRange:range];
        
        range.location = 4;
        NSString *bString = [cString substringWithRange:range];
        
        
        
        // Scan values
        unsigned int r, g, b;
        [[NSScanner scannerWithString:rString] scanHexInt:&r];
        [[NSScanner scannerWithString:gString] scanHexInt:&g];
        [[NSScanner scannerWithString:bString] scanHexInt:&b];
        
        
        
        return [UIColor colorWithRed:((float) r / 255.0f)
                               green:((float) g / 255.0f)
                                blue:((float) b / 255.0f)
                               alpha:1.0f];
    }
    else
        return [UIColor grayColor];
    
}



+(void)setupButtonStyle:(UIButton*)btn
{
    btn.layer.cornerRadius=5;
   // [btn setBackgroundColor:[Utility colorWithHexString:blueoColor]];
    
    btn.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    btn.layer.shadowOffset = CGSizeMake(0, 1.0f);
    btn.layer.shadowOpacity = 1.0f;
    btn.layer.shadowRadius = 2.0f;
    btn.layer.masksToBounds = NO;
    
}




#pragma mark- Email_validation

+ (BOOL)validateEmailWithString:(NSString*)emailtext
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailtext];
}



+ (BOOL)validatePasswordWithString:(UITextField*)textField
{
    
    
        int numberofCharacters = 0;
        BOOL lowerCaseLetter = false,upperCaseLetter = false,digit = 0;
        if([textField.text length] >= 8)
        {
            for (int i = 0; i < [textField.text length]; i++)
            {
                unichar c = [textField.text characterAtIndex:i];
                if(!lowerCaseLetter)
                {
                    lowerCaseLetter = [[NSCharacterSet lowercaseLetterCharacterSet] characterIsMember:c];
                }
                if(!upperCaseLetter)
                {
                    upperCaseLetter = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:c];
                }
                if(!digit)
                {
                    digit = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c];
                }
               
            }
            
           // if( digit && lowerCaseLetter && upperCaseLetter)
                 if( digit )
            {
                //do what u want
                
                return true;
            }
            else
            {
               return false;
            }
            
        }
        else
        {
            return false;
        }
    
}



#pragma Mark - Alert Function

+(void)Alert:(NSString *)Message andTitle:(NSString *)Title andController:(UIViewController*)objController
{
    UIAlertController *alert_controller=[UIAlertController alertControllerWithTitle:Title message:Message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alert_action=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert_controller addAction:alert_action];
    [objController presentViewController:alert_controller animated:YES completion:nil];
}



#pragma mark - check internet connection
/*+(BOOL)checkInternetConnection
{
    
    // Reachability *reachability = [Reachability reachabilityForInternetConnection];
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus == NotReachable;
    
}*/




+(NSString *)getTimeFromDate:(NSString*)strCreateDate
{
    
    ////for date
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *createdDate=[formatter dateFromString:strCreateDate];
    NSTimeInterval distanceBetweenDates = [[NSDate date] timeIntervalSinceDate:createdDate];
    
    if (distanceBetweenDates<60)
    {
        NSLog(@"Time %f sec",distanceBetweenDates);
        
        NSString *strTime=[NSString stringWithFormat:@"%@ sec",@((int)distanceBetweenDates).stringValue];
        return strTime;
        
    }
    else if (distanceBetweenDates>60 && distanceBetweenDates<60*60)
    {
        NSLog(@"Time %f min",distanceBetweenDates/60);
        NSString *strTime=[NSString stringWithFormat:@"%@ mi",@((int)distanceBetweenDates/60).stringValue];
        return strTime;
        
    }
    
    else if (distanceBetweenDates>60 && distanceBetweenDates<60*60*24)
    {
        NSLog(@"Time %f hr",distanceBetweenDates/(60*60));
        NSString *strTime=[NSString stringWithFormat:@"%@ Hr",@((int)distanceBetweenDates/(60*60)).stringValue];
        
        return strTime;
    }
    else
    {
        [formatter setDateFormat:@"MMM dd"];
        
        NSLog(@"Time %@ ",[formatter stringFromDate:createdDate]);
        return [formatter stringFromDate:createdDate];
    }
    
    return @"";
}






+ (NSString*)base64forData:(NSData*)theData
{
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}






+(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
    return center;
    
}

@end
