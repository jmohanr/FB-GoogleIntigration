//
//  HackerNewsAPI.swift
//  Hacker News
//
//  Created by Admin on 15/09/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit

class APIService: NSObject {
    
    /// CALLING THE Get METHOD API
    static func fetchingTopStories(url:String,completion: @escaping ([Int])->() ) {
        guard let url = URL(string: url) else { return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { return  }
            guard let data = data else { return}
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [Int] {
                    
                    DispatchQueue.main.async {
                        completion(json )
                    }
                }
            }
            catch let error as NSError {
                print("json error: \(error.localizedDescription)")
            }
            }.resume()
    }
    
    /// CALLING THE POST METHOD API
    
    static func callThePostApi(url:String,params: [Int],completion: @escaping ([String: AnyObject])->() ) {
        guard let url = URL(string: url) else { return}
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.setValue("token", forHTTPHeaderField: "QpwL5tke4Pnpja7X")
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        request.httpBody = jsonData
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { return  }
            guard let data = data else { return}
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    
                    DispatchQueue.main.async {
                        completion(json)
                    }
                }
            }
            catch let error as NSError {
                print("json error: \(error.localizedDescription)")
            }
            }.resume()
    }
    static func fetchingTopStoriesList(url:String,completion: @escaping ([String:AnyObject])->() ) {
        guard let url = URL(string: url) else { return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { return  }
            guard let data = data else { return}
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String:AnyObject] {
                    
                    DispatchQueue.main.async {
                        completion(json )
                    }
                }
            }
            catch let error as NSError {
                print("json error: \(error.localizedDescription)")
            }
            }.resume()
    }
    
}
