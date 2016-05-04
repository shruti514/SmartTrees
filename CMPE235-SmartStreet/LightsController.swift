//
//  LightsController.swift
//  CMPE235-SmartStreet
//
//  Created by Shrutee Gangras on 5/3/16.
//  Copyright © 2016 Shrutee Gangras. All rights reserved.
//

import UIKit
import Parse

class LightsController: UIViewController {
    
    func blueButtonClicked(){
        
        let currentUser = PFUser.currentUser()
        let userInteraction = PFObject(className: "UserInteraction")
        userInteraction["UserId"] = currentUser!["objectId"]
        userInteraction["MusicSelection"] = "NONE"
        userInteraction["LightSelection"] = "BLUE"
        userInteraction["Date"] = NSDate()
        userInteraction["Type"]="Light"
        
        userInteraction.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) in
            if(success){
                print("User interaction added to database.")
            }else{
                print("Error occured while adding a user interaction.")
            }
        })
        
    }
    
    func greenButtonClicked(){
        
        let currentUser = PFUser.currentUser()
        let userInteraction = PFObject(className: "UserInteraction")
        userInteraction["UserId"] = currentUser!["objectId"]
        userInteraction["MusicSelection"] = "NONE"
        userInteraction["LightSelection"] = "GREEN"
        userInteraction["Date"] = NSDate()
        userInteraction["Type"]="Light"
        
        userInteraction.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) in
            if(success){
                print("User interaction added to database.")
            }else{
                print("Error occured while adding a user interaction.")
            }
        })
        
    }
    
    func redButtonClicked(){
        
        let currentUser = PFUser.currentUser()
        let userInteraction = PFObject(className: "UserInteraction")
        userInteraction["UserId"] = currentUser!["objectId"]
        userInteraction["MusicSelection"] = "NONE"
        userInteraction["LightSelection"] = "RED"
        userInteraction["Date"] = NSDate()
        userInteraction["Type"]="Light"
        
        userInteraction.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) in
            if(success){
                print("User interaction added to database.")
            }else{
                print("Error occured while adding a user interaction.")
            }
        })
        
    }
    
}
