//
//  TweetsViewController.swift
//  TwitterDemo
//
//  Created by Tao Wang on 1/27/17.
//  Copyright © 2017 Tao Wang. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate, CustomCellUpdater {

    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    var tweets: [Tweet]!
    var isMoreDataLoading=false
    var loadingMoreView:InfiniteScrollActivityView?
    var id1: Int64 = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.dataSource=self
        tableView.delegate=self
        
        
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        
        
        tableView.rowHeight=UITableViewAutomaticDimension
        tableView.estimatedRowHeight=120
        
        //add refresh control
        let refreshControl=UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TweetsViewController.refreshControlAction(refreshControl:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        
        
        
        
        
        
        
        
        
        
        TwitterClient.sharedInstance?.homeTimeline(success: {(tweets: [Tweet]) -> () in
            self.tweets=tweets
            self.tableView.reloadData()
        })
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = self.tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "twitterCell", for: indexPath) as! TwitterCell
        cell.ContextLabel.text = tweets[indexPath.row].text
        cell.nameLabel.text=tweets[indexPath.row].user?.name
        cell.timeLabel.text=tweets[indexPath.row].timestamp
        id1 = tweets[indexPath.row].id1
        cell.posterImage.setImageWith((tweets[indexPath.row].user?.profileUrl)!)
        cell.RetweetNumber.text="\(tweets[indexPath.row].retweetCount)"
        cell.FavoriateNumber.text="\(tweets[indexPath.row].favoritesCount)"
        
        print("row \(indexPath.row)")
        return cell
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl){
        TwitterClient.sharedInstance?.homeTimeline(success: {(tweets: [Tweet]) -> () in
            self.tweets=tweets
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        })
    }
    

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(!isMoreDataLoading){
            
            let scrollViewContentHeight=tableView.contentSize.height
            let scrollOffsetThreshold=scrollViewContentHeight-tableView.bounds.height
            if(scrollView.contentOffset.y>scrollOffsetThreshold && tableView.isDragging){
                isMoreDataLoading=true
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                loadMoreData()
            }
        }
    }
    
    
    func loadMoreData(){
        TwitterClient.sharedInstance?.homeTimeline(30,success: {(tweets: [Tweet]) -> () in
            print("30 tweets")
            self.tweets=tweets
            self.tableView.reloadData()
        })
        }
    
    func updateTableView(){
        TwitterClient.sharedInstance?.retweet(self.id1, success: {(tweet: Tweet) -> () in
            TwitterClient.sharedInstance?.homeTimeline(success: {(tweets: [Tweet]) -> () in
            self.tweets=tweets
            self.tableView.reloadData()
            })
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
