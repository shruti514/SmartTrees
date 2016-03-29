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

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    @IBOutlet weak var navigateToHome: UIButton!
    @IBAction func navigateToMainMenuScreen(sender: AnyObject) {
        if let menuView = self.storyboard?.instantiateViewControllerWithIdentifier("SlideMenuConfig") as? SWRevealViewController {
            
            
            self.presentViewController(menuView, animated: true, completion: nil)
        }
        
    }
    let refUrl = Firebase(url: "https://sweltering-inferno-8277.firebaseio.com/")
    @IBOutlet weak var emailIdLabel: UILabel!
    let profilesRef = Firebase(url: "https://sweltering-inferno-8277.firebaseio.com/profiles")
    
    override func viewDidLoad() {
       
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height / 2;
        self.profileImage.clipsToBounds = true;
        self.profileImage.layer.borderWidth = 3.0
        self.profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        //self.profileImage.contentMode = .ScaleAspectFit
        
        if refUrl.authData != nil {
            // user authenticated
            loadDataFromFirebase()
        } else {
            // No user is signed in
        }
        

        // Do any additional setup after loading the view.
    }
    
    func loadDataFromFirebase() {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        
        profilesRef.childByAppendingPath(refUrl.authData.uid).observeEventType(.Value, withBlock: { snapshot in
           
            //print(snapshot.value)
          
            self.profileImage.image = self.showImage(snapshot.value["avatarUrl"] as! String)
            self.nameLabel.text = snapshot.value["name"] as? String
            self.emailIdLabel.text = snapshot.value["emailId"] as? String
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
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
