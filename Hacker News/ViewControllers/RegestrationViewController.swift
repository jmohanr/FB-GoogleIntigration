//
//  RegestrationViewController.swift
//  Hacker News
//
//  Created by Admin on 15/09/2018.
//  Copyright © 2018 Admin. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth

class RegestrationViewController: UIViewController {
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var mailIdText: UITextField!
    @IBOutlet weak var userNameText: UITextField!
    var userData = [String:AnyObject]()
     @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.layer.cornerRadius = 10.0
        NotificationCenter.default.addObserver(self, selector: #selector(RegestrationViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegestrationViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK:Firebase Regestration
@IBAction func logInAction(_ sender: Any) {
    if mailIdText.text == "" || passwordText.text == "" || userNameText.text == "" {
    self.presentingAlert(title: "Error", message:"Please enter emailId and Password")
      }
    else {
        if  (mailIdText.text?.isValidEmail(testStr: mailIdText.text!))! {
            userData["userName"] = userNameText.text as AnyObject
            userData["emailID"] = mailIdText.text as AnyObject
            UserDefaults.standard.set(userData, forKey: "UserDetails")
            UserDefaults.standard.synchronize()
    Auth.auth().createUser(withEmail: mailIdText.text!, password: passwordText.text!) { (user, error) in
               if error == nil {
                   let vc = self.storyboard?.instantiateViewController(withIdentifier: "FireBaseLogInViewController")
                            self.present(vc!, animated: true, completion: nil)
                        }
               else {
            self.presentingAlert(title: "Error", message:(error?.localizedDescription)!)
            }
                }
                }else {
            presentingAlert(title: "Error", message:"EmailId is Not Valid" )
            }
        }
     }
}

// MARK:HandlingKeyboardHeights
extension RegestrationViewController{
    @objc func keyboardWillShow(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 50
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += 50
            }
        }
    }
    func presentingAlert(title:String,message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
// MARK: TextFieldDelegateMethods
extension RegestrationViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(RegestrationViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
