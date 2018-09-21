//
//  HomeViewController.swift
//  InstagramClone
//
//  Created by 蔡舜珵 on 2018/9/14.
//  Copyright © 2018年 蔡舜珵. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import AlamofireImage
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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.feedCollectionView.register(UINib(nibName: "FeedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.feedCollectionView.dataSource = self
        self.feedCollectionView.delegate = self
        let databaseRef = FIRDatabase.database().reference()
        if let uid = FIRAuth.auth()?.currentUser?.uid{
            feedArray = []
            // to get the users we are following
            let myFollowingRef = databaseRef.child("following").child(uid)
            myFollowingRef.observeSingleEvent(of: .value, with: { (followingSnapshot) in
                // store values in dictionary
                let followingDictionary = followingSnapshot.value as! NSDictionary
                for(ids) in followingDictionary{
                    print(ids.value)
                    // to get the users who are following's post
                    let usersPostRef = databaseRef.child("posts").child(ids.value as! String)
                    usersPostRef.observeSingleEvent(of: .value, with: {(postSnapshot) in
                        // store values in a dictionary
                        let postDictionary = postSnapshot.value as! NSDictionary
                        for (post) in postDictionary{
                            let result = post.value as! [String: Any]
                            guard let profileUrl = result["profileImgUrl"]
                                else{return}
                            guard let username = result["username"]
                                else{return}
                            guard let postUrl = result["postImgUrl"]
                                else{return}

                            self.feedArray.append(Post(postUrl: postUrl as! String, profileUrl: profileUrl as! String, username: username as! String, likeImg: UIImage(named: "icons8-heart-outline-30")!))
                            print(self.feedArray[0].postUrl)
                        }
                        self.feedCollectionView.reloadData()
                    }, withCancel: { (error) in
                        print(error)
                    })
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

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = feedCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! FeedCollectionViewCell
        
    }
}

extension HomeViewController: FeedCollectionViewCellDelegate{
    func likeBtnControl(cell: FeedCollectionViewCell) {
        let index = (self.feedCollectionView.indexPath(for: cell)?.row)!
        if feedArray[index].likeImg.isEqual(UIImage(named: "icons8-heart-outline-30")){
            feedArray[index].likeImg = UIImage(named: "icons8-heart-30")!
            
        }else{
            feedArray[index].likeImg = UIImage(named: "icons8-heart-outline-30")!
        }
        self.feedCollectionView.reloadItems(at: [self.feedCollectionView.indexPath(for: cell)!])
    }

    func commentBtnControl(cell: FeedCollectionViewCell){

    }    
}
