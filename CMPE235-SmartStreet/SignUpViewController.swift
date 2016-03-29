//
//  SignUpViewController.swift
//  CMPE235-SmartStreet
//
//  Created by Shrutee Gangras on 2/28/16.
//  Copyright © 2016 Shrutee Gangras. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    var imagePicker: UIImagePickerController = UIImagePickerController()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var profilePic: UIImageView!
    var ref:Firebase!
    let profilesRef = Firebase(url: "https://sweltering-inferno-8277.firebaseio.com/profiles")
    
    //var authClient:FirebaseSimpleLogin!
    @IBOutlet weak var addProfilePic: UIButton!
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var confirmPassword: UITextField!
    
    var transferredName:String!
    var transferredEmailId:String!
    var transferredUIImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidden=true
        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.height / 2;
        self.profilePic.clipsToBounds = true;
        self.profilePic.layer.borderWidth = 3.0
        self.profilePic.layer.borderColor = UIColor.whiteColor().CGColor
        self.profilePic.contentMode = .ScaleAspectFit
        
        if(transferredName != nil){
            self.name.text = transferredName
        }
        if(transferredEmailId != nil){
            self.emailAddress.text = transferredEmailId
        
        }
        if(transferredUIImage != nil){
            self.profilePic.image = transferredUIImage.image
        }
        //self.profilePic.layer.cornerRadius = 10.0;
        // Do any additional setup after loading the view.
    }
    
   
    
    
    @IBAction func register(sender: AnyObject) {
        activityIndicator.hidden=false
        activityIndicator.startAnimating()
        ref.createUser(emailAddress.text, password: password.text,
            withValueCompletionBlock: { error, result in
                if error != nil {
                    self.activityIndicator.stopAnimating()
                    print("There was an error creating the account")
                } else {
                    let uid = result["uid"] as? String
                    print("Successfully created user account with uid: \(uid)")

                    self.ref.authUser(self.emailAddress.text, password: self.password.text,
                        withCompletionBlock: { error, authData in
                            if error != nil {
                                print("There was an error logging in to this account")
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.hidden=true
                            } else {
                                print("We are now logged in")
                                
                                var data: NSData = NSData()
                                if let image = self.profilePic.image {
                                    data = UIImageJPEGRepresentation(image,0.1)!
                                }
                                let base64String = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
                                
                                let newUser = [
                                    "emailId": self.emailAddress.text! as String,
                                    "provider": authData.provider as String,
                                    "name": self.name.text! as String,
                                    "avatarUrl": base64String as String
                                ]
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.hidden=true
                                
                                self.profilesRef.childByAppendingPath(authData.uid).setValue(newUser)
                                if let menuView = self.storyboard?.instantiateViewControllerWithIdentifier("SlideMenuConfig") as? SWRevealViewController {
                                    
                                    
                                    self.presentViewController(menuView, animated: true, completion: nil)
                                }
                                
                            }
                    })
                }
        })
        
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

extension SignUpViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK:- UIImagePickerControllerDelegate methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        profilePic.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK:- Add Picture
    
    @IBAction func addPicture(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion:nil)
        
        
//        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
//            imagePicker =  UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = .Camera
//            
//            presentViewController(imagePicker, animated: true, completion: nil)
//        } else {
//            imagePicker.allowsEditing = false
//            imagePicker.sourceType = .PhotoLibrary
//            imagePicker.delegate = self
//            presentViewController(imagePicker, animated: true, completion:nil)
//        }
    }
}
