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
import AGImageControls
import CropViewController

class CameraViewController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate, AGCameraSnapViewControllerDelegate, CropViewControllerDelegate {
    @IBOutlet weak var postImageView: UIImageView!
    let picker = UIImagePickerController()
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        postImageView.image = UIImage(named: "placeholder")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }

    // Screen width.
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    // Screen height.
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    @IBAction func takePhoto_TouchUpInside(_ sender: Any) {
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil{
            let camera = AGCameraSnapViewController()
            camera.delegate = self
            // add gridview on camera
            let gridView = GridView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), columns: 3)
            gridView.isUserInteractionEnabled = false
            camera.view.addSubview(gridView)
            self.present(camera, animated: true, completion: nil)
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
  
    func presentCropViewController() {
        if self.postImageView.image != nil{
            let image: UIImage = self.postImageView.image!
            let cropViewController = CropViewController(image: image)
            cropViewController.delegate = self
            present(cropViewController, animated: true, completion: nil)
        }
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        // 'image' is the newly cropped version of the original image
        self.postImageView.image = image
    }
    
    @IBAction func choosePhoto_TouchUpInside(_ sender: Any) {
        presentCropViewController()
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
        let dateString = formatter.string(from: Date())
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
                print(uid!)
                userReference.observe(.value, with: {(userSnapshot) in
                    // store values in a dictionary
                    if let userDictionary = userSnapshot.value as? NSDictionary{
                        print(userDictionary)
                        
                        let username = userDictionary["username"] as? String ?? ""
                        let profileImg = userDictionary["profileImgUrl"] as? String ?? ""
                        
                        let postReference = ref.child("posts")
                        let newPostReference = postReference.child(uid!).childByAutoId()
                        
                        newPostReference.setValue(["username": username, "profileImgUrl": profileImg, "postImgUrl": postImageUrl,"like": "0", "date": dateString])
                    }
                    
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
 
    func fetchImage (cameraSnapViewController : AGCameraSnapViewController, image : UIImage) {
        self.postImageView.image = image
    }
}

