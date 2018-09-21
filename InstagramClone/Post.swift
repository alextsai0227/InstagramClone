//
//  Post.swift
//  InstagramClone
//
//  Created by 蔡舜珵 on 2018/9/19.
//  Copyright © 2018年 蔡舜珵. All rights reserved.
//

import Foundation
import UIKit
class Post{
    var postUrl: String
    var profileUrl:String
    var username:String
    var likeImg:UIImage
    
    init(postUrl: String, profileUrl: String, username: String, likeImg: UIImage) {
        self.username = username
        self.postUrl = postUrl
        self.profileUrl = profileUrl
        self.likeImg = likeImg
    }
}
