//
//  MediaViewController.swift
//  CMPE235-SmartStreet
//
//  Created by Shrutee Gangras on 3/8/16.
//  Copyright © 2016 Shrutee Gangras. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit
import AVFoundation
import MediaPlayer
import AssetsLibrary
import Photos

class MediaViewController: UIViewController, UINavigationControllerDelegate ,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    let randomNumber = Int(arc4random_uniform(6) + 1)
    var cameraUsed:Bool=false
    var userPressedPhoto=true
    let avPlayerController = AVPlayerViewController()
    var currentVideo:NSURL!
    
    @IBAction func deleteMedia(sender: AnyObject) {
        
        
    }
    
    @IBAction func shareMedia(sender: AnyObject) {
        //let modalViewController = ShareModalViewController()
        let shareModal = storyboard?.instantiateViewControllerWithIdentifier("ShareModal") as! ShareModalViewController
        shareModal.modalPresentationStyle = .OverCurrentContext
        shareModal.imageToShare = self.currentImage
        shareModal.videoToShare = self.currentVideo
        shareModal.userPressedPhoto = self.userPressedPhoto
        self.presentViewController(shareModal, animated: true, completion: nil)
    }
    
    @IBOutlet weak var currentImage: UIImageView!
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    
    @IBAction func takePhotos(sender: AnyObject) {
        if(cameraUsed){
            self.currentImage.image=nil
            if((self.view.viewWithTag(50)) != nil){
                self.view.viewWithTag(50)?.removeFromSuperview()
            }
            
        }
        if(UIImagePickerController.isSourceTypeAvailable(.Camera)){
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil{
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .Camera
                imagePicker.mediaTypes = [kUTTypeImage as String]
                cameraUsed = true
                presentViewController(imagePicker, animated: true, completion: nil)
                
            }else{
                showAlert("Rear camera does not exist", messageDetails: "Appplication can not access camera.")
            }
        }else{
            showAlert("Error", messageDetails: "Application can not access camera.")
        }
    }
    
    @IBAction func takeVideos(sender: AnyObject) {
        if(cameraUsed){
            self.shareButton.hidden = true
            self.deleteButton.hidden=true
            
        }
        self.userPressedPhoto = false
        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                
                imagePicker.sourceType = .Camera
                imagePicker.mediaTypes = [kUTTypeMovie as String]
                imagePicker.allowsEditing = false
                imagePicker.delegate = self
                
                presentViewController(imagePicker, animated: true, completion: {})
            } else {
                showAlert("Rear camera doesn't exist", messageDetails: "Application cannot access the camera.")
            }
        } else {
            showAlert("Camera inaccessable", messageDetails: "Application cannot access the camera.")
        }
    }
    
    @IBAction func gotoLibrary(sender: AnyObject) {
        if let recordAudioViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RecordAudioViewController") as? RecordAudioViewController {
            
            self.presentViewController(recordAudioViewController, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("User cancelled.")
        dismissViewControllerAnimated(true) { () -> Void in
            print("User cancelled.")        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("Photo/Video Captured")
        imagePicker.dismissViewControllerAnimated(true, completion: {
            print("Photo/Video saved.")
        })
        let mediaType = info[UIImagePickerControllerMediaType]
    
        let isMovie = UTTypeConformsTo(mediaType as! CFStringRef, kUTTypeMovie)
        
        
        if(isMovie){
            if let videoUrl:NSURL = (info[UIImagePickerControllerMediaURL] as? NSURL) {
                // Save video to the main photo album
                //self.currentVideo = videoUrl
                
                self.saveToAssetLibrary(videoUrl)
                
                let selectorToCall = Selector("videoSavedSuccessfully:didFinishSavingWithError:context:")
                UISaveVideoAtPathToSavedPhotosAlbum(videoUrl.relativePath!, self, selectorToCall, nil)
          
                self.shareButton.hidden=false
                self.deleteButton.hidden=false
               
                let videoUrl = info[UIImagePickerControllerMediaURL] as! NSURL
                let avPlayer = AVPlayer(URL:videoUrl)
                avPlayerController.player = avPlayer;          
                
                avPlayerController.view.frame = CGRect(x:0,y:192,width:415,height:451)
                avPlayerController.view.tag=50
               
                self.view.addSubview(avPlayerController.view)
                
                avPlayerController.player?.play()
            }
        }else{
            if let capturedImage : UIImage=(info[UIImagePickerControllerOriginalImage]) as? UIImage{
                self.currentImage.contentMode = .ScaleAspectFit
                self.currentImage.image = capturedImage
                self.shareButton.hidden=false
                self.deleteButton.hidden=false
                
            }
            
        }
    }
    
    func saveToAssetLibrary(videoUrl:NSURL){
        let assetLibrary : ALAssetsLibrary = ALAssetsLibrary()
        assetLibrary.writeVideoAtPathToSavedPhotosAlbum(videoUrl,
            completionBlock: {(newUrl: NSURL!, error: NSError!) in
                
                print(newUrl)
                
                self.currentVideo = newUrl
                
                if let theError = error{
                    print("Error happened while saving the video")
                    print("The error is = \(theError)")
                } else {
                    print("no errors happened")
                }
                
        })
        
        //var photoLibrary : PHPhotoLibrary = PHPhotoLibrary()
    }
    
    func videoSavedSuccessfully(video: String, didFinishSavingWithError error: NSError!, context: UnsafeMutablePointer<()>){
        var title = "Success"
        var message = "Video was saved"
        
        if let _ = error {
            title = "Error"
            message = "Video failed to save"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        //presentViewController(alert, animated: true, completion: nil)
        //self.startMediaBrowserFromViewController(self, usingDelegate: self)
        print("Video Saved successfully")
    }
    
    func startMediaBrowserFromViewController(viewController: UIViewController, usingDelegate delegate: protocol<UINavigationControllerDelegate, UIImagePickerControllerDelegate>) -> Bool {
        // 1
        if UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum) == false {
            return false
        }
        
        // 2
        let mediaUI = UIImagePickerController()
        mediaUI.sourceType = .SavedPhotosAlbum
        mediaUI.mediaTypes = [kUTTypeMovie as String]
        mediaUI.allowsEditing = true
        mediaUI.delegate = delegate
        
        // 3
        presentViewController(mediaUI, animated: true, completion: nil)
        return true
    }
    
    func saveImage(capturedImage:UIImage){
        let callSelector = Selector("imageWasSavedSuccessfully:didFinishSavingWithError:context:")
        UIImageWriteToSavedPhotosAlbum(capturedImage, self, callSelector, nil)
    
    }
    
    func imageWasSavedSuccessfully(image:UIImage,didFinishSavingWithError error :NSError!, context: UnsafeMutablePointer<()>){
        
        print("Image Saved.")
        if let err = error{
            print("Error occurred while saving an Image = \(err)")
        }else{
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                self.currentImage.image = image
            })
        }
    }
    
    func showAlert(messageTitle:String, messageDetails:String){
        let alertController = UIAlertController(title: messageTitle, message:
            messageDetails, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self;
        takePhotos(self)
        
        // Do any additional setup after loading the view.
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
