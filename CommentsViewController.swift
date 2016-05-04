//
//  CommentsViewController.swift
//  CMPE235-SmartStreet
//
//  Created by Shrutee Gangras on 3/27/16.
//  Copyright © 2016 Shrutee Gangras. All rights reserved.
//
import Firebase

class CommentsViewController: UITableViewController {
    
    var items = [PFObject]()
    
    
    var rvc : SWRevealViewController!
        
    
    @IBAction func openSlideMenu(sender: AnyObject) {
        //rvc.pushFrontViewController(slideViewController, animated: true)
        rvc.revealToggle(self)
    }

    
    @IBOutlet weak var segmentedView: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        rvc = self.revealViewController() as SWRevealViewController
        
        self.view.addGestureRecognizer(rvc.panGestureRecognizer())
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        items = [PFObject]()
        
        loadDataFromParse()
    }
    
    @IBAction func segmentedComponentValueChanged(sender: AnyObject) {
        let selectedSegmentIndex = segmentedView.selectedSegmentIndex
        if(selectedSegmentIndex == 0){
            loadDataFromParse()
        }else if(selectedSegmentIndex == 1){
            showAddCommentView()
        }else if(selectedSegmentIndex == 2){
            if let menuView = self.storyboard?.instantiateViewControllerWithIdentifier("SlideMenuConfig") as? SWRevealViewController {
                
                self.presentViewController(menuView, animated: true, completion: nil)
            }        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> CommentTableViewCell {
        
        //let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath)
        let commentTableViewCell = tableView.dequeueReusableCellWithIdentifier("CommentTableViewCell", forIndexPath: indexPath) as! CommentTableViewCell
        
        configureCell(commentTableViewCell, indexPath: indexPath)
        tableViewStyle(commentTableViewCell)
        
        return commentTableViewCell
    }
    
  
    
    // MARK:- Configure Cell
    
    func configureCell(cell: CommentTableViewCell, indexPath: NSIndexPath) {
        let dict = items[indexPath.row]
        
        cell.nameLabel?.text = dict["name"] as? String
        
        let commentDate = dict["commentDate"] as! String
        //populateTimeInterval(cell, timeInterval: dobTimeInterval)
        populateCommentDate(cell,commentDate:commentDate)
        
        let userImageFile = dict["avatarUrl"] as! PFFile
        userImageFile.getDataInBackgroundWithBlock { (data, error) in
            if error == nil{
                self.populateImage(cell, imageData: data!)
            }
        }
        
        cell.commentText.text = dict["commentText"] as! String
        
        let myString = dict["starRatings"] as! String
        let myFloat = (myString as NSString).doubleValue
        cell.starRatings.rating =  myFloat
    }
    
    
    func populateCommentDate(cell:CommentTableViewCell, commentDate:String){
        
        
        let dateformatter = NSDateFormatter()
        
        dateformatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        dateformatter.timeStyle = NSDateFormatterStyle.MediumStyle
        
        _ = dateformatter.dateFromString(commentDate)
        
        cell.commentDateLabel?.text = commentDate
    }
    
    // MARK:- Populate Timeinterval
    
    func populateTimeInterval(cell: CommentTableViewCell, timeInterval: NSTimeInterval) {
        
        let date = NSDate(timeIntervalSinceNow: timeInterval)
        let dateStr = formatDate(date)
        
        cell.detailTextLabel?.text = dateStr
    }
    
    func formatDate(date: NSDate) ->  String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let dateStr = dateFormatter.stringFromDate(date)
        return dateStr
    }
    
    // MARK:- Populate Image
    
    func populateImage(cell:CommentTableViewCell, imageData: NSData) {
        let decodedImage = UIImage(data: imageData)
        cell.profileImage!.image = decodedImage
        
        cell.profileImage!.layer.cornerRadius = cell.profileImage!.frame.size.height / 2;
        cell.profileImage!.clipsToBounds = true;
        cell.profileImage!.layer.borderWidth = 3.0
        cell.profileImage!.layer.borderColor = UIColor.whiteColor().CGColor        
    }
    
    // MARK:- Apply TableViewCell Style
    
    func tableViewStyle(cell: CommentTableViewCell) {
        //cell.contentView.backgroundColor = backgroundColor
        //cell.backgroundColor = backgroundColor
        
        cell.textLabel?.font =  UIFont(name: "HelveticaNeue-Medium", size: 15)
        cell.textLabel?.textColor = textColor
        cell.textLabel?.backgroundColor = backgroundColor
        
        cell.detailTextLabel?.font = UIFont.boldSystemFontOfSize(12)
        cell.detailTextLabel?.textColor = UIColor.grayColor()
        cell.detailTextLabel?.backgroundColor = backgroundColor
    }
    
    func loadDataFromParse(){
        let query = PFQuery(className: "Comments")        
        query.orderByDescending("commentDate")
        query.limit = 10
        
        query.findObjectsInBackgroundWithBlock {
            (results: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.items = results!
                self.tableView.reloadData()
            }
        }
    
    }
    
    
    func showAddCommentView(){
        let addCommentView = storyboard?.instantiateViewControllerWithIdentifier("AddCommentView") as! AddCommentView
        addCommentView.modalPresentationStyle = .OverCurrentContext
        //self.presentViewController(addCommentView, animated: true, completion: nil)
        
        
        self.revealViewController().pushFrontViewController(addCommentView, animated: true)
    
    }
    
    
    var textColor: UIColor {
        return UIColor(red: 63.0/255.0, green: 62.0/255.0, blue: 61.0/255.0, alpha: 1.0)
    }
    
    var backgroundColor: UIColor {
        return UIColor(red: 251.0/255.0, green: 243.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    }

}
