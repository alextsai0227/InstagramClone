//
//  ActivityViewController.swift
//  InstagramClone
//
//  Created by 蔡舜珵 on 2018/9/14.
//  Copyright © 2018年 蔡舜珵. All rights reserved.
//

import UIKit
import Firebase

class ActivityViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource  {
    @IBOutlet weak var activityCollectionView: UICollectionView!
    let currentUserID = FIRAuth.auth()?.currentUser?.uid
    var currentUserName: String?
    let databaseRef = FIRDatabase.database().reference()
    let formatter = DateFormatter()
    var activityArray:[Activity] = []
    var usernameOf=""
    
    let dispatchGroup = DispatchGroup()
    
    @IBAction func refreshActivity(_ sender: Any) {
        self.activityArray = []
        if let uid = FIRAuth.auth()?.currentUser?.uid{
            self.fetchFollowers(uid: uid, databaseRef: self.databaseRef)
        }
        
        run(after: 5) {
            self.activityCollectionView.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        view.backgroundColor = .orange
        if let uid = FIRAuth.auth()?.currentUser?.uid{
            // fetch others activities
            fetchFollowers(uid: uid, databaseRef: databaseRef)
        }
        // Do any additional setup after loading the view.
    }
    
    func fetchFollowers(uid: String, databaseRef: FIRDatabaseReference) {
        // to get the users we are following
        let myFollowingRef = databaseRef.child("following").child(uid)
        
        myFollowingRef.observeSingleEvent(of: .value, with: { (followingSnapshot) in
            // store values in dictionary
            if let followingDictionary = followingSnapshot.value as? NSDictionary{
                for(ids) in followingDictionary{
                    let follwerDic = ids.value as? NSDictionary
                    self.fetchActivities(uid: uid, databaseRef: databaseRef, follwerDic: follwerDic!)
                }
            }
        }, withCancel: { (error) in
            print(error)
        })
    }
    
    
    func fetchActivities(uid: String, databaseRef: FIRDatabaseReference, follwerDic: NSDictionary) {
        let myActivityRef = databaseRef.child("a1").child(follwerDic["id"] as! String)
        
        myActivityRef.observeSingleEvent(of: .value, with: { (activitySnapshot) in
            
            let userRef = databaseRef.child("users").child(activitySnapshot.key)
            userRef.observeSingleEvent(of: .value, with: { (userSnapshot) in
                dump(activitySnapshot)
                if let userDictionary = userSnapshot.value as? NSDictionary{
                    if let activityDictionary = activitySnapshot.value as? NSDictionary{
                        for (activity) in activityDictionary{
                            
                            
                            let result = activity.value as! [String: Any]
                            guard let type = result["type"]
                                else{return}
                            guard let uidTo = result["uid"]
                                else{return}
                            guard let date = result["date"]
                                else{return}
                            guard let name = result["name"]
                                else{return}
                            
                            guard let userProfileImgFrom = userDictionary["profileImgUrl"]
                                else{return}
                            guard let usernameFrom  = userDictionary["username"]
                                else{return}
                            
                            self.activityArray.append(Activity(loggedinuid:uid , uid: uidTo as! String, userProfileImgFrom: userProfileImgFrom as! String, usernameFrom: usernameFrom as! String, usernameTo: name as! String, date: date as! String    , type: type as! String))
                            
                            self.activityArray = self.sortActivityArray(activityArray: self.activityArray)
                        }
                    }
                    
                    self.activityCollectionView.reloadData()
                    
                }
            })
        }, withCancel: { (error) in
            print(error)
        })
        
    }
    
    func run(after seconds: Int, completion: @escaping () -> Void){
        let deadline =  DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadline){
            completion()
        }
    }
    
    func sortActivityArray(activityArray: [Activity]) -> [Activity]{
        // sort the post by date
        let feedDates: [Date] = activityArray.map { formatter.date(from: $0.date)!
        }
        let feedTuples = zip(activityArray, feedDates)
        let sortedfeedTuples = feedTuples.sorted { $0.1 > $1.1}
        let (activityArray, _) = unzip(array: sortedfeedTuples)
        
        return activityArray
    }
    
    func unzip<T, U>(array: [(T, U)]) -> ([T], [U]) {
        var t = Array<T>()
        var u = Array<U>()
        for (a, b) in array {
            t.append(a)
            u.append(b)
        }
        return (t, u)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(String(activityArray.count) + "THIS IS THE RROW COUNT")
        return activityArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "activityCollectionViewCell", for: indexPath) as! ActivityCollectionViewCell
        
        let activity = activityArray[indexPath.row]
        print(activityArray[indexPath.row])

        print(activityArray[indexPath.row])
        
        
        cell.displayContent(loggedinuid: activity.loggedinuid, uid: activity.uid, userProfileImgFrom: activity.userProfileImgFrom,usernameFrom: activity.usernameFrom, usernameTo: activity.usernameTo, type: activity.type, date: activity.date)
        
        
        
        return cell
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

