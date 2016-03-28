//
//  QRRegisterViewController.swift
//  CMPE235-SmartStreet
//
//  Created by Shrutee Gangras on 3/28/16.
//  Copyright © 2016 Shrutee Gangras. All rights reserved.
//

import UIKit


//
//  AboutViewController.swift
//  CMPE235-SmartStreet
//
//  Created by Shrutee Gangras on 2/28/16.
//  Copyright © 2016 Shrutee Gangras. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader

class QRRegisterViewController: UIViewController, QRCodeReaderViewControllerDelegate{
    
    
    @IBOutlet weak var nameLabel: UILabel!
   
    @IBOutlet weak var nameLableValue: UILabel!
    
    @IBOutlet weak var emailIdLable: UILabel!
    @IBOutlet weak var emailIdLableValue: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var buttonLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    lazy var reader: QRCodeReaderViewController = {
        let builder = QRCodeViewControllerBuilder { builder in
            builder.reader          = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode,AVMetadataObjectTypeDataMatrixCode])
            builder.showTorchButton = true
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    @IBAction func scanAction(sender: AnyObject) {
        if QRCodeReader.supportsMetadataObjectTypes() {
            reader.modalPresentationStyle = .FormSheet
            reader.delegate               = self
            
            reader.completionBlock = { (result: QRCodeReaderResult?) in
                if let result = result {
                    if(self.isUrl(result.value)){
                        let url = NSURL(string: result.value)
                        UIApplication.sharedApplication().openURL(url!)
                    }else{
                        //self.lableInfo.text = result.value
                        let decodedStr = result.value
                        
                        let parts = decodedStr.componentsSeparatedByString(";")
                        var dict = [String: String]()
                        
                        for part in parts {
                            print(part)
                            let keyValue = part.componentsSeparatedByString("=")
                            dict[keyValue[0]]=keyValue[1]
                        }
                        
                        if let signUpViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SignUpViewController") as? SignUpViewController {
                            
                            signUpViewController.transferredUIImage = self.imageView
                            signUpViewController.transferredName = dict["name"]
                            signUpViewController.transferredEmailId = dict["emailId"]
                            self.presentViewController(signUpViewController, animated: true, completion: nil)
                        }
                    }
                    print("Completion with result: \(result.value) of type \(result.metadataType)")
                }
            }
            
           // presentViewController(reader, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            
            if let signUpViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SignUpViewController") as? SignUpViewController {
                
                self.presentViewController(signUpViewController, animated: true, completion: nil)
            }
        }
    }
    
   
    func isUrl(qr_result:String?)->Bool{
        if let qr_result = qr_result {
            if let url = NSURL(string: qr_result) {
                
                return UIApplication.sharedApplication().canOpenURL(url)
            }
        }
        return false
    }
    
    @IBAction func renderHome(sender: AnyObject) {
        
        
        if let menuView = self.storyboard?.instantiateViewControllerWithIdentifier("SlideMenuConfig") as? SWRevealViewController {
            
            self.presentViewController(menuView, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func register(sender: AnyObject) {
        
        
        if let signUpViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SignUpViewController") as? SignUpViewController {
            
            signUpViewController.profilePic = self.imageView
            signUpViewController.name.text = self.nameLableValue.text
            signUpViewController.emailAddress.text = self.emailIdLableValue.text            
            self.presentViewController(signUpViewController, animated: true, completion: nil)
        }
    }
    
    func reader(reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        self.dismissViewControllerAnimated(true, completion: { [weak self] in
            var message : String!
            switch(result.metadataType){
            case "org.iso.DataMatrix":
                message = "Data Matrix code decoded successfully."
                break
            case "org.iso.QRCode":
                message = "Qr code decoded successfully"
                break
            default:break
            }
            let alert = UIAlertController(
                title: "Voila!",
                message: message,
                preferredStyle: .Alert
            )
            alert.addAction(UIAlertAction(title: "Done", style: .Cancel, handler: nil))
            
            self?.presentViewController(alert, animated: true, completion: nil)
            })
    }
    
    func readerDidCancel(reader: QRCodeReaderViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}




