//
//  SignInViewController.swift
//  InstagramClone
//
//  Created by 蔡舜珵 on 2018/9/13.
//  Copyright © 2018年 蔡舜珵. All rights reserved.
//

import UIKit
import Firebase


class SignInViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.isEnabled = false
        handleTextfield()
    }

    func handleTextfield(){
        emailTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        
    }
    
    @objc func textFieldDidChange(){
        if let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty{
            loginBtn.isEnabled = true
        }else{
            loginBtn.isEnabled = false
        }
    }

    @IBAction func loginBtn_TouchUpInside(_ sender: Any) {
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(user, err) in
            if err != nil{
                print(err?.localizedDescription)
                return
            }
            self.performSegue(withIdentifier: "singInToTabBarVC", sender: nil)
        })
    
    }
    
}
