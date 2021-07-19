//
//  PopUpLoginSuccesViewController.swift
//  retoCP
//
//  Created by Renzo Paul Chamorro on 18/07/21.
//

import Foundation
import UIKit

protocol PopUpLoginSuccesDelegate: AnyObject {
  func didTappedContinue()
}

class PopUpLoginSuccesViewController: UIViewController {
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var userNameString: String = ""
    var delegate: PopUpLoginSuccesDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpView.layer.cornerRadius = 20
//        addBlueShadowButton(button: btnClose)
        userNameLabel.text = "\(userNameString)!"
    }
    @IBAction func btnContinueTapped(_ sender: UIButton) {
        delegate?.didTappedContinue()
        self.dismiss(animated: true, completion: nil)
    }
    
}
