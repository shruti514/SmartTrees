//
//  SlideViewController.swift
//  CMPE235-SmartStreet
//
//  Created by Shrutee Gangras on 3/7/16.
//  Copyright © 2016 Shrutee Gangras. All rights reserved.
//

import UIKit
import Firebase

class SlideViewController: UIViewController {

    @IBOutlet var logout: [UILabel]!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    @IBOutlet weak var navigateToHome: UIButton!
    @IBAction func navigateToMainMenuScreen(sender: AnyObject) {
        if let menuView = self.storyboard?.instantiateViewControllerWithIdentifier("SlideMenuConfig") as? SWRevealViewController {
            
            
            self.presentViewController(menuView, animated: true, completion: nil)
        }
        
    }
    @IBAction func logoutaction(sender: AnyObject) {
        // Send a request to log out a user
        PFUser.logOut()
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if let loginview = self.storyboard?.instantiateViewControllerWithIdentifier("LoginView") as? LoginViewController {
                
                
                self.presentViewController(loginview, animated: true, completion: nil)
            }

        })
    }
    
    @IBOutlet var signout: [UILabel]!
    @IBOutlet weak var emailIdLabel: UILabel!
   
    
    override func viewDidLoad() {
       
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height / 2;
        self.profileImage.clipsToBounds = true;
        self.profileImage.layer.borderWidth = 3.0
        self.profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        //self.profileImage.contentMode = .ScaleAspectFit
        
        if PFUser.currentUser() != nil {
            // user authenticated
            //loadDataFromFirebase()
            loadDataFromParse()
        } else {
            // No user is signed in
        }
        

        // Do any additional setup after loading the view.
    }
    
    func loadDataFromParse(){        
        if let pUserName = PFUser.currentUser()?["username"] as? String {
            self.nameLabel.text = "@" + pUserName
        }
        if let pEmailId = PFUser.currentUser()?["email"] as? String {
            //self.emailIdLabel.text =  pEmailId
        }
        
        let user = PFUser.currentUser()
        let userImageFile = user!["avatarUrl"] as! PFFile
        userImageFile.getDataInBackgroundWithBlock { (data, error) in
            if error == nil{
                self.profileImage.image = UIImage(data:data!)
            }
        }
        
    }
    
    func showImage( imageString: String) -> UIImage{
        
        let decodedData = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        
        let decodedImage = UIImage(data: decodedData!)
        
        return decodedImage!
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
