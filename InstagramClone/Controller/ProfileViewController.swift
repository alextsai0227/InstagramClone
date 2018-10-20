//
//  ProfileViewController.swift
//  InstagramClone
//
//  Created by 蔡舜珵 on 2018/9/14.
//  Copyright © 2018年 蔡舜珵. All rights reserved.
//



import UIKit
import Firebase
import SDWebImage
import MultipeerConnectivity


class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var numberOfPosts: UILabel!
    @IBOutlet weak var displayImage: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var numberOfFollowers: UILabel!
    @IBOutlet weak var postsDisplay: UILabel!
    @IBOutlet weak var followingDisplay: UILabel!
    @IBOutlet weak var followersDisplay: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pictures: UILabel!
    @IBOutlet weak var numberOfFollowing: UILabel!
    let formatter = DateFormatter()
    var feedArray = [Post]()
    let uid = FIRAuth.auth()?.currentUser?.uid
    let databaseRef = FIRDatabase.database().reference()
    let currentUserID = FIRAuth.auth()?.currentUser?.uid
    let username = FIRAuth.auth()?.currentUser?.uid
    var isFinishedPaging = false
    let cellId = "cellId"
    var posts = [Post]()
    let feedPostCellId = "feedPostCellId"
    var isGridView = true
    var user: User?
    var postDict: [String: Any] = ["a":1]
    var imageurls:[String] = [""]
    let cellIdentifier = "cell"
    let ref = FIRDatabase.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let uid = FIRAuth.auth()?.currentUser?.uid{
            let usersRef = ref.child("users").child(uid)
            usersRef.observeSingleEvent(of: .value, with: { (usersSnapshot) in
                if let usersDictionary = usersSnapshot.value as? NSDictionary{
                    
                    self.displayName.text = usersDictionary["username"] as! String
                    self.displayImage.sd_setImage(with: URL(string: usersDictionary["profileImgUrl"] as! String), placeholderImage: UIImage(named: "placeholder"))
                }
                
            })
            
            self.fetchPostUsers(uid: uid, databaseRef: databaseRef, follwerDic: ["id" : uid])
            self.fetchingDetails(uid: uid, databaseRef: databaseRef)
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
            self.collectionView.reloadData()
            self.collectionView.register(UINib(nibName: "NewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
            
        }
    }
    
    
    //displayName.text = username1
    //fetching all details from database to display in the profile view
    func fetchingDetails(uid: String, databaseRef: FIRDatabaseReference){
        let myFollowingRef = databaseRef.child("following").child(uid)
        myFollowingRef.observeSingleEvent(of: .value, with: { (followingSnapshot) in
            // store values in dictionary
            if let followingDictionary = followingSnapshot.value as? NSDictionary{
                self.followingDisplay.text = String(followingDictionary.count)
                let myFollowersRef = self.databaseRef.child("followers"
                    ).child(self.uid!)
                myFollowersRef.observeSingleEvent(of: .value, with:
                    { (followersSnapshot) in
                        if let followersDictionary = followersSnapshot.value as? NSDictionary{
                            self.followersDisplay.text = String(followersDictionary.count)}
                })
                
                let usersPostRef = self.databaseRef.child("posts").child(self.uid!)
                usersPostRef.observeSingleEvent(of: .value, with:
                    {(userSnapshot) in
                        if let userDictionary = userSnapshot.value as? NSDictionary{
                            self.postsDisplay.text = String(userDictionary.count)}
                })
            }
            
        })
    }
    
    
    //fetching posts from the user.
    func fetchPostUsers(uid: String, databaseRef: FIRDatabaseReference, follwerDic: NSDictionary) {
        // to get the users who are following's post
        let usersPostRef = databaseRef.child("posts").child(follwerDic["id"] as! String)
        
        usersPostRef.observeSingleEvent(of: .value, with: {(postSnapshot) in
            
            // store values in a dictionary
            if let postDictionary = postSnapshot.value as? NSDictionary{
                for (post) in postDictionary{
                    let result = post.value as! [String: Any]
                    
                    let users_like = result["users_like"] as? NSDictionary
                    var num_users_like = 0
                    if (users_like != nil) {
                        num_users_like = (users_like?.count)!
                    }
                    guard let profileUrl = result["profileImgUrl"]
                        else{return}
                    guard let username = result["username"]
                        else{return}
                    guard let postUrl = result["postImgUrl"]
                        else{return}
                    guard let likeNum = result["like"]
                        else{return}
                    guard let date = result["date"]
                        else{return}
                    
                    let like_num = likeNum as? String
                    self.feedArray.append(Post(postUrl: postUrl as! String, profileUrl: profileUrl as! String, username: username as! String, likeImg: UIImage(named: "icons8-heart-outline-30")!, postID: post.key as! String, like_num: Int(like_num!)!, uid: follwerDic["id"] as! String, usersLike: num_users_like, date: date as! String))
                    // sort the post by date

                    self.getImageURLs()
                }
                
                self.collectionView.reloadData()
            }
            
        }, withCancel: { (error) in
            print(error)
        })
    }
    func getImageURLs(){
        for i in feedArray{
            self.imageurls.append(i.postUrl)
        }
    }
    
    
    //to display the grid view (collection view) of all the users posts.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    /*func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     return posts.count
     }*/
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == self.posts.count - 1 && !isFinishedPaging {
            print("Paginating for posts...")
            //paginatePost()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! NewCollectionViewCell
        //cell.post = posts[indexPath.item]
        cell.backgroundColor = UIColor.black
        //cell.setImageURL(url: imageurls[indexPath.item])
        cell.imageView.sd_setImage(with: URL(string: feedArray[indexPath.row].postUrl), placeholderImage: UIImage(named: "placeholder"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("====sizeForItemAt=====")
        
        return CGSize(width: self.view.frame.width, height: self.collectionView.frame.height / 5)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("====feedArray=======")
        print(feedArray.count)
        return feedArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.collectionView.cellForItem(at: indexPath) as! NewCollectionViewCell
        
        let sendVC = storyboard?.instantiateViewController(withIdentifier: "SendViewController") as! SendViewController
        print("=======self.feedArray[indexPath.row].postUrl====")
        print(self.feedArray[indexPath.row].postUrl)
        sendVC.url = self.feedArray[indexPath.row].postUrl
        self.present(sendVC, animated: true, completion: nil)
    }
    
    //to display the user profile picture.
    func displayProfileImage(uid: String, databaseRef: FIRDatabaseReference){
        self.fetchPostUsers(uid: uid, databaseRef: databaseRef, follwerDic: ["id" : uid])
        displayImage.image = UIImage(named: "profileUrl")
    }
}


