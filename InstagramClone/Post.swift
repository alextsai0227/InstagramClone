//
//  Post.swift
//  InstagramClone
//
//  Created by 蔡舜珵 on 2018/9/19.
//  Copyright © 2018年 蔡舜珵. All rights reserved.
//

import Foundation
class Post{
    var postUrl:String
    var profileUrl:String
    var username:String
    
    init(postUrl: String, profileUrl: String, username: String) {
        self.username = username
        self.postUrl = postUrl
        self.profileUrl = profileUrl
    }
}
