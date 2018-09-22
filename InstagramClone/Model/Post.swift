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
    var postID:String
    var like_num: Int
    var uid: String
    var usersLike:Int
    
    init(postUrl: String, profileUrl: String, username: String, likeImg: UIImage, postID:String,like_num: Int,uid: String, usersLike: Int) {
        self.username = username
        self.postUrl = postUrl
        self.profileUrl = profileUrl
        self.likeImg = likeImg
        self.postID = postID
        self.like_num = like_num
        self.uid = uid
        self.usersLike = usersLike
    }
}
