//
//  CandyStoreWS.swift
//  retoCP
//
//  Created by Renzo Paul Chamorro on 18/07/21.
//

import Foundation
import UIKit

class CandyStoreWS{
    
    static let sharedService = CandyStoreWS()
    
    func getItemsData(_ view:UIViewController, successResponse success: @escaping([ItemModel]) -> Void, failureResponse failure: @escaping(_ errorMsg: String) -> Void) -> Void {
        UILoader.instance.showOverlay(view: view.view)
        WebApiClient.sharedInstance.getUrlWithCompletion(url: "candystore", params: nil) { finished, result in
            UILoader.instance.finishOverlay()
            if finished {
                print("CandyStoreWS: \(result)")
                var items: [ItemModel] = []
                let responseData = result["items"] as! [[String:Any]]
                for n in responseData {
                    let url = n["name"] as! String
                    let price = n["price"] as! String
                    let image = self.transformar(urlString: url)
                    let newItem = ItemModel(description: n["description"] as! String,
                                           imageUrl: url,
                                           image: image,
                                           price: price)
                    items.append(newItem)
                }
                success(items)
            }
            else {
                failure("Error al consumir servicio CandyStore")
            }
        }
    }
    
    private func transformar(urlString: String) -> UIImage {
        let url = URL(string: urlString)
        if let data = try? Data(contentsOf: url!){
            return UIImage(data: data)!.scaleImage(toSize: CGSize(width: 120, height: 120))!
        } else {
            return UIImage(systemName: "questionmark")!

        }
    }

}

public struct ItemModel {
    let description: String
    let imageUrl: String
    let image: UIImage
    let price: String
}
