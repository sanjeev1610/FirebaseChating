//
//  LoginVc+handlers.swift
//  FirebaseChating
//
//  Created by sanjeevkumar on 30/03/18.
//  Copyright © 2018 sanjeevkumar. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension LoginVc: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  @objc func handleSelectedImgView(){
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.allowsEditing = true
    present(picker, animated: true, completion: nil)
    
   }
    
    func signupUser(){
        
        guard let name = nameTextfield.text, let email = emailTextfield.text,
            let password = pwdTextfield.text else{
                print("signUP Error")
                return
        }
        
        //let userDatabase = ["Name": name, "Email": email]
        
        Auth.auth().createUser(withEmail: email, password: password, completion: {(user, err) in
            
            if(err as NSError? != nil){
                print("Create User Error")
            }
            
            guard let uid = user?.uid else{
                print("uid error")
                return
            }
            
           
            //let uploadedImage = UIImagePNGRepresentation(self.profileImageView.image!)
            let image = NSUUID().uuidString
            
            let storageRef = Storage.storage().reference().child("\(image).jpg")
            if  let profileImg = self.profileImageView.image , let uploadedImage = UIImageJPEGRepresentation(profileImg, 0.1){
                storageRef.putData(uploadedImage, metadata: nil, completion: {(metadata, err) in
                if err != nil{
                    print("metadata eerror")
                }
                if let profileImageURL = metadata?.downloadURL()?.absoluteString{
                    let userArray = ["Name": name, "Email": email, "Password": password, "ProfileImageURL": profileImageURL]
                    
                    self.registerUserIntoDatabase(uid: uid, userArray: userArray as [String : AnyObject] )
                }
            })
            }
            
            
           
            
        })//createUser
    }
    func registerUserIntoDatabase(uid: String, userArray: [String: AnyObject]){
        let ref =  Database.database().reference()
        ref.child("Users").child(uid).setValue(userArray, withCompletionBlock: {(err, ref) in
        if(err != nil){
         print("error")
         }else{
            //self.messageVewController?.navigationItem.title = userArray["Name"] as? String
            let user = User()
            user.Name = userArray["Name"] as? String
            user.Email = userArray["Email"] as? String
            user.ProfileImageURL = userArray["ProfileImageURL"] as? String
            user.Password = userArray["Password"] as? String
            self.messageVewController?.setupNavBarUser(user: user)
             self.dismiss(animated: true, completion: nil)
          }
      })
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker{
            profileImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("picker cancel")
        dismiss(animated: true, completion: nil)
    }
    
}

