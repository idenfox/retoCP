//
//  PagoViewController.swift
//  retoCP
//
//  Created by Renzo Paul Chamorro on 19/07/21.
//

import UIKit

class PagoViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var dniCheckBox: UIButton!
    @IBOutlet weak var passportCheckBox: UIButton!
    @IBOutlet weak var docNumberTextField: UITextField!
    @IBOutlet weak var numCardTextField: UITextField!
    @IBOutlet weak var yearCardTextField: UITextField!
    @IBOutlet weak var monthCardTextField: UITextField!
    @IBOutlet weak var cvvCardTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    var dniSelected: Bool = false
    var passportSelected: Bool = false
    var totalMount: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setControllerStyle()
        dissmissKeyboardOnTap()
        acceptDelegates()
        continueButton.setTitle("Pagar S/.\(totalMount)", for: .normal)
    }
    
    private func acceptDelegates() {
        docNumberTextField.delegate = self
        numCardTextField.delegate = self
        yearCardTextField.delegate = self
        monthCardTextField.delegate = self
        cvvCardTextField.delegate = self
    }
    
    private func areValidTextFields() -> Bool {
        if nameTextField.text?.isReallyEmpty == true ||
            emailTextField.text?.isReallyEmpty == true ||
            docNumberTextField.text?.isReallyEmpty == true ||
            numCardTextField.text?.isReallyEmpty == true ||
            yearCardTextField.text?.isReallyEmpty == true ||
            monthCardTextField.text?.isReallyEmpty == true ||
            cvvCardTextField.text?.isReallyEmpty == true {
            return false
        }
        else {
            return true
        }
    }
    
    private func setControllerStyle() {
        self.tabBarItem.image = UIImage(systemName: "star.fill")
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "backgroundB"))
        continueButton.layer.cornerRadius = 10
        let userData = User.sharedInstance.recoverUserData()
        nameTextField.text = userData.fullName
        emailTextField.text = userData.email
    }
    @IBAction func dniTapped(_ sender: Any) {
        dniSelected.toggle()
        if dniSelected {
            passportSelected = false
            dniCheckBox.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            passportCheckBox.setImage(UIImage(systemName: "circle"), for: .normal)
        } else {
            dniCheckBox.setImage(UIImage(systemName: "circle"), for: .normal)

        }
        
    }
    @IBAction func passportTapped(_ sender: Any) {
        passportSelected.toggle()
        if passportSelected {
            dniSelected = false
            dniCheckBox.setImage(UIImage(systemName: "circle"), for: .normal)
            passportCheckBox.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        } else {
            passportCheckBox.setImage(UIImage(systemName: "circle"), for: .normal)

        }
    }
    @IBAction func continueTapped(_ sender: Any) {
        if !areValidTextFields() {
            showAlertView(message: "Todos los campos son necesarios")
        } else {
            let paymentInput = buildPaymentInput()
            PagosWS.sharedService.makePaymentRequest(self, model: paymentInput) { result in
                print("RENZOPR: \(result)")
                if result.result == "SUCCESS" {
                    let alertView = UIAlertController(title: "Success!", message: "Pago Exitoso, tu orden de compra es: \(result.operationCode)", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                        if let navController = self.navigationController {
                            navController.popViewController(animated: true)
                        }
                    }
                    alertView.addAction(OKAction)
                    self.present(alertView, animated: true, completion: nil)
                }
            } failureResponse: { error in
                print(error)
            }

        }
    }
    
    private func showAlertView(message: String) {
        let alert = UIAlertController(title: "Alerta", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func buildPaymentInput() -> PaymentInputModel {
        
        return PaymentInputModel(name: nameTextField.text!, mail: emailTextField.text!, docNumber: docNumberTextField.text!, cardNumber: numCardTextField.text!, cardYear: yearCardTextField.text!, cardMonth: monthCardTextField.text!, cvv: cvvCardTextField.text!, mount: totalMount)
    }
}

extension PagoViewController: UITextFieldDelegate{
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if(textField != nameTextField || textField != emailTextField){
//            let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
//            return string.rangeOfCharacter(from: invalidCharacters) == nil
//        }
//        return true
//    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == docNumberTextField {
            let maxLength = 8
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        if textField == yearCardTextField {
            let maxLength = 4
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        if textField == monthCardTextField {
            let maxLength = 2
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        if textField == cvvCardTextField {
            let maxLength = 3
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        return string.rangeOfCharacter(from: invalidCharacters) == nil
    }
    
}
