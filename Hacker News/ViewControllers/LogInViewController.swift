//
//  LogInViewController.swift
//  Hacker News
//
//  Created by Admin on 15/09/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit

class LogInViewController: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate,FBSDKLoginButtonDelegate {
    
    var userData = [String:AnyObject]()
     @IBOutlet weak var fbLoginButton: UIButton!
     @IBOutlet weak var googleLoginButton: UIButton!
     @IBOutlet weak var emailLoginButton: UIButton!
    let parameters = ["fields": "email,picture.type(large),public_profile"]
 
    override func viewDidLoad() {
        super.viewDidLoad()
        fbLoginButton.addTarget(self, action: #selector(fbSignInPressed), for: UIControlEvents.touchUpInside)
        googleLoginButton.addTarget(self, action: #selector(googleSignInPressed), for: UIControlEvents.touchUpInside)
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        fbLoginButton.layer.cornerRadius = 10.0
        googleLoginButton.layer.cornerRadius = 10.0
        emailLoginButton.layer.cornerRadius = 10.0
    }
    
   // MARK: Google sign Methods
    func toggleAuthUI() {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {}
    }
    
    
   @objc func googleSignInPressed() {
    GIDSignIn.sharedInstance().signIn()
    toggleAuthUI()
    }
    
    // MARK:GIDSignInUIDelegates
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) { }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK:GIDSignInDelegates
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            UserDefaults.standard.set("true", forKey: "LoggedIn")
            UserDefaults.standard.synchronize()
            userData["userName"] = user.profile.givenName as AnyObject
             userData["emailID"] = user.profile.email as AnyObject
            UserDefaults.standard.set(userData, forKey: "UserDetails")
            UserDefaults.standard.synchronize()
            print(user)
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.present(newViewController, animated: false, completion: nil)
        }
    }

    // MARK:FacebookSignInMethods
    
    func fetchProfile() {
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start{ (connection,result,error)-> Void in
            if error != nil {
                print(error!)
                return
            }
            let dictionary = result as! [String: AnyObject]
            print(dictionary)
        }
    }
    
    @objc func fbSignInPressed() {
        let currentVc = LogInViewController()
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["email","public_profile"], from: currentVc, handler: { (loginResults: FBSDKLoginManagerLoginResult?, error: Error?) -> Void in
            if !(loginResults?.isCancelled)! {
                self.fetchProfile()
            } else {
                let err = NSError()
                print(err)
            }
        })
        
    }
    // MARK:FBSDKLoginButtonDelegates
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
        } else {
            fetchProfile()
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.present(newViewController, animated: false, completion: nil)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    
}
