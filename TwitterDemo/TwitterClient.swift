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
    
    enum FavoToggleOption{
        case create
        case destory
    }
    
    enum RetweetToggleOption{
        case create
        case destory
    }
    
    static let createFavorTweetEndPoint = "/1.1/favorites/create.json?id="
    static let destroyFavorTweetEndPoint = "/1.1/favorites/destroy.json?id="
    static let retweetCreateEndPoint = "/1.1/statuses/retweet/" //append .json extension after append the tweet id
    static let retweetDestroyEndPoint = "/1.1/statuses/unretweet/"
    static let sendTweetEndPoint = "https://api.twitter.com/1.1/statuses/update.json?status="
    
    
    
    
    
    
    
    
    
    
    
    
    
   static let sharedInstance = TwitterClient(baseURL: URL(string:"https://api.twitter.com")!, consumerKey: "yFbCd3yIcAm6YehN28LC1G8tR", consumerSecret: "PCCBPs7YjU6rdSKJAs1MOf1V8iozuahV6eGK9Sqsj2KjjEzWVW")
    
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
            let tweet = Tweet(dictionray: userDictionary!)
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            
        })
    }
    
    //POST https://api.twitter.com/1.1/favorites/create.json?id=243138128959913986
    func favorite(_ id1: Int64,success: @escaping (Tweet) -> ()){
        post("1.1/favorites/create.json?id=\(id1)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let userDictionary=response as? NSDictionary
            let tweet = Tweet(dictionray: userDictionary!)
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            
        })
    }
    
    
    
    func sendTweet(text: String, callBack: @escaping (_ response: Tweet?, _ error: Error? ) -> Void){
        guard let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else{
            callBack(nil, nil)
            return
        }
        let urlString = TwitterClient.sendTweetEndPoint + encodedText
        let _ = TwitterClient.sharedInstance?.post(urlString, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response:Any?) in
            if let tweetDict = response as? NSDictionary{
                let tweet = Tweet(dictionray: tweetDict)
                callBack(tweet, nil)
            }else{
                callBack(nil, nil)
            }
        }, failure: { (task: URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            callBack(nil, error)
        })
    }
    
    class func toggleFavorTweet(tweet: Tweet, option: FavoToggleOption, callBack:@escaping(_ response:Tweet?, _ error: Error?) -> Void){
        var favoEndPoint: String
        if option == .create{
            favoEndPoint = TwitterClient.createFavorTweetEndPoint+String(tweet.id1);
        }else{
            favoEndPoint = TwitterClient.destroyFavorTweetEndPoint+String(tweet.id1);
        }
        
        let _ = TwitterClient.sharedInstance?.post(favoEndPoint, parameters: nil, progress: nil, success: {(task: URLSessionTask , response: Any?) -> Void in
        
            if let tweetDict = response as? NSDictionary{
                let tweet = Tweet(dictionray: tweetDict)
                callBack(tweet,nil)
            }else{
                callBack(nil,nil)
            }
            
        
        }, failure: {(task: URLSessionTask?, error: Error) -> Void in
            print(error.localizedDescription)
            callBack(nil,error)
        })
    }
    
    class func toggleRetweet(tweet: Tweet, option: RetweetToggleOption,  callBack: @escaping (_ response: Tweet?, _ error: Error? ) -> Void){
        var retweetEndPoint: String
        if option == .create{
            retweetEndPoint = TwitterClient.retweetCreateEndPoint + String(tweet.id1)
        }else{
            retweetEndPoint = TwitterClient.retweetDestroyEndPoint + String(tweet.id1)
        }
        retweetEndPoint = retweetEndPoint + ".json"
        let _ = TwitterClient.sharedInstance?.post(retweetEndPoint, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response:Any?) in
            if let tweetDict = response as? NSDictionary{
                var tweet: Tweet?
                if option == .create{
                    if let originalTweetDict = tweetDict["retweeted_status"] as? NSDictionary{
                        tweet = Tweet(dictionray: originalTweetDict)
                    }
                }else{
                    tweet = Tweet(dictionray: tweetDict)
                }
                callBack(tweet, nil)
            }else{
                callBack(nil, nil)
            }
            
        }, failure: { (task: URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            callBack(nil, error)
        })
    }
    
    func userProfile(screenName: String!, completion: @escaping (_ user: User?, _ error: Error?) -> ()) {
        //print(String(screenName.characters).lowercased())
        self.get("1.1/users/show.json?screen_name="+String(screenName.characters).lowercased(), parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let userDictionary=response as? NSDictionary
            let user = User(dictionary: userDictionary!)
            completion(user,nil)
        }, failure: { (task: URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            
        })
        
    }
    
    
    

}
