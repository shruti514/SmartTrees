//
//  LoginViewController.swift
//  CMPE235-SmartStreet
//
//  Created by Shrutee Gangras on 3/1/16.
//  Copyright © 2016 Shrutee Gangras. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    let ref = Firebase(url: "https://sweltering-inferno-8277.firebaseio.com/")
    let facebookLogin = FBSDKLoginManager()
    
     func sviewDidLoad() {
        super.viewDidLoad()
        
        if let _ = ref.authData{
            if let menuView = self.storyboard?.instantiateViewControllerWithIdentifier("MenuView") as? MenuViewController {
                
                self.presentViewController(menuView, animated: true, completion: nil)
            }
            
        }else{
            
            facebookLogin.logInWithReadPermissions(["public_profile", "email", "user_friends"],fromViewController: nil, handler: {
                (facebookResult, facebookError) -> Void in
                if facebookError != nil {
                    print("Facebook login failed. Error \(facebookError)")
                }
                else if facebookResult.isCancelled {
                    print("Facebook login was cancelled.")
                } else {
                    let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                    self.ref.authWithOAuthProvider("facebook", token: accessToken,
                        withCompletionBlock: { error, authData in
                            if error != nil {
                                print("Login failed. \(error)")
                            } else {
                                if let menuView = self.storyboard?.instantiateViewControllerWithIdentifier("MenuView") as? MenuViewController {
                                    
                                    self.presentViewController(menuView, animated: true, completion: nil)
                                }
                            }
                    })
                }
            })
            
            
        }
        
    }
    
    
     override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            
            // Or Show Logout Button
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
            self.returnUserData()
        }
        else
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
        
    }
    
    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
            
            self.returnUserData()
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(userName)")               
                if let menuView = self.storyboard?.instantiateViewControllerWithIdentifier("MenuView") as? MenuViewController {
                    
                    self.presentViewController(menuView, animated: true, completion: nil)
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
