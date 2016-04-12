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
    var ref = Firebase(url: "https://sweltering-inferno-8277.firebaseio.com/")
    let profilesRef = Firebase(url: "https://sweltering-inferno-8277.firebaseio.com/profiles")
    
    //var authClient:FirebaseSimpleLogin!
    @IBOutlet weak var addProfilePic: UIButton!
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var username: UITextField!
    
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
        //self.profilePic.contentMode = .ScaleAspectFit
        
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
        
        let name = self.name.text
        let username = self.username.text
        let password = self.password.text
        let email = self.emailAddress.text
        let finalEmail = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        var data: NSData = NSData()
        if let image = self.profilePic.image {
            data = UIImageJPEGRepresentation(image,0.1)!
        }
        
        
        let newUser = PFUser()
       
        newUser.setObject(name!, forKey: "name")
        newUser.username = username
        newUser.password = password
        newUser.email = finalEmail
        
        let profileFileObject = PFFile(data:data)
        newUser.setObject(profileFileObject, forKey: "avatarUrl")
     
        
        // Sign up the user asynchronously
        newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
            
            // Stop the spinner
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidden=true
            if ((error) != nil) {
                let alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                
            } else {
                let alert = UIAlertView(title: "Success", message: "Signed Up", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if let menuView = self.storyboard?.instantiateViewControllerWithIdentifier("SlideMenuConfig") as? SWRevealViewController {
                        
                        
                        self.presentViewController(menuView, animated: true, completion: nil)
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
