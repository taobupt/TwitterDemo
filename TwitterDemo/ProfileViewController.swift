//
//  ProfileViewController.swift
//  TwitterDemo
//
//  Created by Tao Wang on 2/15/17.
//  Copyright © 2017 Tao Wang. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var user: User?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backGround: UIImageView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var Followercnt: UILabel!
    @IBOutlet weak var Followcnt: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        print(user?.dictionary)
        backGround.setImageWith((user?.profileEnlargedUrl)!)
        profileImage.setImageWith((user?.profileUrl)!)
        print(user?.followerCnt!)
        print(user?.friendCnt!)
        let a = user?.friendCnt! ?? 0
        let b = user?.followerCnt! ?? 0
        Followcnt.text = "\(b)"
        Followercnt.text = "\(a)"
        nameLabel.text = user?.name
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func DismissButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "twitterCell", for: indexPath) as! TwitterCell
        cell.TweetProfileImage.setImageWith((user?.profileUrl)!)
        cell.tweetNameLabel.text = user?.name
        let dic = user?.dictionary?["status"] as! NSDictionary
        cell.tweetCotextLabel.text = dic["text"] as! String
        return cell
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
