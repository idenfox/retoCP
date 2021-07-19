//
//  PremieresWS.swift
//  retoCP
//
//  Created by Renzo Paul Chamorro on 18/07/21.
//

import Foundation
import UIKit

class PremieresWS{
    
    static let sharedService = PremieresWS()
    
    func getMoviesData(_ view:UIViewController, successResponse success: @escaping([MovieModel]) -> Void, failureResponse failure: @escaping(_ errorMsg: String) -> Void) -> Void {
        UILoader.instance.showOverlay(view: view.view)
        WebApiClient.sharedInstance.getUrlWithCompletion(url: "premieres", params: nil) { finished, result in
            UILoader.instance.finishOverlay()
            if finished {
                print("PREMIERESWS: \(result)")
                var models: [MovieModel] = []
                let responseData = result["premieres"] as! [[String:Any]]
                for n in responseData {
                    let url = n["image"] as! String
                    let image = self.transformar(urlString: url)
                    let movie = MovieModel(description: n["description"] as! String,
                                           imageUrl: url,
                                           image: image)
                    models.append(movie)
                }
                success(models)
            }
            else {
                failure("Error al consumir servicio Premiere")
            }
        }
    }
    
    private func transformar(urlString: String) -> UIImage {
        let url = URL(string: urlString)
        if let data = try? Data(contentsOf: url!){
            return UIImage(data: data)!
        } else {
            return UIImage(systemName: "questionmark")!

        }
    }

}

public struct MovieModel {
    let description: String
    let imageUrl: String
    let image: UIImage
}
