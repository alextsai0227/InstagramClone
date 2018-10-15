//
//  SignUpViewController.swift
//  InstagramClone
//
//  Created by 蔡舜珵 on 2018/9/13.
//  Copyright © 2018年 蔡舜珵. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController {
    @IBOutlet weak var userNameTextFIeld: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var signUpBtn: UIButton!
    var selectedImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.selectProfileImage))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        profileImage.layer.cornerRadius = 50
        profileImage.clipsToBounds = true
        signUpBtn.isEnabled = false
        handleTextfield()
    }
    
    func handleTextfield(){
        userNameTextFIeld.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        emailTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
    
    }
    
    @objc func textFieldDidChange(){
        if let username = userNameTextFIeld.text, !username.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty{
            signUpBtn.isEnabled = true
        }else{
            signUpBtn.isEnabled = false
        }
    }
    @objc func selectProfileImage() {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func dismiss_onClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func signUpBtn_TouchUpInside(_ sender: Any) {
        if userNameTextFIeld.text != nil &&  emailTextField.text != nil && passwordTextField.text != nil && selectedImage != nil{
            FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                let uid = user?.uid
                let storageRef = FIRStorage.storage().reference(forURL: "gs://instagramclone-94872.appspot.com").child("profile_image").child(uid!)
                if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1){
                    storageRef.put(imageData, metadata: nil, completion: {(metadata, err) in
                        if err != nil {
                            return
                        }
                        let profileImageUrl = metadata?.downloadURL()?.absoluteString
                        let ref = FIRDatabase.database().reference()
                        let userReference = ref.child("users")
                        let newUserReference = userReference.child(uid!)
                        newUserReference.setValue(["username": self.userNameTextFIeld.text!, "email": self.emailTextField.text!, "profileImgUrl": profileImageUrl])
                    })
                }
                self.performSegue(withIdentifier: "singUpToTabBarVC", sender: nil)
            })
        }
    }
}



extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = image
            profileImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }

}
