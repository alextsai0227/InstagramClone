//
//  HomeViewController.swift
//  InstagramClone
//
//  Created by 蔡舜珵 on 2018/9/14.
//  Copyright © 2018年 蔡舜珵. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var feedCollectionView: UICollectionView!
    var feedArray = [Post(postUrl: "https://fakeimg.pl/600x600/", profileUrl: "https://fakeimg.pl/600x600/", username: "test"),Post(postUrl: "https://fakeimg.pl/600x600/", profileUrl: "https://fakeimg.pl/600x600/", username: "test"),Post(postUrl: "https://fakeimg.pl/600x600/", profileUrl: "https://fakeimg.pl/600x600/", username: "test"),Post(postUrl: "https://fakeimg.pl/600x600/", profileUrl: "https://fakeimg.pl/600x600/", username: "test"),Post(postUrl: "https://fakeimg.pl/600x600/", profileUrl: "https://fakeimg.pl/600x600/", username: "test"),Post(postUrl: "https://fakeimg.pl/600x600/", profileUrl: "https://fakeimg.pl/600x600/", username: "test"),Post(postUrl: "https://fakeimg.pl/600x600/", profileUrl: "https://fakeimg.pl/600x600/", username: "test")]
    let cellIdentifier = "cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.feedCollectionView.register(UINib(nibName: "FeedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.feedCollectionView.dataSource = self
        self.feedCollectionView.delegate = self
//        let databaseRef = FIRDatabase.database().reference()
//        if let uid = FIRAuth.auth()?.currentUser?.uid{
//            // to get the users we are following
//            let myFollowingRef = databaseRef.child("following").child(uid)
//            myFollowingRef.observe(.value, with: { (followingSnapshot) in
//                // store values in dictionary
//                let followingDictionary = followingSnapshot.value as! NSDictionary
//                for(id, _) in followingDictionary{
//                    // to get the users who are following's post
//                    let usersPostRef = databaseRef.child("post").child(id as! String)
//                    usersPostRef.observe(.value, with: {(postSnapshot) in
//                        // store values in a dictionary
//                        let postDictionary = postSnapshot.value as! NSDictionary
//                        for (p) in postDictionary{
//                            let posts = p.value as! NSDictionary
//
//                            guard let profileUrl = posts.value(forKey: "profile_pic")
//                                else{return}
//                            guard let username = posts.value(forKey: "username")
//                                else{return}
//                            guard let postUrl = posts.value(forKey: "posted_pic")
//                                else{return}
//                            self.feedArray.append(Post(postUrl: postUrl as! String, profileUrl: profileUrl as! String, username: username as! String))
//                        }
//                    }, withCancel: { (error) in
//                        print(error)
//                    })
//                }
//            }, withCancel: { (error) in
//                print(error)
//            })
//        }
        
        
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
        return feedArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.feedCollectionView.frame.height, height: self.feedCollectionView.frame.height / 5)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = feedCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! FeedCollectionViewCell
       
        let profileUrl = URL(string: feedArray[indexPath.row].profileUrl)
        if let profileData = try? Data(contentsOf: profileUrl!)
        {
            cell.profileImg.image = UIImage(data: profileData)!
        }
        
        let postUrl = URL(string: feedArray[indexPath.row].postUrl)
        if let postData = try? Data(contentsOf: postUrl!)
        {
            cell.postImageView.image = UIImage(data: postData)!
        }
        cell.usernameLabel.text = feedArray[indexPath.row].username
        
        return cell
    }
}
