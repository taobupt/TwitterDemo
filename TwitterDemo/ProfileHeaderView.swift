//
//  ProfileHeaderView.swift
//  TwitterDemo
//
//  Created by Tao Wang on 2/15/17.
//  Copyright © 2017 Tao Wang. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        
        
        profilePicView.clipsToBounds = true
        profilePicView.layer.cornerRadius = 4
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ProfileHeaderView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    
}

