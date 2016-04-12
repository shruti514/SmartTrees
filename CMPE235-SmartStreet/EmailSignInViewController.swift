//
//  EmailSignInViewController.swift
//  CMPE235-SmartStreet
//
//  Created by Shrutee Gangras on 3/23/16.
//  Copyright © 2016 Shrutee Gangras. All rights reserved.
//

import Parse

class EmailSignInViewController: UIViewController {

   
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
   

    @IBAction func signIn(sender: AnyObject) {
        let username = self.username.text
        let password = self.password.text
        
        PFUser.logInWithUsernameInBackground(username!, password: password!, block: { (user, error) -> Void in
            if ((user) != nil) {
                let alert = UIAlertView(title: "Success", message: "Logged In", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if let menuView = self.storyboard?.instantiateViewControllerWithIdentifier("SlideMenuConfig") as? SWRevealViewController {
                        
                        
                        self.presentViewController(menuView, animated: true, completion: nil)
                    }
                })
                
            } else {
                let alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
        })
        
    }
}
