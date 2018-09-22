//
//  EditPhotoViewController.swift
//  InstagramClone
//
//  Created by 蔡舜珵 on 2018/9/20.
//  Copyright © 2018年 蔡舜珵. All rights reserved.
//

import UIKit
import CoreImage

class EditPhotoViewController: UIViewController {
    @IBOutlet weak var editImageView: UIImageView!
    
    
    var originalImageView: UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        editImageView.image = originalImageView?.image
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func brightnessChanged(_ sender: Any) {
    }
    
    @IBAction func contrastChanged(_ sender: Any) {
    }
    
    @IBAction func filter_TouchUpInside(_ sender: Any) {
    }
    
    @IBAction func back_TouchUpInside(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
