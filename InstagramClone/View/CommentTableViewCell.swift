//
//  CommentTableViewCell.swift
//  InstagramClone
//
//  Created by 蔡舜珵 on 2018/9/22.
//  Copyright © 2018年 蔡舜珵. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var commentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImg.layer.cornerRadius = 40
        profileImg.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
