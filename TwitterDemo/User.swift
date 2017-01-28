//
//  User.swift
//  TwitterDemo
//
//  Created by Tao Wang on 1/27/17.
//  Copyright © 2017 Tao Wang. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileUrl: URL?
    var tagline: String?
    
    static var _currentUser: User?
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary=dictionary
        name=dictionary["name"] as? String
        screenname=dictionary["screen_name"] as? String
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString=profileUrlString{
            profileUrl=URL(string: profileUrlString)
        }
        tagline=dictionary["description"] as? String
        
        
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
                if let userData = userData {
                    do {
                        let dictionray = try JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                        _currentUser=User(dictionary: dictionray)
                    } catch  {
                         print("error")
                    }
                    
                }
            }
            return _currentUser
            
        }
        
        set(user){
            _currentUser = user
            let defaults = UserDefaults.standard
            if let user = user {
                do {
                    let data = try JSONSerialization.data(withJSONObject: user.dictionary!, options: .prettyPrinted)
                    defaults.set(data, forKey: "currentUserData")
                } catch  {
                    print("error")
                }
            } else {
                defaults.set(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }

}
