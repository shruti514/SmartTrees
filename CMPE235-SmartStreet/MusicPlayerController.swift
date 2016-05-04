//
//  MusicPlayerController.swift
//  CMPE235-SmartStreet
//
//  Created by Shrutee Gangras on 4/29/16.
//  Copyright © 2016 Shrutee Gangras. All rights reserved.
//

//
//  MusicPlayerController.swift
//  ParseStarterProject-Swift
//
//  Created by Shrutee Gangras on 4/25/16.
//  Copyright © 2016 Parse. All rights reserved.
//
import UIKit
import Parse

class MusicPlayerController: UITableViewController {
    
    var rvc : SWRevealViewController!
   
    @IBAction func home(sender: AnyObject) {
        if let menuView = self.storyboard?.instantiateViewControllerWithIdentifier("SlideMenuConfig") as? SWRevealViewController {
            
            self.presentViewController(menuView, animated: true, completion: nil)
        }
    }

    
    @IBAction func openSlideMenu(sender: AnyObject) {
        //rvc.pushFrontViewController(slideViewController, animated: true)
        rvc.revealToggle(self)
    }

    var items = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //rvc = self.revealViewController() as SWRevealViewController
        
       // self.view.addGestureRecognizer(rvc.panGestureRecognizer())
        // Do any additional setup after loading the view.

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        items = [PFObject]()
        
        loadDataFromParse()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadDataFromParse(){
        let query = PFQuery(className: "AudioFiles")
        query.orderByDescending("MusicDescription")
        query.limit = 10
        
        query.findObjectsInBackgroundWithBlock {
            (results: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.items = results!
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func navigateToHome(sender: AnyObject) {
        if let menuView = self.storyboard?.instantiateViewControllerWithIdentifier("SlideMenuConfig") as? SWRevealViewController {
            
            self.presentViewController(menuView, animated: true, completion: nil)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> MusicPlayerCell {
        
        //let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath)
        let musicPlayerTableViewCell = tableView.dequeueReusableCellWithIdentifier("MusicPlayerCell", forIndexPath: indexPath) as! MusicPlayerCell
        
        configureCell(musicPlayerTableViewCell, indexPath: indexPath)
        
        
        return musicPlayerTableViewCell
    }
    
    
    // MARK:- Configure Cell
    
    func configureCell(cell: MusicPlayerCell, indexPath: NSIndexPath) {
        let dict = items[indexPath.row]
        
        cell.titleLabel?.text = dict["MusicDescription"] as? String
        cell.musicId = dict["MusicId"] as? String
        
    }
    
    
}

