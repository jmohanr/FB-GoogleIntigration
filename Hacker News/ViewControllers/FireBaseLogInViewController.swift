//
//  LogInViewController.swift
//  Hacker News
//
//  Created by Admin on 15/09/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class FireBaseLogInViewController: UIViewController {
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var userText: UITextField!
     @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 10.0

        NotificationCenter.default.addObserver(self, selector: #selector(FireBaseLogInViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FireBaseLogInViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK:FireBaseLogIn
    @IBAction func logInAction(_ sender: Any) {
        if self.userText.text == "" || self.passwordText.text == "" {
           self.presentingAlert(title: "Error", message:"Please enter emailId and Password")
        } else {
            Auth.auth().signIn(withEmail: self.userText.text!, password: self.passwordText.text!) { (user, error) in
                if error == nil {
                    let appDelegate = UIApplication.shared.delegate! as! AppDelegate
                    let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "ViewController")
                    appDelegate.window?.rootViewController = initialViewController
                    UserDefaults.standard.set("true", forKey: "LoggedIn")
                    UserDefaults.standard.synchronize()
                    appDelegate.window?.makeKeyAndVisible()
                    
                } else {
               self.presentingAlert(title: "Error", message:(error?.localizedDescription)!)
                }
            }
        }
    }
    
    @IBAction func regestrationAction(_ sender: Any) {
        self.performSegue(withIdentifier: "regester", sender: nil)
    }

}
// MARK:Handling TextFields Height
extension FireBaseLogInViewController {
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
// MARK:TextFieldDelegates
extension FireBaseLogInViewController:UITextFieldDelegate {
    
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
            action: #selector(FireBaseLogInViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
