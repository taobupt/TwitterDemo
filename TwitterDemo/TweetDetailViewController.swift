//
//  TweetDetailViewController.swift
//  TwitterDemo
//
//  Created by Tao Wang on 2/10/17.
//  Copyright © 2017 Tao Wang. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    var tweet: Tweet!
    var rowIndex: Int?
    @IBOutlet weak var ProfileImage: UIImageView!
    
    @IBOutlet weak var FavoriteNumber: UILabel!
    @IBOutlet weak var RetweetNumber: UILabel!
    @IBOutlet weak var Context: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Tweet"
        
        
        ProfileImage.setImageWith((tweet.user?.profileUrl)!)
        FavoriteNumber.text = String(tweet.favoritesCount)
        RetweetNumber.text = String(tweet.retweetCount)
        Context.text = tweet.text
        timeLabel.text = tweet.timestamp
        nameLabel.text = tweet.user?.name
        screenName.text = "@"+(tweet.user?.screenname)!
        
        let userProfileTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(sender:)))
        userProfileTap.numberOfTapsRequired=2
        ProfileImage.isUserInteractionEnabled=true
        ProfileImage.addGestureRecognizer(userProfileTap)
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    @IBAction func OnReply(_ sender: Any) {
        
    }
    
    
    @IBAction func OnRetweet(_ sender: Any) {
        TwitterClient.sharedInstance?.retweet(self.tweet.id1,success: {(tweet: Tweet) -> () in
            self.tweet=tweet
            TweetsViewController.tweets[self.rowIndex!] = self.tweet
            self.RetweetNumber.text=String(tweet.retweetCount)
        })
    }
    
    
    @IBAction func OnFavorite(_ sender: Any) {
        TwitterClient.sharedInstance?.favorite(self.tweet.id1,success: {(tweet: Tweet) -> () in
            self.tweet=tweet
            TweetsViewController.tweets[self.rowIndex!] = self.tweet
            self.FavoriteNumber.text=String(tweet.favoritesCount)
        })
    }

    
    func imageTapped(sender: UITapGestureRecognizer){
        
        let screenName = tweet.user!.screenname
        
        
        TwitterClient.sharedInstance?.userProfile(screenName: screenName, completion: { (user, error) -> () in
            self.performSegue(withIdentifier: "ProfileSegue", sender: user)
        })
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ProfileSegue" {
            
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.user = sender as? User
        }
    }
    

}
