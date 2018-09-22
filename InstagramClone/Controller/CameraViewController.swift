//
//  CameraViewController.swift
//  InstagramClone
//
//  Created by 蔡舜珵 on 2018/9/14.
//  Copyright © 2018年 蔡舜珵. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage



class CameraViewController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var postImageView: UIImageView!
    let picker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CameraViewController.editPhoto))
        postImageView.addGestureRecognizer(tapGesture)
        postImageView.isUserInteractionEnabled = true
    }

    @objc func editPhoto(imageView: UIImageView){
        self.performSegue(withIdentifier: "CameraToEditPhoto", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CameraToEditPhoto" {
            let controller = segue.destination as! EditPhotoViewController
            controller.originalImageView = postImageView as? UIImageView
        }
    }
    
    @IBAction func takePhoto_TouchUpInside(_ sender: Any) {
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil{
            picker.allowsEditing = true
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
        }else{
            noCamera()
        }
        
    }
    
    func noCamera(){
        let alertVC = UIAlertController(title: "Warning", message: "The device has no camera", preferredStyle: .alert)
        let okActino = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(okActino)
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func choosePhoto_TouchUpInside(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            postImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func savePost(_ sender: Any) {
        let storageRef = FIRStorage.storage().reference(forURL: "gs://instagramclone-94872.appspot.com").child("post_image").child(randomString(length: 32))
        if let postImg = self.postImageView.image, let imageData = UIImageJPEGRepresentation(postImg, 0.1){
            storageRef.put(imageData, metadata: nil, completion: {(metadata, err) in
                if err != nil {
                    return
                }
                let postImageUrl = metadata?.downloadURL()?.absoluteString
                let uid = FIRAuth.auth()?.currentUser?.uid
                let ref = FIRDatabase.database().reference()
                let userReference = ref.child("users").child(uid!)
                userReference.observe(.value, with: {(userSnapshot) in
                    // store values in a dictionary
                    let userDictionary = userSnapshot.value as! NSDictionary
                    print(userDictionary)
                    
                    let username = userDictionary["username"] as? String ?? ""
                    let profileImg = userDictionary["profileImgUrl"] as? String ?? ""
                    
                    let postReference = ref.child("posts")
                    let newPostReference = postReference.child(uid!).childByAutoId()
                    newPostReference.setValue(["username": username, "profileImgUrl": profileImg, "postImgUrl": postImageUrl,"like": "0"])
                }, withCancel: { (error) in
                    print(error)
                })
                
            })
        }
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
}

