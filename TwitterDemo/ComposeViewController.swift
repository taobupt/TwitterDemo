//
//  ComposeViewController.swift
//  TwitterDemo
//
//  Created by Tao Wang on 2/13/17.
//  Copyright © 2017 Tao Wang. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate{

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var contentText: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    
    let limitLength=140
    var profileurl : URL?
    var name : String?
    var replyUser = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.setImageWith(profileurl!)
        countLabel.text = String(self.limitLength)
        nameLabel.text = name
        
        contentText.delegate=self
        if(replyUser.isEmpty){
            contentText.text = "What's happening?"
            contentText.textColor = UIColor.lightGray
            let newPosition = contentText.beginningOfDocument
            contentText.selectedTextRange = contentText.textRange(from: newPosition, to: newPosition)
        }
        else{
            contentText.text=replyUser+" "
            contentText.textColor = UIColor.lightGray
        }
        
        contentText.becomeFirstResponder()
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText:NSString = textView.text as NSString
        let updatedText = currentText.replacingCharacters(in: range, with:text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            textView.text = "What's happening?"
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from:textView.beginningOfDocument, to: textView.beginningOfDocument)
            
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
        return textView.text.characters.count + (text.characters.count - range.length) <= limitLength
    }
    func textViewDidChange(_ textView: UITextView) {
        let wordCount = contentText.text.characters.count
        countLabel.text = String(self.limitLength-wordCount)
    }

    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                let newPosition = contentText.beginningOfDocument
                contentText.selectedTextRange = contentText.textRange(from: newPosition, to: newPosition)
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let tweets = segue.destination as? TweetsViewController {
            if let text = self.contentText.text{
                TwitterClient.sharedInstance?.sendTweet(text: text, callBack: { (tweet, error) in
                    DispatchQueue.main.async {
                        self.view.endEditing(true)
                        print(tweet?.text)
                    }
                })
            }
            tweets.refreshControlAction(refreshControl: UIRefreshControl())
        }
    }
    

}
