//
//  CommentsViewController.swift
//  CMPE235-SmartStreet
//
//  Created by Shrutee Gangras on 3/27/16.
//  Copyright © 2016 Shrutee Gangras. All rights reserved.
//
import Firebase

class CommentsViewController: UITableViewController {
    
    let refUrl = Firebase(url: "https://sweltering-inferno-8277.firebaseio.com/")
    let commentsRef = Firebase(url: "https://sweltering-inferno-8277.firebaseio.com/comments")
    var items = [NSDictionary]()
    
    @IBOutlet weak var segmentedView: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        items = [NSDictionary]()
        
        loadDataFromFirebase()
    }
    
    @IBAction func segmentedComponentValueChanged(sender: AnyObject) {
        let selectedSegmentIndex = segmentedView.selectedSegmentIndex
        if(selectedSegmentIndex == 0){
            loadDataFromFirebase()
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
        
        let base64String = dict["avatarUrl"] as! String
        populateImage(cell, imageString: base64String)
        
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
    
    func populateImage(cell:CommentTableViewCell, imageString: String) {
        
        let decodedData = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        
        let decodedImage = UIImage(data: decodedData!)
        
        cell.imageView!.layer.cornerRadius = cell.imageView!.frame.size.height / 2;
        cell.imageView!.clipsToBounds = true;
        cell.imageView!.layer.borderWidth = 3.0
        cell.imageView!.layer.borderColor = UIColor.whiteColor().CGColor
        cell.imageView!.contentMode = .ScaleAspectFit
        
        cell.imageView!.image = decodedImage
        
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
    
    // MARK:- Load data from Firebase
    
    func loadDataFromFirebase() {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
//        commentsRef.queryOrderedByChild("commentDate").observeEventType(.ChildAdded, withBlock: { snapshot in
//            if let commentDate = snapshot.value["commentDate"] as? String {
//                print("\(snapshot.key) was \(commentDate) ")
//            }
//        })
        
        
        commentsRef.observeEventType(.Value, withBlock: { snapshot in
            var tempItems = [NSDictionary]()
            
            for item in snapshot.children {
                let child = item as! FDataSnapshot
                let dict = child.value as! NSDictionary
                tempItems.append(dict)
            }
            
            self.items = tempItems
            self.tableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
        })
    }
    
    
    func showAddCommentView(){
        let addCommentView = storyboard?.instantiateViewControllerWithIdentifier("AddCommentView") as! AddCommentView
        addCommentView.modalPresentationStyle = .OverCurrentContext
        self.presentViewController(addCommentView, animated: true, completion: nil)
    
    }
    
    
    var textColor: UIColor {
        return UIColor(red: 63.0/255.0, green: 62.0/255.0, blue: 61.0/255.0, alpha: 1.0)
    }
    
    var backgroundColor: UIColor {
        return UIColor(red: 251.0/255.0, green: 243.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    }

}
