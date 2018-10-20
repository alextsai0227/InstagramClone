//
//  Activity.swift
//  InstagramClone
//
//  Created by 王z on 2018/10/15.
//  Copyright © 2018年 蔡舜珵. All rights reserved.
//

import Foundation
import UIKit
class Activity {
    var loggedinuid:String
    var uid:String
    var userProfileImgFrom: String
    var usernameFrom:String
    var usernameTo:String
    var date:String
    var type:String
    
    init(loggedinuid: String, uid:String, userProfileImgFrom: String, usernameFrom:String, usernameTo: String, date:String, type:String) {
        self.loggedinuid = loggedinuid
        self.uid = uid
        self.userProfileImgFrom = userProfileImgFrom
        self.usernameFrom = usernameFrom
        self.usernameTo = usernameTo
        self.date = date
        self.type = type
    }
}
