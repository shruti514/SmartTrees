//
//  LaunchScreenController.swift
//  CMPE235-SmartStreet
//
//  Created by Shrutee Gangras on 5/4/16.
//  Copyright © 2016 Shrutee Gangras. All rights reserved.
//

import UIKit
import Parse

class LaunchScreenController: UIViewController {
    @IBOutlet weak var greetingsLable: UILabel!
    
    
    override func viewDidLoad() {
        if (PFUser.currentUser() != nil) {
            
            let username = PFUser.currentUser()?["username"] as! String
            self.greetingsLable.text = username
            self.greetingsLable.hidden = false
        }
        
    }
    

}
