//
//  InviteFriendModalViewController.swift
//  CMPE235-SmartStreet
//
//  Created by Shrutee Gangras on 3/3/16.
//  Copyright © 2016 Shrutee Gangras. All rights reserved.
//

import UIKit

class InviteFriendModalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clearColor()
        view.opaque = false
        //let aSelector : Selector = "tapOnScreenDetected"
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapOnScreenDetected")
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tapOnScreenDetected() {
        
        
        if let menuView = self.storyboard?.instantiateViewControllerWithIdentifier("SlideMenuConfig") as? SWRevealViewController {
            
            self.presentViewController(menuView, animated: true, completion: nil)
        }
    }
    

    
    @IBAction func close(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
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
