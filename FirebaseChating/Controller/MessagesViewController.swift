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
class MessagesViewController: UITableViewController {
    let cellId = "Cell Id"
    var message = [Message]()
    var messageDictionary = [String: Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logOut))
        let image = UIImage(named: "edit1")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleEdit))
        tableView.register(UserTableCell.self, forCellReuseIdentifier: cellId)
         checkIsUserLogin()
        tableView.allowsMultipleSelectionDuringEditing = true
    }
    
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        let msg = self.message[indexPath.row]
        if let chartPartnerId: String = msg.chatPartnerId() {
           let ref =  Database.database().reference().child("user-messages").child(uid).child(chartPartnerId)
            ref.removeValue(completionBlock: {(err, ref) in
                if err != nil {
                    print("remove error")
                }
                self.messageDictionary.removeValue(forKey: chartPartnerId)
                self.setupReloadTable()
                
            })
        }
        
    }
    
    func observeUserMessages(){
        guard let usrId = Auth.auth().currentUser?.uid else {
            return
        }
        let usrMsgRef = Database.database().reference().child("user-messages").child(usrId)
        usrMsgRef.observe(.childAdded, with: {(snapshot: DataSnapshot) in
           let keyRef = snapshot.key
            Database.database().reference().child("user-messages").child(usrId).child(keyRef).observe(.childAdded, with: {(snapshot) in
                let msgkeyRef = snapshot.key
               self.fetchUserAndMessages(msgId: msgkeyRef)
            }, withCancel: nil)

        }, withCancel: nil)
        usrMsgRef.observe(.childRemoved, with: {(snapshot) in
            self.messageDictionary.removeValue(forKey: snapshot.key)
            self.setupReloadTable()
        }, withCancel: nil)
    }
    private func setupReloadTable(){
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    private func fetchUserAndMessages(msgId: String){
        let msgRef = Database.database().reference().child("Messages")
        msgRef.child(msgId).observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let messages = Message(dictionary: dictionary)
                // messages.setValuesForKeys(dictionary)
            
//                messages.fromId = dictionary["fromId"] as? String
//                messages.toId = dictionary["toId"] as? String
//                messages.text = dictionary["text"] as? String
//                messages.timeStamp = dictionary["timeStamp"] as? NSNumber
//                messages.imageUrl = dictionary["imageUrl"] as? String
                
                //self.message.append(messages)
                self.messageDictionary[messages.chatPartnerId()] = messages
                self.setupReloadTable()
            }
        }, withCancel: nil)
    }
    var timer: Timer?
    @objc func handleReloadTable(){
        self.message = Array(self.messageDictionary.values)
        self.message.sort(by: { $0.timeStamp?.intValue ?? 0 > $1.timeStamp?.intValue ?? 0})
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
 
    //NewMessageViewController
    @objc func handleEdit(){
        let newMsgTVC = NewMessagesTableViewController()
        newMsgTVC.messageViewConroller = self
        let navController = UINavigationController(rootViewController: newMsgTVC)
        present(navController, animated: true, completion: nil)
    }
   
    func checkIsUserLogin(){
        
        if Auth.auth().currentUser?.uid == nil{
            perform(#selector(logOut), with: nil, afterDelay: 0)
        }else{
            
               setNavbarItemtitle()
           
        }
    }
    func setNavbarItemtitle(){
        
        guard let id = Auth.auth().currentUser?.uid else{
            return
        }
        
        Database.database().reference().child("Users").child(id).observe(.value, with: {(snapshot: DataSnapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                //self.navigationItem.title = dictionary["Name"] as? String
                let user = User()
                user.Name = dictionary["Name"] as? String
                user.Email = dictionary["Email"] as? String
                user.ProfileImageURL = dictionary["ProfileImageURL"] as? String
                user.Password = dictionary["Password"] as? String
                self.setupNavBarUser(user: user)
            }
        })
    }
    
    func setupNavBarUser(user: User){
        message.removeAll()
        messageDictionary.removeAll()
        tableView.reloadData()
        observeUserMessages()
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        //titleView.backgroundColor = UIColor.red
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        let profileImagView = UIImageView()
        if  let profilePicUrl = user.ProfileImageURL{
        profileImagView.loadcachedImagedUsingUtlString(urlString: profilePicUrl)
        }
        profileImagView.layer.cornerRadius = 20
        profileImagView.layer.masksToBounds = true
        profileImagView.clipsToBounds = true
        profileImagView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(profileImagView)
        profileImagView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImagView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImagView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImagView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        
        let nameLbl = UILabel()
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        nameLbl.text = user.Name
        containerView.addSubview(nameLbl)
        nameLbl.leftAnchor.constraint(equalTo: profileImagView.rightAnchor, constant: 8).isActive = true
        nameLbl.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        nameLbl.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        
        
        
        self.navigationItem.titleView = titleView
    }
    
    func chatRoomHandler(user: User){
        let chatRoomController = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
        chatRoomController.user = user
        self.navigationController?.pushViewController(chatRoomController, animated: true)
    }
    
    @objc func logOut(){
        do{
            try Auth.auth().signOut()
        }catch _{
            print("Logout Error")
        }
        let lvc = LoginVc()
        lvc.messageVewController = self
        present(lvc, animated: true, completion: nil)
     }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserTableCell
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        let msg = message[indexPath.row]
//        cell.textLabel?.text = msg.toId
//        cell.detailTextLabel?.text = msg.text
        cell.message = msg
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let msg = self.message[indexPath.row]

        let ref = Database.database().reference().child("Users").child(msg.chatPartnerId())
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else{
                return
            }
                let usr = User()
                usr.Name = dictionary["Name"] as? String
                usr.Email = dictionary["Email"] as? String
                usr.ProfileImageURL = dictionary["ProfileImageURL"] as? String
                usr.id = msg.chatPartnerId()
                self.chatRoomHandler(user: usr)
            
            
        }, withCancel: nil)
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

}//class



























