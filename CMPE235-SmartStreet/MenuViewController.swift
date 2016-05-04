 //
//  MenuViewController.swift
//  CMPE235-SmartStreet
//
//  Created by Shrutee Gangras on 2/28/16.
//  Copyright © 2016 Shrutee Gangras. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    let transitionManager = MenuTransitionManager()
    var slideViewController = SlideViewController!()
    var rvc : SWRevealViewController!
    
    
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var aboutLabel: UILabel!
    
    @IBOutlet weak var interactButton: UIButton!
    @IBOutlet weak var interactLabel: UILabel!
    
    @IBOutlet weak var nearbyButton: UIButton!
    @IBOutlet weak var nearbyLabel: UILabel!
    
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var photoLabel: UILabel!
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var shareLabel: UILabel!
    
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    
    
    @IBOutlet weak var openSlideMenu: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.transitioningDelegate = self.transitionManager
       // self.parentViewController = SWRevealViewController()
       
         slideViewController = storyboard?.instantiateViewControllerWithIdentifier("SlideViewController") as! SlideViewController
        rvc = self.revealViewController() as SWRevealViewController
        rvc.setFrontViewController(self, animated: true)
        rvc.setRearViewController(slideViewController, animated: true)
        self.view.addGestureRecognizer(rvc.panGestureRecognizer())
        
    }
    
    
    @IBAction func openAboutScreen(sender: AnyObject) {
       let aboutController = storyboard?.instantiateViewControllerWithIdentifier("AboutViewController") as! AboutViewController
       // self.revealViewController().setFrontViewController(aboutController, animated: true)
        self.revealViewController().pushFrontViewController(aboutController, animated: true)
        
    }
    
    @IBAction func openMapScreen(sender: AnyObject) {
        let mapController = storyboard?.instantiateViewControllerWithIdentifier("MapView") as! NearbyLocationsViewController
        // self.revealViewController().setFrontViewController(aboutController, animated: true)
        self.revealViewController().pushFrontViewController(mapController, animated: true)
        
    }
    
    
    @IBAction func openMediaScreen(sender: AnyObject) {
        let mediaController = storyboard?.instantiateViewControllerWithIdentifier("MediaController") as! MediaViewController
       
        self.revealViewController().pushFrontViewController(mediaController, animated: true)
        
    }
    
    @IBAction func openInteractWithTreesScreen(sender: AnyObject) {
        let interactController = storyboard?.instantiateViewControllerWithIdentifier("InteractWithTreesViewController") as! InteractWithTreesViewController
        
        self.revealViewController().pushFrontViewController(interactController, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openInviteFriends(sender: AnyObject) {
        //let modalViewController = ShareModalViewController()
        let shareModal = storyboard?.instantiateViewControllerWithIdentifier("InviteFriends") as! InviteFriendModalViewController
        shareModal.modalPresentationStyle = .OverCurrentContext
        self.presentViewController(shareModal, animated: true, completion: nil)        
        
    }
    
    
    
    @IBAction func openSlideMenu(sender: AnyObject) {
        //rvc.pushFrontViewController(slideViewController, animated: true)
        rvc.revealToggle(self)
    }
    
    @IBAction func openCommentsScreen(sender: AnyObject) {
        //let modalViewController = ShareModalViewController()
        let commentsViewController = storyboard?.instantiateViewControllerWithIdentifier("CommentsViewController") as! CommentsViewController
        commentsViewController.modalPresentationStyle = .OverCurrentContext
       // self.presentViewController(commentsViewController, animated: true, completion: nil)
        
       
        
        self.revealViewController().pushFrontViewController(commentsViewController, animated: true)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func unwindToMenuViewController (sender: UIStoryboardSegue){
        // sender.sourceViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
