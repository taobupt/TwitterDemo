//
//  TwitterClient.swift
//  TwitterDemo
//
//  Created by Tao Wang on 1/27/17.
//  Copyright © 2017 Tao Wang. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
   static let sharedInstance = TwitterClient(baseURL: URL(string:"https://api.twitter.com")!, consumerKey: "Zd42tTQCANzJvPNk2QbEWo8h6", consumerSecret: "eMNWaXNjVsyjG09Odj52FsHbUKEI4qhElFAwypqwKHQT9CzPev")
    
    var loginSuccess: (() -> ())?

    
    func handleOpenUrl(url: URL){
        let requestToken=BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?)->Void in
            print("I got the access token")
            
            self.currentAccount(success: {(user: User) -> () in
                User.currentUser=user
                self.loginSuccess?()
            })
            
            
        }){ (error: Error?)-> Void in
            print("error")
        }

    }
    
    
    
    
    
    func homeTimeline(success: @escaping ([Tweet]) -> ()){
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            
            
            let dictionaries=response as! [NSDictionary]
            
            let tweets=Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
            //            for tweet in tweets{
            //                print("\(tweet.text)")
            //            }
            
        },failure: {(task: URLSessionDataTask?, error: Error) -> Void in
            print(error)
        })
        
    }

    
    
    func homeTimeline(_ countNumber: Int,success: @escaping ([Tweet]) -> ()){
        //?screen_name=twitterapi&count=2
        //statuses/user_timeline.json?screen_name=twitterapi&count=2
        print("1.1/statuses/home_timeline.json?screen_name=taobupt&count=\(countNumber)")
        get("https://api.twitter.com/1.1/statuses/home_timeline.json?count=\(countNumber)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            
            
            let dictionaries=response as! [NSDictionary]
            
            let tweets=Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
            print(dictionaries)
            
        },failure: {(task: URLSessionDataTask?, error: Error) -> Void in
            print(error)
        })

    }
    
    
    
    
    
    func currentAccount(success: @escaping (User) -> ()){
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            
            let userDictionary=response as? NSDictionary
            print(userDictionary)
            let user = User(dictionary: userDictionary!)
            success(user)
        })
    }
    
    func longin(success: @escaping () -> ()){
        
        loginSuccess=success
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?)->Void in
            print("I got a token")
            var token: String = (requestToken?.token!)!
            print(token)
            let url=URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")!
            print(url)
            UIApplication.shared.open(url)
        }){ (error: Error?)-> Void in
            print("error")
        }

    }
    
    func logout(){
        User.currentUser=nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLogout"), object: nil)
    }
    
    
    //https://api.twitter.com/1.1/statuses/retweet/243149503589400576.json
    func retweet(_ id1: Int64,success: @escaping (Tweet) -> ()){
        post("1.1/statuses/retweet/\(id1).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let userDictionary=response as? NSDictionary
            let user = Tweet(dictionray: userDictionary!)
            success(user)
        })
    }

}
