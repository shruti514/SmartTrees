//
//  CommentTableViewCell.swift
//  CMPE235-SmartStreet
//
//  Created by Shrutee Gangras on 3/27/16.
//  Copyright © 2016 Shrutee Gangras. All rights reserved.
//
import Cosmos

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var commentDateLabel: UILabel!

    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var commentText: UITextView!
    
    @IBOutlet weak var starRatings: CosmosView!
    
}
