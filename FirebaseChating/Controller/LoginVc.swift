//
//  LoginVc.swift
//  FirebaseChating
//
//  Created by sanjeevkumar on 29/03/18.
//  Copyright © 2018 sanjeevkumar. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginVc: UIViewController{
    
    var messageVewController: MessagesViewController?
    
    let profileImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "sachin")
        imgView.contentMode = .scaleAspectFill
//        imgView.clipsToBounds = true
//        imgView.layer.cornerRadius = 30
//        imgView.layer.masksToBounds = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
//        imgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectedImgView)))
//        imgView.isUserInteractionEnabled = true

        return imgView
    }()
    

    
    let loginRegSegmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        
        sc.selectedSegmentIndex = 1
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.addTarget(self, action: #selector(segmentHandler), for: .valueChanged)
        return sc
    }()
    
    @objc func segmentHandler(){
        let title = loginRegSegmentControl.titleForSegment(at: loginRegSegmentControl.selectedSegmentIndex)
           registerButton.setTitle(title, for: .normal)
        inputContainerHeightConstraint?.constant = loginRegSegmentControl.selectedSegmentIndex == 0 ? 100: 150
         nameTfHeightConstrint?.isActive = false
        nameTfHeightConstrint = nameTextfield.heightAnchor.constraint(equalTo: inputContainterView.heightAnchor, multiplier: loginRegSegmentControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTfHeightConstrint?.isActive = true
        
        emailTfHeightConstrint?.isActive = false
        emailTfHeightConstrint = emailTextfield.heightAnchor.constraint(equalTo: inputContainterView.heightAnchor, multiplier: loginRegSegmentControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTfHeightConstrint?.isActive = true
        
        pwdTfHeightConstrint?.isActive = false
        pwdTfHeightConstrint = pwdTextfield.heightAnchor.constraint(equalTo: inputContainterView.heightAnchor, multiplier: loginRegSegmentControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        pwdTfHeightConstrint?.isActive = true

        
        
    }
    
    let inputContainterView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let nameTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    let nameSeparator: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(r: 241, g: 241, b: 244)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    let emailSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 241, g: 241, b: 244)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let pwdTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    let pwdSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 241, g: 241, b: 244)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let registerButton:UIButton = {
        let btn = UIButton()
        btn.setTitle("Register", for: .normal)
        btn.backgroundColor = UIColor(r: 61, g: 101, b: 161)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(logNsignHandler), for: .touchUpInside)
        return btn
    }()
    
    @objc func logNsignHandler(){
        if loginRegSegmentControl.selectedSegmentIndex == 0{
            loginUser()
        }else{
            signupUser()
        }
    }
    
    func loginUser(){
        guard  let email = emailTextfield.text?.lowercased(),
            let password = pwdTextfield.text else{
                print("signUP Error")
                return
        }
        Auth.auth().signIn(withEmail: email, password: password, completion: {(user, err) in
            if err as NSError? != nil{
                print("Auth Error")
            }else{
                print("succ login")
                self.messageVewController?.setNavbarItemtitle()
                self.dismiss(animated: true, completion: nil)
                
            }
        })
        
    }
    
//ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        self.view.addSubview(inputContainterView)
        inputContainterView.addSubview(nameTextfield)
        inputContainterView.addSubview(nameSeparator)
        inputContainterView.addSubview(emailTextfield)
        inputContainterView.addSubview(emailSeparator)
        inputContainterView.addSubview(pwdTextfield)
        inputContainterView.addSubview(pwdSeparator)
        self.view.addSubview(registerButton)
        self.view.addSubview(profileImageView)
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleSelectedImgView)))
        profileImageView.isUserInteractionEnabled = true
        self.view.addSubview(loginRegSegmentControl)

        setupInputContainer()
        setupRegisterBtn()
        setupProfileImage()
        setupLoginRegSegmentControl()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func setupLoginRegSegmentControl(){
        loginRegSegmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegSegmentControl.bottomAnchor.constraint(equalTo: inputContainterView.topAnchor, constant: -12).isActive = true
        loginRegSegmentControl.widthAnchor.constraint(equalTo: inputContainterView.widthAnchor).isActive = true
        loginRegSegmentControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
    }

    
    func setupProfileImage(){
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
          profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegSegmentControl.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true

    }
    
    func setupRegisterBtn(){
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.widthAnchor.constraint(equalTo: inputContainterView.widthAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: inputContainterView.bottomAnchor, constant: 12).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    var inputContainerHeightConstraint: NSLayoutConstraint?
    var nameTfHeightConstrint: NSLayoutConstraint?
    var emailTfHeightConstrint: NSLayoutConstraint?
    var pwdTfHeightConstrint: NSLayoutConstraint?

    
    func setupInputContainer(){
        inputContainterView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainterView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainterView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputContainerHeightConstraint = inputContainterView.heightAnchor.constraint(equalToConstant: 150)
        inputContainerHeightConstraint?.isActive = true
        
        nameTextfield.leftAnchor.constraint(equalTo: inputContainterView.leftAnchor).isActive = true
        nameTextfield.rightAnchor.constraint(equalTo: inputContainterView.rightAnchor).isActive = true
        nameTextfield.topAnchor.constraint(equalTo: inputContainterView.topAnchor).isActive = true
        nameTextfield.widthAnchor.constraint(equalTo: inputContainterView.widthAnchor).isActive = true
        nameTfHeightConstrint = nameTextfield.heightAnchor.constraint(equalTo: inputContainterView.heightAnchor, multiplier: 1/3)
        nameTfHeightConstrint?.isActive = true
        
        
        nameSeparator.leftAnchor.constraint(equalTo: inputContainterView.leftAnchor).isActive = true
        nameSeparator.rightAnchor.constraint(equalTo: inputContainterView.rightAnchor).isActive = true
        nameSeparator.topAnchor.constraint(equalTo: nameTextfield.bottomAnchor).isActive = true
        nameTextfield.widthAnchor.constraint(equalTo: inputContainterView.widthAnchor).isActive = true
        nameSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true

        emailTextfield.leftAnchor.constraint(equalTo: inputContainterView.leftAnchor).isActive = true
        emailTextfield.rightAnchor.constraint(equalTo: inputContainterView.rightAnchor).isActive = true
        emailTextfield.topAnchor.constraint(equalTo: nameSeparator.bottomAnchor).isActive = true
        emailTextfield.widthAnchor.constraint(equalTo: inputContainterView.widthAnchor).isActive = true
        emailTfHeightConstrint =  emailTextfield.heightAnchor.constraint(equalTo: inputContainterView.heightAnchor, multiplier: 1/3)
        emailTfHeightConstrint?.isActive = true
        
        
        emailSeparator.leftAnchor.constraint(equalTo: inputContainterView.leftAnchor).isActive = true
        emailSeparator.rightAnchor.constraint(equalTo: inputContainterView.rightAnchor).isActive = true
        emailSeparator.topAnchor.constraint(equalTo: emailTextfield.bottomAnchor).isActive = true
        emailSeparator.widthAnchor.constraint(equalTo: inputContainterView.widthAnchor).isActive = true
        emailSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        pwdTextfield.leftAnchor.constraint(equalTo: inputContainterView.leftAnchor).isActive = true
        pwdTextfield.rightAnchor.constraint(equalTo: inputContainterView.rightAnchor).isActive = true
        pwdTextfield.topAnchor.constraint(equalTo: emailSeparator.bottomAnchor).isActive = true
        pwdTextfield.widthAnchor.constraint(equalTo: inputContainterView.widthAnchor).isActive = true
        pwdTfHeightConstrint = pwdTextfield.heightAnchor.constraint(equalTo: inputContainterView.heightAnchor, multiplier: 1/3)
        pwdTfHeightConstrint?.isActive = true
        
        
        pwdSeparator.leftAnchor.constraint(equalTo: inputContainterView.leftAnchor).isActive = true
        pwdSeparator.rightAnchor.constraint(equalTo: inputContainterView.rightAnchor).isActive = true
        pwdSeparator.topAnchor.constraint(equalTo: pwdTextfield.bottomAnchor).isActive = true
        pwdSeparator.bottomAnchor.constraint(equalTo: inputContainterView.bottomAnchor).isActive = true
        pwdSeparator.widthAnchor.constraint(equalTo: inputContainterView.widthAnchor).isActive = true
        pwdSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }

    
    

  


}//class
extension UIColor{
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
