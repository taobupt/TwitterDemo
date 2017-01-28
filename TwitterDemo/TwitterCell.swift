//
//  TwitterCell.swift
//  TwitterDemo
//
//  Created by Tao Wang on 1/27/17.
//  Copyright © 2017 Tao Wang. All rights reserved.
//

import UIKit

protocol CustomCellUpdater: class{
    func updateTableView()
}

class TwitterCell: UITableViewCell {

    weak var delegate: CustomCellUpdater?
    
    @IBOutlet weak var ContextLabel: UILabel!
    
    @IBOutlet weak var RetweetNumber: UILabel!
    @IBOutlet weak var FavoriateNumber: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var favoriate: UIButton!
    @IBOutlet weak var retweet: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        favoriate.addTarget(self, action: #selector(TwitterCell.changeIndex), for: .touchDown)
        retweet.addTarget(self, action: #selector(TwitterCell.changeRetweet), for: .touchDown)
        
    }

    func changeIndex(){
        
        delegate?.updateTableView()
    }
    
    func changeRetweet(){
        delegate?.updateTableView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //ACTION
    

}
