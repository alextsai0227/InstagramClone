//
//  User.swift
//  InstagramClone
//
//  Created by 蔡舜珵 on 2018/9/19.
//  Copyright © 2018年 蔡舜珵. All rights reserved.
//

import Foundation
class User{
    var email:String
    var photo:String
    var username:String
    
    init(email: String, photo: String, username: String) {
        self.username = username
        self.email = email
        self.photo = photo
    }
}
