    //
    //  LoginViewController.swift
    //  CMPE235-SmartStreet
    //
    //  Created by Shrutee Gangras on 3/1/16.
    //  Copyright © 2016 Shrutee Gangras. All rights reserved.
    //
    
    import UIKit
    import Firebase
    import FBSDKShareKit
    import FBSDKLoginKit
    
    class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
        
        let refUrl = Firebase(url: "https://sweltering-inferno-8277.firebaseio.com/")
        let facebookLogin = FBSDKLoginManager()
        //var authClient:FirebaseSimpleLogin!
        
        @IBOutlet weak var loginWithEmailButton: UIButton!
        
        
        
        override func viewDidLoad() {
            
            super.viewDidLoad()
            
            if refUrl.authData != nil {
                if (FBSDKAccessToken.currentAccessToken() != nil)
                {
                    // User is already logged in, do work such as go to next view controller.
                    
                    // Or Show Logout Button
                    let loginView : FBSDKLoginButton = FBSDKLoginButton()
                    self.view.addSubview(loginView)
                    loginView.center = self.view.center
                    loginView.readPermissions = ["public_profile", "email", "user_friends"]
                    loginView.delegate = self
                    
                    //let credentialsProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: "11721569-f989-4602-953f-e0fb747c7977")
                    //_ = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialsProvider)
                    
                    _ = FBSDKAccessToken.currentAccessToken().tokenString
                    //credentialsProvider.logins = [AWSCognitoLoginProviderKey.Facebook.rawValue: token]
                    self.returnUserData()
                }else{
//                    if let menuView = self.storyboard?.instantiateViewControllerWithIdentifier("SlideMenuConfig") as? SWRevealViewController {
//                        
//                        self.presentViewController(menuView, animated: true, completion: nil)
//                    }
                    
                }
                
            } else {
                let center = CGPoint(x: self.view.center.x,
                    y: self.view.center.y+200);
                
                
                
                let loginView : FBSDKLoginButton = FBSDKLoginButton()
                loginView.center = center
                self.view.addSubview(loginView)
                loginView.readPermissions = ["public_profile", "email", "user_friends"]
                loginView.delegate = self
            }
            
        }
        
        
        
        
        
        @IBAction func loginWithEmail(sender: AnyObject) {
            if let emailSignInViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EmailSignInViewController") as? EmailSignInViewController {
                
                
                self.presentViewController(emailSignInViewController, animated: true, completion: nil)
            }
            
        }
        
        @IBAction func register(sender: AnyObject) {
            if let signUpViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SignUpViewController") as? SignUpViewController {
                signUpViewController.ref = self.refUrl
                //signUpViewController.authClient = self.authClient
                
                self.presentViewController(signUpViewController, animated: true, completion: nil)
            }
        }
        
        // Facebook Delegate Methods
        
        func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
            print("User Logged In")
            
            if ((error) != nil)
            {
                print(error)
            }
            else if result.isCancelled {
                print("User cancelled")
            }
            else {
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                if result.grantedPermissions.contains("email")
                {
                    let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                    self.refUrl.authWithOAuthProvider("facebook", token: accessToken,
                        withCompletionBlock: { error, authData in
                            if error != nil {
                                print("Login failed. \(error)")
                            }
                    })
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
                    if let menuView = self.storyboard?.instantiateViewControllerWithIdentifier("SlideMenuConfig") as? SWRevealViewController {
                        
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
