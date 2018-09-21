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
    var postUrl: UIImage
    var profileUrl:UIImage
    var username:String
    
    init(postUrl: UIImage, profileUrl: UIImage, username: String) {
        self.username = username
        self.postUrl = postUrl
        self.profileUrl = profileUrl
    }
}
