//
//  WebApiClient.swift
//  retoCP
//
//  Created by Renzo Paul Chamorro on 18/07/21.
//

import Foundation
import Alamofire

typealias CompletionBlock = (Bool, Dictionary<String,AnyObject>) -> Void
typealias CompletionBlockArray = (Bool, NSMutableArray) -> Void

class WebApiClient {
    static let sharedInstance = WebApiClient()
    var initialUrl = "http://ec2-18-219-76-53.us-east-2.compute.amazonaws.com:8080/cp/v1/"
    
    
    func getUrlWithCompletion(url : String!, params : [String: AnyObject]!, completion : @escaping CompletionBlock) {
            var new_url = url
            new_url = initialUrl.appending(url!)
            let method = HTTPMethod.get
            Alamofire.request(new_url!, method: method, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                if(response.response?.statusCode == 200){
                    if response.result.value != nil {
                        completion(true, response.result.value as! Dictionary)
                    }else{
                        completion(false, Dictionary<String,AnyObject>())
                    }
                }else{
                    completion(false, Dictionary<String,AnyObject>())
                }
            }
        }
    func postUrlWithHeaderComple(url : String!, params : [String: AnyObject]!, completion : @escaping CompletionBlock) {
            var new_url = url
            new_url = initialUrl.appending(url!)
            let method = HTTPMethod.post
            let headers = ["Content-Type": "application/json"]
            Alamofire.request(new_url!, method: method, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                if(response.response?.statusCode == 200){
                    if response.result.value != nil {
                        completion(true, response.result.value as! Dictionary)
                        
                    }else{
                        completion(false, Dictionary<String,AnyObject>())
                    }
                }else{
                    completion(false, Dictionary<String,AnyObject>())
                }
            }
        }
}

