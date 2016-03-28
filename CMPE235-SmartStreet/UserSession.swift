//
//  UserSession.swift
//  CMPE235-SmartStreet
//
//  Created by Shrutee Gangras on 3/23/16.
//  Copyright © 2016 Shrutee Gangras. All rights reserved.
//

import Firebase

class UserSession: NSObject {
    
    var uid  : String = ""
    var firebaseRef   : Firebase!
    
    
    
    func getUid() -> String!{
        return uid
    }
    
    
    func getFirebaseRef() -> Firebase!{
        return firebaseRef
    }


}
