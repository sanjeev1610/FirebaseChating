//
//  UserCell.swift
//  FirebaseChating
//
//  Created by sanjeevkumar on 01/04/18.
//  Copyright © 2018 sanjeevkumar. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class UserTableCell: UITableViewCell{
    
    var message: Message?{
        didSet{
               setUserNameandProfile()
            self.detailTextLabel?.text = message?.text
            if let seconds = message?.timeStamp as? Double{
                let timestmpdate = NSDate(timeIntervalSince1970: seconds)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                timaeLbl.text = dateFormatter.string(from: timestmpdate as Date)
                
            }
            
        }
    }
    
    private func setUserNameandProfile(){
//        var chartPartnerId : String?
//        if message?.fromId == Auth.auth().currentUser?.uid{
//            chartPartnerId = message?.toId
//        }else{
//            chartPartnerId = message?.fromId
//        }
        
        if let id = message?.chatPartnerId(){
        let ref = Database.database().reference().child("Users")
            ref.child(id).observe(.value, with: {(snapshot: DataSnapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                self.textLabel?.text = dictionary["Name"] as? String
                if let profileImgurl = dictionary["ProfileImageURL"]{
                    self.profileImage.loadcachedImagedUsingUtlString(urlString: profileImgurl as! String)
                }
            }
        }, withCancel: nil)
     }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 56, y: ((textLabel?.frame.origin.y)! - 2), width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        detailTextLabel?.frame = CGRect(x: 56, y: ((detailTextLabel?.frame.origin.y)! + 2), width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
        
    }
    let profileImage: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.layer.cornerRadius = 20
        imgView.layer.masksToBounds = true
        imgView.clipsToBounds = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    let timaeLbl: UILabel = {
       let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.textColor = UIColor.lightGray
        //lbl.text = "HH:MM:SS "
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImage)
        addSubview(timaeLbl)
        
        profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        timaeLbl.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        timaeLbl.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timaeLbl.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timaeLbl.heightAnchor.constraint(equalTo: (self.textLabel?.heightAnchor)!).isActive = true
        timaeLbl.centerYAnchor.constraint(equalTo: (self.textLabel?.centerYAnchor)!).isActive = true
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("coder init not implemented")
    }
}
