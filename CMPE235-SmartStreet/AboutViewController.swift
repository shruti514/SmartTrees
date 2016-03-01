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

class AboutViewController: UIViewController, QRCodeReaderViewControllerDelegate{
    let transitionManager = MenuTransitionManager()
    
    @IBOutlet weak var lableInfo: UILabel!
    
    @IBOutlet weak var textInfo: UITextView!
    
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
            builder.reader          = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
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
                        self.textInfo.text = result.value
                    }
                    print("Completion with result: \(result.value) of type \(result.metadataType)")
                }
            }
            
            presentViewController(reader, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            
            presentViewController(alert, animated: true, completion: nil)
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
    
    func reader(reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        self.dismissViewControllerAnimated(true, completion: { [weak self] in
            let alert = UIAlertController(
                title: "Voila!",
                message: "Qr code decoded successfully",
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
