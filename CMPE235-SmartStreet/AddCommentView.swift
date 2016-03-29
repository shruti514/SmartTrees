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
    let refUrl = Firebase(url: "https://sweltering-inferno-8277.firebaseio.com/")
    let profilesRef = Firebase(url: "https://sweltering-inferno-8277.firebaseio.com/profiles")
    let commentsRef = Firebase(url: "https://sweltering-inferno-8277.firebaseio.com/comments")

    var avatarUrl:String!

    @IBOutlet weak var postComment: UIButton!
    @IBOutlet weak var commentText: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cosmosViewPrecise: CosmosView!
    
    @IBAction func postCommentAction(sender: AnyObject) {
        let name = self.nameLabel.text
        let commentDate = self.dateLabel.text
        let avatarUrl = self.avatarUrl
        let commentText = self.commentText.text
        let starRatings = self.cosmosViewPrecise.rating
        
        let starRatingsStr:String = String(format:"%.2f", starRatings)
       
       
        let comment: NSDictionary = ["name": name!, "commentDate": commentDate!, "avatarUrl":avatarUrl, "commentText":commentText, "starRatings":starRatingsStr]
        
        let thisCommentRef = commentsRef.childByAutoId()
        thisCommentRef.setValue(comment)
        
        if let commentsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CommentsViewController") as? CommentsViewController {
            
            self.presentViewController(commentsViewController, animated: true, completion: nil)
        }
        
    }
  
    
    override func viewDidLoad(){
        if refUrl.authData != nil {
            let dateformatter = NSDateFormatter()
            
            dateformatter.dateStyle = NSDateFormatterStyle.MediumStyle
            
            dateformatter.timeStyle = NSDateFormatterStyle.MediumStyle
            
            let now = dateformatter.stringFromDate(NSDate())
            
            self.dateLabel.text = now
            
            loadDataFromFirebase()
        } else {
            // No user is signed in
        }
    }
    
    func loadDataFromFirebase() {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        profilesRef.childByAppendingPath(refUrl.authData.uid).observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            //self.profileImage.contentMode = .ScaleAspectFit
            self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height / 2;
            self.profileImage.clipsToBounds = true;
            self.profileImage.layer.borderWidth = 3.0
            self.profileImage.layer.borderColor = UIColor.whiteColor().CGColor
            self.profileImage.image = self.showImage(snapshot.value["avatarUrl"] as! String)
            self.avatarUrl = snapshot.value["avatarUrl"] as! String
            self.nameLabel.text = snapshot.value["name"] as? String
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
    func showImage( imageString: String) -> UIImage{
        let decodedData = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let decodedImage = UIImage(data: decodedData!)
        return decodedImage!
    }
    
    func formatDate(date: NSDate) ->  String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let dateStr = dateFormatter.stringFromDate(date)
        return dateStr
    }
    
    
}
