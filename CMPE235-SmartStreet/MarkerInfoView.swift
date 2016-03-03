//
//  MarkerInfoView.swift
//  CMPE235-SmartStreet
//
//  Created by Shrutee Gangras on 2/29/16.
//  Copyright © 2016 Shrutee Gangras. All rights reserved.
//
import UIKit
protocol MarkerInfoViewDelegate: class {
    func getDirections()
}


class MarkerInfoView: UIView {
    
    weak var delegate:MarkerInfoViewDelegate!
    
    @IBOutlet weak var placePhoto: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    

    
    @IBOutlet weak var placeAddress: UILabel!
    
    @IBAction func calculateDirections(sender: AnyObject) {
        print("get direction pressed")
          delegate?.getDirections()
    }
}
