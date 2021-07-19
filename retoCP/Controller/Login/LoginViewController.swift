//
//  LoginViewController.swift
//  retoCP
//
//  Created by Renzo Paul Chamorro on 18/07/21.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {
    
    @IBOutlet weak var googleBtn: GIDSignInButton!
    @IBOutlet weak var userAndPassStackView: UIStackView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var loggedView: UIView!
    
    let signInConfig = GIDConfiguration.init(clientID: "883081469756-ihp9vckdkg06254ol31ctp5tu3ioh9c7.apps.googleusercontent.com")
    var shouldShowWelcomePopUp: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setControllerStyle()
        getUserData()
        dissmissKeyboardOnTap()
    }
    
    private func setControllerStyle() {
        self.tabBarItem.image = UIImage(systemName: "person.fill")
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "backgroundB"))
        self.loggedView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "backgroundB"))
        loggedView.isHidden = true
        googleBtn.style = .wide
        self.view.addSubview(googleBtn)
        loginButton.layer.cornerRadius = 10
        googleBtn.layer.cornerRadius = 10
        signUpBtn.layer.cornerRadius = 10
    }
    
    private func getUserData() {
        let userData = User.sharedInstance.recoverUserData()
        if userData.name != "" {
            loggedView.isHidden = false
            self.userNameLabel.text = userData.name
            googleBtn.isHidden = true
        }
    }
    
    private func showWelcomePopUp(userName: String){
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "PopUpLoginSuccesViewController") as! PopUpLoginSuccesViewController
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.userNameString = userName
        popupVC.delegate = self
        self.present(popupVC, animated: true, completion: nil)
    }
    
    @IBAction func googleSignInTapped(_ sender: GIDSignInButton) {
        DispatchQueue.main.async {
            UILoader.instance.showOverlay(view: self.view)
            GIDSignIn.sharedInstance.signIn(with: self.signInConfig, presenting: self) { user, error in
                guard error == nil else {
                    UILoader.instance.finishOverlay()
                    return
                }
                guard let user = user else { return }

                let emailAddress = user.profile?.email ?? ""
                let fullName = user.profile?.name ?? ""
                let givenName = user.profile?.givenName ?? ""
                var avatarUrl = ""
                if user.profile?.hasImage == true {
                    avatarUrl = (user.profile?.imageURL(withDimension: 40)!.absoluteString)!
                }
                
                self.userNameLabel.text = givenName
                self.loggedView.isHidden = false
                self.googleBtn.isHidden = true
                UILoader.instance.finishOverlay()
                User.sharedInstance.saveUserData(model: UserModel(email: emailAddress, name: givenName, fullName: fullName, avatarUrl: avatarUrl))
                self.showWelcomePopUp(userName: givenName)
            }
        }
    }
    @IBAction func signOutTapped(_ sender: Any) {
        User.sharedInstance.deleteUserData()
        self.loggedView.isHidden = true
        self.googleBtn.isHidden = false
        GIDSignIn.sharedInstance.signOut()
    }
    
}

extension LoginViewController: PopUpLoginSuccesDelegate {
    func didTappedContinue() {
        self.tabBarController?.selectedIndex = 1
    }
}
