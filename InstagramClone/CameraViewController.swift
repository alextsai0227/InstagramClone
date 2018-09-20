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



class CameraViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var postImageView: UIImageView!
    let picker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        // Do any additional setup after loading the view.
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

}

