//
//  EmailSignInViewController.swift
//  CMPE235-SmartStreet
//
//  Created by Shrutee Gangras on 3/23/16.
//  Copyright © 2016 Shrutee Gangras. All rights reserved.
//

import Firebase

class EmailSignInViewController: UIViewController {
    
 
    
    let refUrl = Firebase(url: "https://sweltering-inferno-8277.firebaseio.com/")
    
    
    @IBOutlet weak var emailId: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
   

    @IBAction func signIn(sender: AnyObject) {
        
        refUrl.authUser(emailId.text, password: password.text) {
            error, authData in
            if error != nil {
                print("There was an error logging in to this account")
            } else {
                if let menuView = self.storyboard?.instantiateViewControllerWithIdentifier("SlideMenuConfig") as? SWRevealViewController {
                    
                    self.presentViewController(menuView, animated: true, completion: nil)
                }
            }
        }
    }
}
