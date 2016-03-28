//
//  ShareModalViewController.swift
//  CMPE235-SmartStreet
//
//  Created by Shrutee Gangras on 3/8/16.
//  Copyright © 2016 Shrutee Gangras. All rights reserved.
//

import UIKit
import FBSDKShareKit
import Social
import MessageUI




class ShareModalViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate,FBSDKSharingDelegate {
    
    var imagePicker = UIImagePickerController()
    var imageToShare:UIImageView!
    var videoToShare:NSURL!
    var userPressedPhoto:Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clearColor()
        view.opaque = false
        //let aSelector : Selector = "tapOnScreenDetected"
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapOnScreenDetected")
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let photo : FBSDKSharePhoto = FBSDKSharePhoto()
        photo.image = info[UIImagePickerControllerOriginalImage] as! UIImage
        photo.userGenerated = true
        let content : FBSDKSharePhotoContent = FBSDKSharePhotoContent()
        content.photos = [photo]
    }
   
    
   
    @IBAction func shareOnFacebook(sender: AnyObject) {
        if(self.userPressedPhoto){
            self.sharePhotoOnFacebook()
        }else{
            self.shareVideoOnFacebook()
        }
        
    }
    
    func shareVideoOnFacebook(){
       
        let video : FBSDKShareVideo = FBSDKShareVideo()
        video.videoURL = self.videoToShare
        let content : FBSDKShareVideoContent = FBSDKShareVideoContent()
        content.video = video
       
        FBSDKShareDialog.showFromViewController(self,withContent:content,delegate:self)
        
         //let fbShareDialog:FBSDKShareDialog = FBSDKShareDialog()
//        fbShareDialog.shareContent=content
//        fbShareDialog.canShow()
//        let didShow = fbShareDialog.show()
//        if(didShow){
//            print("Could show")
//        }else{
//            print("Could not show")
//        }
    }
    
    
    
    func sharePhotoOnFacebook(){
        if(SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook))
        {
            let composeCtl :SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            composeCtl.addImage(self.imageToShare.image)
            composeCtl.setInitialText("Test a Post on Facebook")
            
            composeCtl.completionHandler = {
                result -> Void in
                
                
                let getResult = result as SLComposeViewControllerResult;
                switch(getResult.rawValue) {
                case SLComposeViewControllerResult.Cancelled.rawValue: print("Userd Cancelled")
                case SLComposeViewControllerResult.Done.rawValue: print("It Worked")
                default: print("Error!")
                }
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            self.presentViewController(composeCtl, animated: true, completion: nil)
            
        }
        

    
    }
    
    
    
    @IBAction func shareWithSocial(sender: AnyObject){
        let photo : FBSDKSharePhoto = FBSDKSharePhoto()
        photo.image = self.imageToShare.image
        photo.userGenerated = true
        let content : FBSDKSharePhotoContent = FBSDKSharePhotoContent()
        content.photos = [photo]
       // FBSDKShareAPI.shareWithContent(content, delegate: self)
        
    }
    
    
    
    @IBAction func shareByEmail(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.setSubject("Want to see something cool??")
        mailComposerVC.setMessageBody("Hi,\r\n\r\n Checkout this photo of Smart Trees.", isHTML: false)
        mailComposerVC.addAttachmentData(UIImageJPEGRepresentation(self.imageToShare.image!, CGFloat(1.0))!, mimeType: "image/jpeg",fileName: "SmartTree.jpeg")
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let alert = UIAlertController(title: "Error:Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    
     func tapOnScreenDetected() {
        
        
        if let menuView = self.storyboard?.instantiateViewControllerWithIdentifier("SlideMenuConfig") as? SWRevealViewController {
            
            self.presentViewController(menuView, animated: true, completion: nil)
        }
    }
    
    
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!){
        print("In did complete with results")
    }
    
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!){
        
        print("In did fail with error "+error.description)
    }
    

 
    func sharerDidCancel(sharer: FBSDKSharing!){
        print("in did cancel")
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

