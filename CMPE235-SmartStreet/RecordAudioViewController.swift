//
//  RecordAudioViewController.swift
//  CMPE235-SmartStreet
//
//  Created by Shrutee Gangras on 3/28/16.
//  Copyright © 2016 Shrutee Gangras. All rights reserved.
//

import UIKit
import AVFoundation
import FBSDKMessengerShareKit
import MessageUI
import AssetsLibrary

class RecordAudioViewController: UIViewController,AVAudioPlayerDelegate, AVAudioRecorderDelegate,MFMailComposeViewControllerDelegate{
    
    @IBOutlet var PlayBTN: UIButton!
    @IBOutlet var RecordBTN: UIButton!
    
    
    var soundRecorder : AVAudioRecorder!
    var SoundPlayer : AVAudioPlayer!
    
    var fileName = "audioFile.mp3"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupRecorder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupRecorder(){
        
        
        let recordSettings :[String:AnyObject] = [AVFormatIDKey : Int(kAudioFormatAppleLossless),
            AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
            AVEncoderBitRateKey : 320000,
        
            AVNumberOfChannelsKey : 2,
       
            AVSampleRateKey : 44100.0 ]
        
        var error : NSError?
        
        do {
            soundRecorder = try AVAudioRecorder(URL: getFileURL(), settings: recordSettings as [String : AnyObject])
        } catch let error1 as NSError {
            error = error1
            soundRecorder = nil
        }
        
        if let _ = error{
            
            NSLog("Something Wrong")
        }
            
        else {
            
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
            
        }
        
    }
    
    
    
    
    func getCacheDirectory() -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        return paths[0]
        
    }
    
    func getFileURL() -> NSURL{
        let path  = (getCacheDirectory() as NSString).stringByAppendingPathComponent(fileName)
        
        let filePath = NSURL(fileURLWithPath: path)
        
        return filePath
    }
    
    
    @IBAction func Record(sender: UIButton) {
        
        if sender.titleLabel?.text == "Record"{
            
            soundRecorder.record()
            sender.setTitle("Stop", forState: .Normal)
            PlayBTN.enabled = false
            
        }
        else{
            
            soundRecorder.stop()
            sender.setTitle("Record", forState: .Normal)
            PlayBTN.enabled = false
        }
        
    }
    
    @IBAction func PlaySound(sender: UIButton) {
        
        if sender.titleLabel?.text == "Play" {
            
            if(RecordBTN.enabled == false){
                 sender.setTitle("Stop", forState: .Normal)
            }
            
            preparePlayer()
            SoundPlayer.play()
            
        }
        else{
            
            SoundPlayer.stop()
            sender.setTitle("Play", forState: .Normal)
            
        }
        
    }
    
    
    @IBAction func shareAudio(sender: AnyObject) {
        
        let mp3Data = NSData(contentsOfURL: getFileURL())
        FBSDKMessengerSharer.shareAudio(mp3Data, withOptions: nil)
      
    }
    
    @IBAction func shareByEmail(sender: AnyObject) {
        sendemail()
    }
    
    func sendemail(){
        if( MFMailComposeViewController.canSendMail() ) {
            print("Can send email.")
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            //Set the subject and message of the email
            mailComposer.setSubject("Smart Tree - Recorder Music")
            mailComposer.setMessageBody("Listen to this music played by SmartTrees", isHTML: false)
            
            let mp3Data = NSData(contentsOfURL: getFileURL())
             mailComposer.addAttachmentData(mp3Data!, mimeType: "audio/x-wav", fileName: fileName)
            
            self.presentViewController(mailComposer, animated: true, completion: nil)
        }
    }
    
    func saveToAssetLibrary(audioURL:NSURL) -> NSURL {
        var urlToReturn: NSURL!
        let assetLibrary : ALAssetsLibrary = ALAssetsLibrary()
        assetLibrary.writeVideoAtPathToSavedPhotosAlbum(audioURL,
            completionBlock: {(newUrl: NSURL!, error: NSError!) in
                
                print(newUrl)
                
                
                
                if let theError = error{
                    print("Error happened while saving the video")
                    print("The error is = \(theError)")
                } else {
                    print("no errors happened")
                }
               urlToReturn = newUrl
                
        })
        
        return urlToReturn
        
        //var photoLibrary : PHPhotoLibrary = PHPhotoLibrary()
    }


    
    func preparePlayer(){
        
        var error : NSError?
        do {
            SoundPlayer = try AVAudioPlayer(contentsOfURL: getFileURL())
        } catch let error1 as NSError {
            error = error1
            SoundPlayer = nil
        }
        
        if let err = error{
            
            NSLog(err.description)
        }
        else{
            
            SoundPlayer.delegate = self
            SoundPlayer.prepareToPlay()
            SoundPlayer.volume = 1.0
        }
        
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        PlayBTN.enabled = true
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        RecordBTN.enabled = true
        PlayBTN.setTitle("Play", forState: .Normal)
    }
    
}

