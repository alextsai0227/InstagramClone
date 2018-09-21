//
//  FeedCollectionViewCell.swift
//  InstagramClone
//
//  Created by 蔡舜珵 on 2018/9/18.
//  Copyright © 2018年 蔡舜珵. All rights reserved.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var displayLikeLabel: UILabel!
    @IBOutlet weak var displayLikeBtn: UIButton!
    @IBOutlet weak var displayCommentLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        likeBtn.setImage(UIImage(named: "icons8-heart-outline-30")!, for: .normal)
        // Initialization code
    }
    @IBAction func likeBtn_TouchUpInside(_ sender: Any) {

        if likeBtn.currentImage!.isEqual(UIImage(named: "icons8-heart-outline-30")){
            likeBtn.setImage(UIImage(named: "icons8-heart-30")!, for: .normal)
            
        }else{
            likeBtn.setImage(UIImage(named: "icons8-heart-outline-30")!, for: .selected)
        }
    }
    @IBAction func comment_TouchUpInside(_ sender: Any) {
    
    }
    
}
