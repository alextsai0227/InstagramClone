//
//  UserTableViewCell.swift
//  InstagramClone
//
//  Created by 蔡舜珵 on 2018/10/15.
//  Copyright © 2018年 蔡舜珵. All rights reserved.
//
@objc protocol UserTableViewCellDelegate: class{
    
    func followBtnControl(cell: UserTableViewCell)
}


import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    weak var delegate: UserTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = 40
        userImageView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func followBtn_TouchUpInside(_ sender: Any) {
        print("followBtn_TouchUpInside")
        delegate?.followBtnControl(cell: self)
    }
    
    
}
