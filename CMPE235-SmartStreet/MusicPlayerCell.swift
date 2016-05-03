//
//  MusicPlayerCell.swift
//  CMPE235-SmartStreet
//
//  Created by Shrutee Gangras on 4/29/16.
//  Copyright © 2016 Shrutee Gangras. All rights reserved.
//

//
//  MusicPlayerCell.swift
//  ParseStarterProject-Swift
//
//  Created by Shrutee Gangras on 4/25/16.
//  Copyright © 2016 Parse. All rights reserved.
//
import UIKit
import Parse

class MusicPlayerCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var musicId:String! = nil
    
    
    @IBOutlet weak var buttonLabel: UIButton!
    
    
    @IBAction func onButtonPressed(sender: AnyObject) {
        
        
        if(buttonLabel.currentTitle == "Play"){
            buttonLabel.setTitle("Stop", forState: .Normal)
            let userInteraction = PFObject(className: "UserInteraction")
            userInteraction["UserId"] = "SomeUserId"
            userInteraction["MusicSelection"] = self.musicId
            userInteraction["LightSelection"] = "NONE"
            userInteraction["Date"] = NSDate()
            userInteraction["Type"]="Music"
            
            
            
            userInteraction.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) in
                if(success){
                    print("User interaction added to database.")
                }else{
                    print("Error occured while adding a user interaction.")
                }
            })
            
        }else if(buttonLabel.currentTitle == "Stop"){
            buttonLabel.setTitle("Play", forState: .Normal)
            let userInteraction = PFObject(className: "UserInteraction")
            userInteraction["UserId"] = "SomeUserId"
            userInteraction["MusicSelection"] = "NONE"
            userInteraction["LightSelection"] = "NONE"
            userInteraction["Date"] = NSDate()
            userInteraction["Type"]="Music"
            
            userInteraction.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) in
                if(success){
                    print("User interaction added to database.")
                }else{
                    print("Error occured while adding a user interaction.")
                }
            })
            
        }
        
        
    }
    
    
}
