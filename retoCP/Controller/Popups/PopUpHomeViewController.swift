//
//  PopUpHomeViewController.swift
//  retoCP
//
//  Created by Renzo Paul Chamorro on 19/07/21.
//

import UIKit

protocol PopUpHomeDelegate: AnyObject {
    func didTappedLogin()
    func didTappedStore()
}

class PopUpHomeViewController: UIViewController {

    @IBOutlet weak var goToLoginButton: UIButton!
    @IBOutlet weak var goToCandyShopButton: UIButton!
    @IBOutlet weak var popUpView: UIView!
    
    var delegate: PopUpHomeDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        goToLoginButton.layer.cornerRadius = 10
        goToCandyShopButton.layer.cornerRadius = 10
        popUpView.layer.cornerRadius = 20

    }
    @IBAction func goToLoginTapped(_ sender: Any) {
        delegate?.didTappedLogin()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goToStoreTapped(_ sender: Any) {
        delegate?.didTappedStore()
        self.dismiss(animated: true, completion: nil)
    }
    
}
