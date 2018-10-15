//
//  HomeViewController.swift
//  InstagramClone
//
//  Created by 蔡舜珵 on 2018/9/14.
//  Copyright © 2018年 蔡舜珵. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var feedCollectionView: UICollectionView!
    var feedArray = [Post]()
    var profileArr = [UIImage]()
    var postArr = [UIImage]()
    let cellIdentifier = "cell"
    var profileImg:UIImage?
    var postImg:UIImage?
    var rowAtIndexPath = 0
    let currentUserID = FIRAuth.auth()?.currentUser?.uid
    var currentUserName: String?
    var userWhoLikes: [String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.feedCollectionView.register(UINib(nibName: "FeedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.feedCollectionView.dataSource = self
        self.feedCollectionView.delegate = self
        let databaseRef = FIRDatabase.database().reference()
        if let uid = FIRAuth.auth()?.currentUser?.uid{
            feedArray = []
            // to get the users we are following
            let myFollowingRef = databaseRef.child("followers").child(uid)
            myFollowingRef.observeSingleEvent(of: .value, with: { (followingSnapshot) in
                // store values in dictionary
                
                if let followingDictionary = followingSnapshot.value as? NSDictionary{
                    for(ids) in followingDictionary{
                        print(ids.value)
                        let follwerDic = ids.value as? NSDictionary
                        // to get the users who are following's post
                        let usersPostRef = databaseRef.child("posts").child(follwerDic!["id"] as! String)
                        print("========test===========")
                        print(ids.value)
                        
                        usersPostRef.observeSingleEvent(of: .value, with: {(postSnapshot) in
                            // store values in a dictionary
                            if let postDictionary = postSnapshot.value as? NSDictionary{
                                for (post) in postDictionary{
                                    let result = post.value as! [String: Any]
                                    print("=======loook==========")
                                    print(result["users_like"])
                                    var users_like = result["users_like"] as? NSDictionary
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
                                    //                            usersPostRef.child(post.key as! String).child("users_like").child("users").observeSingleEvent(of: .value, with: {(userslikeSnapshot) in
                                    //                                print("==========seee==========")
                                    //                                print(userslikeSnapshot.value)
                                    //                            })
                                    //                            print("==========postttttt==========")
                                    let like_num = likeNum as? String
                                    self.feedArray.append(Post(postUrl: postUrl as! String, profileUrl: profileUrl as! String, username: username as! String, likeImg: UIImage(named: "icons8-heart-outline-30")!, postID: post.key as! String, like_num: Int(like_num!)!, uid: follwerDic!["id"] as! String, usersLike: num_users_like))
                                }
                                self.feedCollectionView.reloadData()
                            }
                            
                        }, withCancel: { (error) in
                            print(error)
                        })
                    }
                }
            }, withCancel: { (error) in
                print(error)
            })

        }
       
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logout_TouchUpInside(_ sender: Any) {
        do{
            try FIRAuth.auth()?.signOut()
        }catch let logoutErr{
            print(logoutErr)
        }
        
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.present(signInVC, animated: true, completion: nil)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(feedArray.count)
        return feedArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.feedCollectionView.frame.height, height: self.feedCollectionView.frame.height / 5)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = feedCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! FeedCollectionViewCell
        
        cell.delegate = self
        cell.profileImg.sd_setImage(with: URL(string: feedArray[indexPath.row].profileUrl), placeholderImage: UIImage(named: "placeholder"))
        cell.postImageView.sd_setImage(with: URL(string: feedArray[indexPath.row].postUrl), placeholderImage: UIImage(named: "placeholder"))
        cell.likeBtn.setImage(feedArray[indexPath.row].likeImg, for: .normal)
        cell.usernameLabel.text = feedArray[indexPath.row].username
        // show likes
        if (feedArray[indexPath.row].like_num != 0){
            cell.displayLikeLabel.text = String(feedArray[indexPath.row].like_num) + " likes"
        }else{
            cell.displayLikeLabel.text = "no one likes yet"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = feedCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! FeedCollectionViewCell
        
    }
}

extension HomeViewController: FeedCollectionViewCellDelegate{
    func likeBtnControl(cell: FeedCollectionViewCell) {
        
        let index = (self.feedCollectionView.indexPath(for: cell)?.row)!
        
        // find who likes or dislikes the post
        let userRef = FIRDatabase.database().reference().child("users").child(currentUserID!)
        userRef.observeSingleEvent(of: .value, with: {(usersSnapshot) in
            let userdata = usersSnapshot.value as! NSDictionary
            self.currentUserName = userdata["username"] as? String
        })
        
        // postRef
        let postRef = FIRDatabase.database().reference().child("posts").child(feedArray[index].uid).child(feedArray[index].postID);
        
        // usersLikeRef
        let usersLikeRef = postRef.child("users_like")
        if feedArray[index].likeImg.isEqual(UIImage(named: "icons8-heart-outline-30")){
            feedArray[index].likeImg = UIImage(named: "icons8-heart-30")!
            feedArray[index].like_num += 1
           
            // save who likes to post data
            usersLikeRef.updateChildValues([currentUserID!: currentUserName as Any])
        }else{
            feedArray[index].likeImg = UIImage(named: "icons8-heart-outline-30")!
            feedArray[index].like_num -= 1
            
            // delete who dislike the post
            usersLikeRef.child(currentUserID!).removeValue()
        }
        
        // update likes
        let likeNum_string = String(feedArray[index].like_num)
        postRef.updateChildValues(["like": likeNum_string])
        
        
        self.feedCollectionView.reloadItems(at: [self.feedCollectionView.indexPath(for: cell)!])
    }

    func commentBtnControl(cell: FeedCollectionViewCell){
        rowAtIndexPath = (self.feedCollectionView.indexPath(for: cell)?.row)!
        let index = (self.feedCollectionView.indexPath(for: cell)?.row)!
        
        let naviDisplayUsersVC = storyboard?.instantiateViewController(withIdentifier: "NaviToComment") as! UINavigationController
        let commentsVC = naviDisplayUsersVC.viewControllers.first as? CommentViewController
        
        // usersLikeRef
        let usersCommentRef = FIRDatabase.database().reference().child("posts").child(feedArray[index].uid).child(feedArray[index].postID).child("comments");
        
        usersCommentRef.observeSingleEvent(of: .value, with: {(usersSnapshot) in
            
            if let a = usersSnapshot.value as? NSNull{
                
            }else{
            // get all the comments for related post.
                let users = usersSnapshot.value as! NSDictionary
                var i = 0
                print(users)
                users.allValues
                if (users != nil){
                    while i < users.count{
                        commentsVC?.commentArr.append(users.allValues[i] as! [String : String])
                        i = i + 1
                    }
                }
            }
            commentsVC?.postUID = self.feedArray[index].uid
            commentsVC?.postID = self.feedArray[index].postID
            self.present(naviDisplayUsersVC, animated: true, completion: nil)
        })
    
    }
    
    func displayBtnControl(cell: FeedCollectionViewCell){
        rowAtIndexPath = (self.feedCollectionView.indexPath(for: cell)?.row)!
        let index = (self.feedCollectionView.indexPath(for: cell)?.row)!

        let naviDisplayUsersVC = storyboard?.instantiateViewController(withIdentifier: "NaviToDisplay") as! UINavigationController
        let displayUsersVC = naviDisplayUsersVC.viewControllers.first as? DisplayUsersTableViewController
        // usersLikeRef
        let usersLikeRef = FIRDatabase.database().reference().child("posts").child(feedArray[index].uid).child(feedArray[index].postID).child("users_like");

        usersLikeRef.observeSingleEvent(of: .value, with: {(usersSnapshot) in
            if let users = usersSnapshot.value as? NSDictionary {
                displayUsersVC?.list = users.allValues as? [String]
                print(users.allValues)
                print(displayUsersVC?.list)
                self.present(naviDisplayUsersVC, animated: true, completion: nil)
            }
        })
    }
}
