import UIKit
import Alamofire

class WebAPI: NSObject {
    static let baseUrl = "http://piproomz.com/strip/"
    static func SendToken(_ token:String,
                          amount:String,
                          description:String,
                          _ successHandler: @escaping (_ result: [String: AnyObject]) -> Void,
                          _ failureHandler: @escaping (_ error: Error) -> Void) {
        
        let apiUrl : String = baseUrl + "charge.php"
        let params : Parameters = ["stripeToken": token, "amount":amount , "description":description]
        print(params)
        Alamofire.request(apiUrl, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
            .responseJSON { response in
                
                guard response.result.isSuccess,
                    let value = response.result.value as? [String: AnyObject] else {
                        failureHandler(response.result.error!)
                        return
                }
                successHandler(value)
        }
    }
    
}

