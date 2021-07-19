//
//  PagosWS.swift
//  retoCP
//
//  Created by Renzo Paul Chamorro on 19/07/21.
//
import Foundation
import UIKit
import Alamofire


class PagosWS{
    
    static let sharedService = PagosWS()
    
    let urlPayuString = "https://sandbox.api.payulatam.com/payments-api/4.0/service.cgi"
    
    func makePaymentRequest(_ view:UIViewController, model: PaymentInputModel, successResponse success: @escaping(PaymentOutput) -> Void, failureResponse failure: @escaping(_ errorMsg: String) -> Void) -> Void {
        UILoader.instance.showOverlay(view: view.view)
        
        let params = construirParametros(model: model) as [String: AnyObject]
        postUrlWithHeaderComple(url: urlPayuString, params: params, completion:{ (finished, result) -> Void in
            UILoader.instance.finishOverlay()
            if finished {
                print("PayuWS: \(result)")
                let responseResult = result["code"] as! String
                guard let transactionData = result["transactionResponse"] as? [String:Any] else {return}
                let operationCode = transactionData["operationDate"] as! Int
                success(PaymentOutput(result: responseResult, operationCode: operationCode))
            }else{
                failure("Error al consumir Api Payu")
            }
        })
    }
    
    private func construirParametros(model: PaymentInputModel) -> [String:Any] {
        
        return [
           "language": "es",
           "command": "SUBMIT_TRANSACTION",
           "merchant": [
              "apiKey": "4Vj8eK4rloUd272L48hsrarnUA",
              "apiLogin": "pRRXKOl8ikMmt9u"
           ],
           "transaction": [
              "order": [
                 "accountId": "512323",
                 "referenceCode": "payment_test_00000001",
                 "description": "payment test",
                 "language": "es",
                 "signature": "cfddea273ca17d7e2ce3eed8e939f5a2",
                 "notifyUrl": "http://www.tes.com/confirmation",
                 "additionalValues": [
                    "TX_VALUE": [
                       "value": 100,
                       "currency": "PEN"
                    ]
                 ],
                 "buyer": [
                    "merchantBuyerId": "1",
                    "fullName": "First name and second buyer  name",
                    "emailAddress": "buyer_test@test.com",
                    "contactPhone": "7563126",
                    "dniNumber": "5415668464654",
                    "shippingAddress": [
                       "street1": "Avenida de la poesia",
                       "street2": "106",
                       "city": "Cuzco",
                       "state": "CU",
                       "country": "PE",
                       "postalCode": "000000",
                       "phone": "7563126"
                    ]
                 ],
                 "shippingAddress": [
                    "street1": "Avenida de la poesia",
                    "street2": "106",
                    "city": "Cuzco",
                    "state": "CU",
                    "country": "PE",
                    "postalCode": "0000000",
                    "phone": "7563126"
                 ]
              ],
              "payer": [
                 "merchantPayerId": "1",
                 "fullName": "First name and second payer name",
                 "emailAddress": "payer_test@test.com",
                 "contactPhone": "7563126",
                 "dniNumber": "5415668464654",
                 "billingAddress": [
                    "street1": "av abancay",
                    "street2": "cra 4",
                    "city": "Iquitos",
                    "state": "LO",
                    "country": "PE",
                    "postalCode": "64000",
                    "phone": "7563126"
                 ]
              ],
              "creditCard": [
                 "number": "4444333322221111",
                 "securityCode": "123",
                 "expirationDate": "2029/12",
                 "name": "Renzo chamorro"
              ],
              "extraParameters": [
                 "INSTALLMENTS_NUMBER": 1
              ],
              "type": "AUTHORIZATION",
              "paymentMethod": "VISA",
              "paymentCountry": "PE",
              "deviceSessionId": "vghs6tvkcle931686k1900o6e1",
              "ipAddress": "127.0.0.1",
              "cookie": "pt1t38347bs6jc9ruv2ecpv7o2",
              "userAgent": "Mozilla/5.0 (Windows NT 5.1; rv:18.0) Gecko/20100101 Firefox/18.0"
           ],
           "test": false
        ]
    
    }
    
    private func postUrlWithHeaderComple(url : String!, params : [String: AnyObject]!, completion : @escaping CompletionBlock) {
            let new_url = url
            let method = HTTPMethod.post
            let headers = ["Content-Type": "application/json",
                           "Accept": "application/json"]
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

public struct PaymentOutput {
    let result: String
    let operationCode: Int
}
