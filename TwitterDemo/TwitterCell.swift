//
//  TwitterCell.swift
//  TwitterDemo
//
//  Created by Tao Wang on 1/27/17.
//  Copyright © 2017 Tao Wang. All rights reserved.
//

import UIKit


class TwitterCell: UITableViewCell {

    var tweet: Tweet!
    var rowIndex: Int?
    
    @IBOutlet weak var tweetCotextLabel: UILabel!
    @IBOutlet weak var tweetNameLabel: UILabel!
    @IBOutlet weak var TweetProfileImage: UIImageView!
    @IBOutlet weak var ContextLabel: UILabel!
    
    @IBOutlet weak var RetweetNumber: UILabel!
    @IBOutlet weak var FavoriateNumber: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    @IBOutlet weak var RetweetButton: UIButton!
    
    
    @IBOutlet weak var FavoriteButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if FavoriteButton != nil{
        FavoriteButton.addTarget(self, action: #selector(TwitterCell.changeIndex), for: .touchDown)
        RetweetButton.addTarget(self, action: #selector(TwitterCell.changeRetweet), for: .touchDown)
        }
        
    }

    func changeIndex(){
        
            TwitterClient.sharedInstance?.favorite(self.tweet.id1,success: {(tweet: Tweet) -> () in
            self.tweet=tweet
            TweetsViewController.tweets[self.rowIndex!] = self.tweet
            self.FavoriateNumber.text=String(tweet.favoritesCount)
        })
        
        
    }
    
    func changeRetweet(){
//        var retweetToggleOption: TwitterClient.RetweetToggleOption
//        if self.tweet.retweeted!{
//            retweetToggleOption = .destory
//        }else{
//            retweetToggleOption = .create
//        }
        TwitterClient.sharedInstance?.retweet(self.tweet.id1,success: {(tweet: Tweet) -> () in
            self.tweet=tweet
            TweetsViewController.tweets[self.rowIndex!] = self.tweet
            self.RetweetNumber.text=String(tweet.retweetCount)
        })
        //        TwitterClient.toggleRetweet(tweet: self.tweet, option: retweetToggleOption) { (tweet, error) in
//            if tweet != nil{
//                self.tweet = tweet
//                self.RetweetNumber.text = String(tweet!.retweetCount)
//            }
//        }
    }
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //ACTION
    

}
