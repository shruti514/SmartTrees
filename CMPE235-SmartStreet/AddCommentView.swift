//
//  AddCommentView.swift
//  CMPE235-SmartStreet
//
//  Created by Shrutee Gangras on 3/27/16.
//  Copyright © 2016 Shrutee Gangras. All rights reserved.
//
import Cosmos
import Firebase
class AddCommentView: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    var rvc : SWRevealViewController!
   
    
    @IBAction func openSlideMenu(sender: AnyObject) {
        //rvc.pushFrontViewController(slideViewController, animated: true)
        rvc.revealToggle(self)
    }

    var avatarUrl:PFFile!

    @IBOutlet weak var postComment: UIButton!
    @IBOutlet weak var commentText: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cosmosViewPrecise: CosmosView!
    
    @IBAction func postCommentAction(sender: AnyObject) {
        let name = self.nameLabel.text
        let commentDate = self.dateLabel.text
        _ = self.avatarUrl
        let commentText = self.commentText.text
        let starRatings = self.cosmosViewPrecise.rating
        
        let starRatingsStr:String = String(format:"%.2f", starRatings)
        
        let comment = PFObject(className:"Comments")
        comment["username"] = name
        comment["commentDate"] = commentDate
        comment["commentText"] = commentText
        comment["starRatings"] = starRatingsStr
        comment["avatarUrl"] = self.avatarUrl
        comment.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("Comment Saved to database")
            } else {
                print("There was an error saving a comment.")
            }
        }
        
        let commentsViewController = storyboard?.instantiateViewControllerWithIdentifier("CommentsViewController") as! CommentsViewController
        commentsViewController.modalPresentationStyle = .OverCurrentContext
        // self.presentViewController(commentsViewController, animated: true, completion: nil)
        
        
        self.revealViewController().pushFrontViewController(commentsViewController, animated: true)
                
    }
  
    
    override func viewDidLoad(){
        super.viewDidLoad()
        rvc = self.revealViewController() as SWRevealViewController
        
        self.view.addGestureRecognizer(rvc.panGestureRecognizer())
        if PFUser.currentUser() != nil {
            let dateformatter = NSDateFormatter()
            
            dateformatter.dateStyle = NSDateFormatterStyle.MediumStyle
            
            dateformatter.timeStyle = NSDateFormatterStyle.MediumStyle
            
            let now = dateformatter.stringFromDate(NSDate())
            
            self.dateLabel.text = now
            
            loadDataFromParse()
        } else {
            // No user is signed in
        }
    }
    
    func loadDataFromParse(){
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height / 2;
        self.profileImage.clipsToBounds = true;
        self.profileImage.layer.borderWidth = 3.0
        self.profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        
        if let pUserName = PFUser.currentUser()?["username"] as? String {
            self.nameLabel.text = "@" + pUserName
        }
        
        let user = PFUser.currentUser()
        let userImageFile = user!["avatarUrl"] as! PFFile
        userImageFile.getDataInBackgroundWithBlock { (data, error) in
            if error == nil{
                self.avatarUrl = userImageFile
                self.profileImage.image = UIImage(data:data!)
            }
        }
       
    }
    
   
    
    func formatDate(date: NSDate) ->  String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let dateStr = dateFormatter.stringFromDate(date)
        return dateStr
    }
    
    
}
