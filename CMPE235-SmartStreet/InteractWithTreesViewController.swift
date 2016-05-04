//
//  InteractWithTreesViewController.swift
//  CMPE235-SmartStreet
//
//  Created by Shrutee Gangras on 4/25/16.
//  Copyright © 2016 Shrutee Gangras. All rights reserved.
//

import UIKit

class InteractWithTreesViewController: UIViewController {
   var rvc : SWRevealViewController!
    
    
    @IBAction func slideMenu(sender: AnyObject) {
        if let menuView = self.storyboard?.instantiateViewControllerWithIdentifier("SlideMenuConfig") as? SWRevealViewController {
            
            self.presentViewController(menuView, animated: true, completion: nil)
        }
    }
    
    @IBAction func openSlideMenu(sender: AnyObject) {
        //rvc.pushFrontViewController(slideViewController, animated: true)
        rvc.revealToggle(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rvc = self.revealViewController() as SWRevealViewController
        
        self.view.addGestureRecognizer(rvc.panGestureRecognizer())
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    @IBAction func changeLights(sender: AnyObject) {
        
        let lightsController = storyboard?.instantiateViewControllerWithIdentifier("LightsController") as! LightsController
        
        self.revealViewController().pushFrontViewController(lightsController, animated: true)
    }

    @IBAction func changeMusic(sender: AnyObject) {
        let musicController = storyboard?.instantiateViewControllerWithIdentifier("MusicPlayerController") as! MusicPlayerController
        
        self.revealViewController().pushFrontViewController(musicController, animated: true)
        
    }
    @IBOutlet weak var changeMusic: UIButton!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
