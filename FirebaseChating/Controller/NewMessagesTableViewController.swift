//
//  NewMessagesTableViewController.swift
//  FirebaseChating
//
//  Created by sanjeevkumar on 30/03/18.
//  Copyright © 2018 sanjeevkumar. All rights reserved.
//

import UIKit
import Firebase
class NewMessagesTableViewController: UITableViewController {

    var messageViewConroller: MessagesViewController?
    
    let CELL_ID = "Cell_id"
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        tableView.register(UserTableCell.self, forCellReuseIdentifier: CELL_ID)
        fetchUsers()
    }
    func fetchUsers(){
        Database.database().reference().child("Users").observe(.childAdded, with: {(snapshot:DataSnapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                //user.setValuesForKeys(dictionary)
                user.id = snapshot.key
                user.Email = dictionary["Email"] as? String
                user.Name = dictionary["Name"] as? String
                user.Password = dictionary["Password"] as? String
                user.ProfileImageURL = dictionary["ProfileImageURL"] as? String
                self.users.append(user)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            
        })
    }

    @objc func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! UserTableCell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.Name
        cell.detailTextLabel?.text = user.Email
        
        if let profileImageUrl = user.ProfileImageURL{
            cell.profileImage.loadcachedImagedUsingUtlString(urlString: profileImageUrl)
        }
        return cell
    }
    //height row
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    //didselect row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
       dismiss(animated: true){
        let user1 = User()
        let usr = self.users[indexPath.row]
        user1.Email = usr.Email
        user1.id = usr.id
        user1.Name = usr.Name
        user1.ProfileImageURL = usr.ProfileImageURL
        self.messageViewConroller?.chatRoomHandler(user: user1)
        }
    }


}//class


//class UserTableCell: UITableViewCell{
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        textLabel?.frame = CGRect(x: 56, y: ((textLabel?.frame.origin.y)! - 2), width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
//        detailTextLabel?.frame = CGRect(x: 56, y: ((detailTextLabel?.frame.origin.y)! + 2), width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
//
//    }
//    let profileImage: UIImageView = {
//        let imgView = UIImageView()
//        imgView.contentMode = .scaleAspectFit
//        imgView.layer.cornerRadius = 20
//        imgView.layer.masksToBounds = true
//        imgView.clipsToBounds = true
//        imgView.translatesAutoresizingMaskIntoConstraints = false
//        return imgView
//    }()
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
//        addSubview(profileImage)
//
//        profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
//        profileImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        profileImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
//
//    }
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("coder init not implemented")
//    }
//}
















