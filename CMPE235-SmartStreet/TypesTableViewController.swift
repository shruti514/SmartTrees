//
//  TypesTableViewController.swift
//  CMPE235-SmartStreet
//
//  Created by Shrutee Gangras on 2/29/16.
//  Copyright © 2016 Shrutee Gangras. All rights reserved.
//

import UIKit


protocol TypesTableViewControllerDelegate: class {
    func typesController(controller: TypesTableViewController, didSelectTypes types: [String])
}

class TypesTableViewController: UITableViewController {
    
    let possibleTypesDictionary = ["bakery":"Bakery", "bar":"Bar", "cafe":"Cafe", "grocery_or_supermarket":"Supermarket", "restaurant":"Restaurant"]
    var selectedTypes: [String] = [];
    
    weak var delegate: TypesTableViewControllerDelegate!
    var sortedKeys: [String] {
        return possibleTypesDictionary.keys.sort()
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        delegate?.typesController(self, didSelectTypes: selectedTypes)
    }
  
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return possibleTypesDictionary.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TypeCell", forIndexPath: indexPath)
        let key = sortedKeys[indexPath.row]
        let type = possibleTypesDictionary[key]!
        cell.textLabel?.text = type
        cell.imageView?.image = UIImage(named: key)
        cell.accessoryType = (selectedTypes).contains(key) ? .Checkmark : .None
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let key = sortedKeys[indexPath.row]
        if (selectedTypes).contains(key) {
            selectedTypes = selectedTypes.filter({$0 != key})
        } else {
            selectedTypes.append(key)
        }
        
        tableView.reloadData()
    }
}



