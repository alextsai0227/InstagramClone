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

class DiscoveryViewController: UIViewController, UISearchBarDelegate {

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText != ""){
            updateSearchResults(searchText: searchText)
        }else{
            isFilter = false
            userTableView.reloadData()
        }
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        isFilter = false
        userTableView.reloadData()
        // Remove focus from the search bar.
        searchBar.endEditing(true)
    }
    
    @IBOutlet weak var userTableView: UITableView!
    var userArr: [[String:String]] = []
    var filterArr: [[String:String]] = []
    let currentUser = FIRAuth.auth()?.currentUser
    var userProfileImgUrl:String?
    let ref = FIRDatabase.database().reference()
    var currentUserName: String?
    let formatter = DateFormatter()
    var isFilter = false
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        //   tableView delegate
        self.userTableView.delegate = self
        self.userTableView.dataSource = self
        self.userTableView.register(UINib(nibName: "UserTableViewCell",bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
        self.userTableView.estimatedRowHeight = 50
        self.userTableView.rowHeight = UITableViewAutomaticDimension
        let usersRef = ref.child("users")
        fetchUsers(usersRef: usersRef)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    
    
    func fetchUsers(usersRef: FIRDatabaseReference){
        usersRef.observeSingleEvent(of: .value, with: { (usersSnapshot) in
            // fetch users to show on the screen
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
                    // get the current user name
                    if (uid == self.currentUser?.uid){
                        self.currentUserName = username as! String
                    }
                }
            }
        }, withCancel: { (error) in
            print(error)
        })
    }
    
    
    
    func updateSearchResults(searchText: String) {
        filterArr = userArr.filter {
            print($0["username"])
            return $0["username"]!.contains(searchText)
        }
        
        isFilter = true
        userTableView.reloadData()
    }

}

extension DiscoveryViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilter{
            return filterArr.count
        }else{
            return userArr.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = userTableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as! UserTableViewCell
        cell.delegate = self
        
        if isFilter{
            cell.userName.text = filterArr[indexPath.row]["username"]
            cell.userImageView.sd_setImage(with: URL(string: filterArr[indexPath.row]["profileImg"]!), placeholderImage: UIImage(named: "placeholder"))
        }else{
            cell.userName.text = userArr[indexPath.row]["username"]
            cell.userImageView.sd_setImage(with: URL(string: userArr[indexPath.row]["profileImg"]!), placeholderImage: UIImage(named: "placeholder"))
        }

        return cell
        
    }
}


extension DiscoveryViewController: UserTableViewCellDelegate{
    func followBtnControl(cell: UserTableViewCell) {
        let dateString = formatter.string(from: Date())
        let index = (self.userTableView.indexPath(for: cell)?.row)!
        let idOfFollower = userArr[index]["uid"]
        // get the api to save data into activity
        let activityRef = ref.child("a1")
        
        // get the api to save data into followers
        let followingRef = ref.child("following")
        let followerRef = ref.child("followers")
    
        if (idOfFollower != nil){
            activityRef.child(idOfFollower!).child((currentUser?.uid)!).setValue(["type": "F","uid": currentUser?.uid, "name": currentUserName, "date": dateString])
            followingRef.child((currentUser?.uid)!).child(idOfFollower!).setValue(["id": idOfFollower])
            
                followerRef.child(idOfFollower!).child((currentUser?.uid)!
                    ).setValue(["id": (currentUser?.uid)!])
        }
        
        
    }
}
