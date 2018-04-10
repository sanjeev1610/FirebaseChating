//
//  ViewController.swift
//  FirebaseChating
//
//  Created by sanjeevkumar on 29/03/18.
//  Copyright © 2018 sanjeevkumar. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class ViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logOut))
        if Auth.auth().currentUser?.uid == nil{
            perform(#selector(logOut), with: nil, afterDelay: 0)
        }
        
    }
    
    @objc func logOut(){
        do{
            try Auth.auth().signOut()
        }catch _{
            print("Logout Error")
        }
        let lvc = LoginVc()
        present(lvc, animated: true, completion: nil)
     }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

}//class



























