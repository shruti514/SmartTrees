    //
    //  LoginViewController.swift
    //  CMPE235-SmartStreet
    //
    //  Created by Shrutee Gangras on 3/1/16.
    //  Copyright © 2016 Shrutee Gangras. All rights reserved.
    //
    
    import UIKit
    import Parse
    import FBSDKShareKit
    import FBSDKLoginKit
    import ParseFacebookUtilsV4
    
    class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
        @IBOutlet weak var greetingsLabel: UILabel!
       
        let facebookLogin = FBSDKLoginManager()
        let permissions=["public_profile", "email", "user_friends"]
       // let permissions = ["public_profile"]
        //var authClient:FirebaseSimpleLogin!
        
        @IBOutlet weak var loginWithEmailButton: UIButton!
        
        
        override func viewWillAppear(animated: Bool) {
            if (PFUser.currentUser() != nil) {
                
                let username = PFUser.currentUser()?["username"] as! String
                self.greetingsLabel.text = username
                self.greetingsLabel.hidden = false


                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if let menuView = self.storyboard?.instantiateViewControllerWithIdentifier("SlideMenuConfig") as? SWRevealViewController {
                        
                        self.presentViewController(menuView, animated: true, completion: nil)
                    }
                })
            }
        }
        
        
        override func viewDidLoad() {
            
            super.viewDidLoad()
            if PFUser.currentUser() != nil {
                if (FBSDKAccessToken.currentAccessToken() != nil)
                {
                    // User is already logged in, do work such as go to next view controller.
                    
                    // Or Show Logout Button
                    let loginView : FBSDKLoginButton = FBSDKLoginButton()
                    self.view.addSubview(loginView)
                    loginView.center = self.view.center
                    loginView.readPermissions = ["public_profile", "email", "user_friends"]
                    loginView.delegate = self
                  
                    
                    _ = FBSDKAccessToken.currentAccessToken().tokenString
                    //credentialsProvider.logins = [AWSCognitoLoginProviderKey.Facebook.rawValue: token]
                    self.returnUserData()
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
                    PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile","email"], block: { (user:PFUser?, error:NSError?) -> Void in
                        
                        if(error != nil)
                        {
                            //Display an alert message
                            let myAlert = UIAlertController(title:"Alert", message:error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert);
                            
                            let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                            
                            myAlert.addAction(okAction);
                            self.presentViewController(myAlert, animated:true, completion:nil);
                            
                            return
                        }
                        
                        print(user)
                        
                        _ = PFUser()
                        
//                        newUser["name"] = user[]
//                        newUser.username = username
//                        newUser.password = password
//                        newUser.email = finalEmail
//                        newUser["avatarUrl"] = base64String
                        
                        print("Current user token=\(FBSDKAccessToken.currentAccessToken().tokenString)")
                        
                        print("Current user id \(FBSDKAccessToken.currentAccessToken().userID)")
                        
                        if(FBSDKAccessToken.currentAccessToken() != nil)
                        {
                            self.saveUserInParse()
                            self.returnUserData()
                            
                        }
                    })
                }else{
                    self.saveUserInParse()
                    self.returnUserData()
                }
                
            }
            
        }
        
        func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
            print("User Logged Out")
        }
        
        func saveUserInParse(){
            let requestParameters = ["fields": "id, email, first_name, last_name"]
            
            let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)
           
            
            userDetails.startWithCompletionHandler { (connection, result, error:NSError!) -> Void in
                
                if(error != nil)
                {
                    print("\(error.localizedDescription)")
                    return
                }
                
                if(result != nil)
                {
                    let fbResult = result as! Dictionary<String, AnyObject>
                    let userId:String = fbResult["id"] as! String
                    let userFirstName:String? = fbResult["first_name"] as? String
                    let userLastName:String? = fbResult["last_name"] as? String
                    let userEmail:String? = fbResult["email"] as? String
                    
                    
                    print("\(userEmail)")
                    
                    let myUser = PFUser()
                    
                    var name=""
                    
                    // Save first name
                    if(userFirstName != nil)
                    {
                       name = userFirstName!
                    }
                    
                    //Save last name
                    
                    if(userLastName != nil)
                    {
                        myUser.setObject(name+userLastName!, forKey: "name")
                    }
                    
                    // Save email address
                    if(userEmail != nil)
                    {
                        myUser.setObject(userEmail!, forKey: "email")
                        myUser.setObject(userEmail!, forKey: "username")
                        myUser.setObject(userEmail!, forKey: "password")
                    }
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                        
                        // Get Facebook profile picture
                        let userProfile = "https://graph.facebook.com/" + userId + "/picture?type=large"
                        
                        let profilePictureUrl = NSURL(string: userProfile)
                        
                        let profilePictureData = NSData(contentsOfURL: profilePictureUrl!)
                        
                        if(profilePictureData != nil)
                        {
                            let profileFileObject = PFFile(data:profilePictureData!)
                            myUser.setObject(profileFileObject, forKey: "avatarUrl")
                        }
                        
                        
                        myUser.signUpInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                            
                            if(success)
                            {
                                print("User details are now updated")
                            }
                            
                        })
                        
                    }
                    
                }
                
            }
            

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
