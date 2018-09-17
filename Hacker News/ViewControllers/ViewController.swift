//
//  ViewController.swift
//  Hacker News
//
//  Created by Admin on 15/09/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController {
    var userDta = [String:AnyObject]()
    @IBOutlet weak var nameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        userDta = UserDefaults.standard.object(forKey: "UserDetails") as! [String : AnyObject]
        UserDefaults.standard.synchronize()
        nameLabel.text = userDta["userName"] as? String
    }

    func fetchingTopStoriesIds(){
        let url =  "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty"
        APIService.fetchingTopStories(url: url) { (response) in
            for i in 0..<response.count {
                  self.fetchingStories(storiesId:String(response[i]))
            }
        }
    }

    func fetchingStories(storiesId:String){
            let url = "https://hacker-news.firebaseio.com/v0/item/"+storiesId+".json?print=pretty"
         print(url)
        APIService.fetchingTopStoriesList(url: url) { (respose) in
            print(respose.count)
        }
    }
    // MARK:SignOut Handling
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
        UserDefaults.standard.removeObject(forKey: "LoggedIn")
        UserDefaults.standard.synchronize()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
        self.present(newViewController, animated: false, completion: nil)
    }
}

