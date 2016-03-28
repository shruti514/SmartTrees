//
//  Comment.swift
//  CMPE235-SmartStreet
//
//  Created by Shrutee Gangras on 3/19/16.
//  Copyright © 2016 Shrutee Gangras. All rights reserved.
//

import AWSDynamoDB
//import AWSDynamoDBObjectModel

class Comment:  AWSDynamoDBObjectModel, AWSDynamoDBModeling{
    var email  : String = ""
    var date   : String = ""
    var note   : String = ""
    var number : Double = 0.0

    
    static func dynamoDBTableName() -> String!{
        return "Comments"
    }
    
   
    
    static func hashKeyAttribute() -> String!{
        return "commentId"
    }
}
