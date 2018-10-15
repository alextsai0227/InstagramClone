//
//  DiscoveryViewController.swift
//  InstagramClone
//
//  Created by 蔡舜珵 on 2018/9/14.
//  Copyright © 2018年 蔡舜珵. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import SDWebImage

class DiscoveryViewController: UIViewController {

    @IBOutlet weak var userTableView: UITableView!
    var userArr: [[String:String]] = []
    let currentUser = FIRAuth.auth()?.currentUser
    var userProfileImgUrl:String?
    let ref = FIRDatabase.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        //   tableView delegate
        self.userTableView.delegate = self
        self.userTableView.dataSource = self
        self.userTableView.register(UINib(nibName: "UserTableViewCell",bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
        self.userTableView.estimatedRowHeight = 50
        self.userTableView.rowHeight = UITableViewAutomaticDimension
        let usersRef = ref.child("users")
        usersRef.observeSingleEvent(of: .value, with: { (usersSnapshot) in
            // store values in dictionary
            print("========usersSnapshot===========")
            print(usersSnapshot.value)
            if let usersDictionary = usersSnapshot.value as? NSDictionary{
                print("========usersDictionary===========")
                print(usersDictionary)
                for(user) in usersDictionary{
                    print("========usersDictionary===========")
                    print(user.key)
                    print(user.value)
                    let userResult = user.value as! [String: Any]
                    let uid = user.key as! String
                    let profileUrl = userResult["profileImgUrl"]
                    let username = userResult["username"]
                    if (profileUrl != nil && username != nil && uid != self.currentUser?.uid){
                        self.userArr.append(["uid": uid ,"username": username as! String, "profileImg": profileUrl as! String])
                        self.userTableView.reloadData()
                    }

                }
            }
        }, withCancel: { (error) in
            print(error)
        })
        
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension DiscoveryViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = userTableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as! UserTableViewCell
        cell.delegate = self
        cell.userName.text = userArr[indexPath.row]["username"]
        cell.userImageView.sd_setImage(with: URL(string: userArr[indexPath.row]["profileImg"]!), placeholderImage: UIImage(named: "placeholder"))
        return cell
        
    }
}


extension DiscoveryViewController: UserTableViewCellDelegate{
    func followBtnControl(cell: UserTableViewCell) {
        
        let index = (self.userTableView.indexPath(for: cell)?.row)!
        
        // get the api to save data into followers
        let followingRef = ref.child("followers")
        let idOfFollower = userArr[index]["uid"]
        if (idOfFollower != nil){
            followingRef.child((currentUser?.uid)!).childByAutoId().setValue(["id": idOfFollower])
        }
    }
}
