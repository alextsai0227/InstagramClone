//
//  ActivityCollectionViewCell.swift
//  InstagramClone
//
//  Created by 王z on 18/10/18.
//  Copyright © 2018 蔡舜珵. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class ActivityCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var activityLable: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImg.layer.cornerRadius = 5
        profileImg.clipsToBounds = true
        // Initialization code
    }
    
    func displayContent(loggedinuid: String, uid: String, userProfileImgFrom: String, usernameFrom: String, usernameTo: String, type: String, date: String) {
        
        profileImg.sd_setImage(with: URL(string: userProfileImgFrom ), placeholderImage: UIImage(named: "placeholder"))
        
        if (loggedinuid == uid)
        {
            if (type=="L"){
                activityLable.text =  "\(usernameFrom) like's your post"
            } else{
                activityLable.text =  "\(usernameFrom) following you"
                
            }
        } else{
            if (type=="L"){
                activityLable.text =  "\(usernameFrom) like's \(usernameTo) post"
            } else{
                activityLable.text =  "\(usernameFrom) following \(usernameTo)"
            }
        }
        
        
        
    }
    
}
