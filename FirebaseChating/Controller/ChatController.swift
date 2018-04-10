//
//  chatController.swift
//  FirebaseChating
//
//  Created by sanjeevkumar on 31/03/18.
//  Copyright © 2018 sanjeevkumar. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import MobileCoreServices
import AVFoundation

class ChatController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var messages = [Message]()
    
    var user: User?{
        didSet{
            navigationItem.title = user?.Name
            observeMessages()
        }
    }
    
    func observeMessages(){
        guard let uid = Auth.auth().currentUser?.uid, let toUserId = user?.id else{
            return
        }
        let ref = Database.database().reference().child("user-messages").child(uid).child(toUserId)
        ref.observe(.childAdded, with: {(snapshot) in
            let msgId = snapshot.key
           let msgRef =  Database.database().reference().child("Messages").child(msgId)
            msgRef.observe(.value, with: {(snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let msgs = Message(dictionary: dictionary)
//                    let msgs = Message(text: dictionary["text"] as! String, fromId: dictionary["fromId"] as! String , toId: dictionary["toId"] as! String, timeStamp: dictionary["timeStamp"] as! NSNumber, imageUrl: dictionary["imageUrl"] as! String, imageHeight: dictionary["imageHeight"] as! NSNumber , imageWidth: dictionary["imageWidth"] as! NSNumber, videoUrl: dictionary["videoUrl"] as! String)
//                     msgs.fromId = dictionary["fromId"] as? String
//                    msgs.imageHeight = dictionary["imageHeight"] as? NSNumber
//                    msgs.imageWidth = dictionary["imageWidth"] as? NSNumber
//                    msgs.imageUrl = dictionary["imageUrl"] as? String
//                    msgs.text = dictionary["text"] as? String
//                    msgs.timeStamp = dictionary["timeStamp"] as? NSNumber
//                    msgs.videoUrl = dictionary["videoUrl"] as? String
//                    msgs.toId = dictionary["toId"] as? String
//
                    if msgs.chatPartnerId() == self.user?.id{
                       self.messages.append(msgs)
                        
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                            let indexpath = NSIndexPath(item: self.messages.count - 1, section: 0)
                            self.collectionView?.scrollToItem(at: indexpath as IndexPath, at: .bottom, animated: true)
                        }
                        
                    }
                    
                    
                }
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    lazy var msgTextField:UITextField = {
        let msgTf = UITextField()
        msgTf.placeholder = "Enter text here "
        //msgTf.backgroundColor = UIColor.white
        msgTf.delegate = self
        msgTf.translatesAutoresizingMaskIntoConstraints = false
    return msgTf
    }()
    let sendImageView: UIImageView = {
        let sendImageView = UIImageView()
    sendImageView.image  = UIImage(named: "image-icon")
      //sendImageView.isUserInteractionEnabled = true
    sendImageView.translatesAutoresizingMaskIntoConstraints = false
   
        return sendImageView
    }()
    let CELL_ID = "cell id"
    
    //ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        sendImageView.isUserInteractionEnabled = true
        sendImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageTap)))
        collectionView?.register(UserChatCell.self, forCellWithReuseIdentifier: CELL_ID)
        setupKeyBoardObserver()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    func setupKeyBoardObserver(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardTopMsg), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
    }
    @objc func handleKeyboardTopMsg(){
        if messages.count > 0{
    let indexpath = NSIndexPath(item: messages.count-1, section: 0)
        self.collectionView?.scrollToItem(at: indexpath as IndexPath, at: .top, animated: true)
        }
            
    }
    
   lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
       containerView.backgroundColor = UIColor.white
    
   
        containerView.addSubview(sendImageView)
    
        sendImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        sendImageView.widthAnchor.constraint(equalToConstant: 33).isActive = true
        sendImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
   
    
//        let tf = UITextField()
//        tf.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
//        containerView.addSubview(tf)
    let sendBtn = UIButton()
    sendBtn.setTitle("Send", for: .normal)
    sendBtn.setTitleColor(UIColor.blue, for: .normal)
    //sendBtn.backgroundColor = UIColor.white
    sendBtn.translatesAutoresizingMaskIntoConstraints = false
    sendBtn.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
    containerView.addSubview(sendBtn)
    sendBtn.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
    sendBtn.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    sendBtn.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
    sendBtn.widthAnchor.constraint(equalToConstant: 80).isActive = true
    
    
    
    containerView.addSubview(msgTextField)
    msgTextField.leftAnchor.constraint(equalTo: sendImageView.leftAnchor, constant: 40).isActive = true
    msgTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    msgTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
    msgTextField.rightAnchor.constraint(equalTo: sendBtn.leftAnchor).isActive = true
    
    let msgSeparatorView = UIView()
    msgSeparatorView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
    msgSeparatorView.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(msgSeparatorView)
    msgSeparatorView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
    msgSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    msgSeparatorView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
    msgSeparatorView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
    
    
       return containerView
    }()
    
    @objc func handleImageTap(){
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = [kUTTypeImage as String , kUTTypeMovie as String]

        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? NSURL{
            selectedVideoForUrl(url: videoUrl)
           
        }else{
            handleSelectedImageInfo(info: info as [String : AnyObject])
       
       }
          dismiss(animated: true, completion: nil)
       
    }
    private func selectedVideoForUrl(url: NSURL){
        let fileName = NSUUID().uuidString + ".mov"
        let uploadedTask = Storage.storage().reference().child(fileName).putFile(from: url as URL, metadata: nil, completion: {(metadata, err) in
            if err != nil{
                print("video Storage Err")
                return
            }
            if let videoUrl = metadata?.downloadURL()?.absoluteString{
                if let  thumbnailImage = self.thumbnailImageSet(url: url){
                    self.sendImageIntoFirebaseStorage(image: thumbnailImage, completion: {(imageUrl) in
                        let properties: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject, "imageHeight": thumbnailImage.size.height as AnyObject, "imageWidth": thumbnailImage.size.width as AnyObject, "videoUrl": videoUrl as AnyObject]
                        self.setPropertiesForMessagesAnsStore(properties: properties)
                    })
                   
                }
              
                
            }
        })
        uploadedTask.observe(.progress, handler: {(snapshot) in
            if let completedUnitCount = snapshot.progress?.completedUnitCount{
                self.navigationItem.title = String(completedUnitCount)
            }
        })
        uploadedTask.observe(.success, handler: {(snapshot) in
            self.navigationItem.title = self.user?.Name
        })
        
    }
    private func thumbnailImageSet(url: NSURL) -> UIImage?{
        let asset = AVAsset(url: url as URL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        do{
            let thumbnailCgImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
            return UIImage(cgImage: thumbnailCgImage)

        }catch let err{
            print(err)
        }
        return nil
            }
    private func handleSelectedImageInfo(info: [String: AnyObject]){
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker{
            sendImageIntoFirebaseStorage(image: selectedImage, completion: {(imageUrl) in
                self.storeImageurlIntoMessageDatabase(imageUrl: imageUrl, image: selectedImage)
            })
        }
    }
    
    private func  sendImageIntoFirebaseStorage(image: UIImage, completion: @escaping (_ imageUrl: String) -> ()){
        let imageName = NSUUID().uuidString
        let ref = Storage.storage().reference().child("user-images").child("\(imageName).jpg")
        if let uploadImage = UIImageJPEGRepresentation(image, 0.2){
        ref.putData(uploadImage, metadata: nil, completion: {(metadata, err) in
            if err != nil{
                print("Upload Image Error")
                return
            }
            
            if let imageURl = metadata?.downloadURL()?.absoluteString{
                completion(imageURl)
            }
        })
        }
        
    }
    @objc func handleSend(){
        
        let properties: [String: AnyObject] = ["text": msgTextField.text! as AnyObject]
         self.setPropertiesForMessagesAnsStore(properties: properties)
    }
    private func storeImageurlIntoMessageDatabase(imageUrl: String, image: UIImage){
        let properties: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject, "imageHeight": image.size.height as AnyObject, "imageWidth": image.size.width as AnyObject]
        self.setPropertiesForMessagesAnsStore(properties: properties)

    }
    
    private func setPropertiesForMessagesAnsStore(properties: [String: AnyObject]){
        
        let ref = Database.database().reference().child("Messages")
        let autoIdRef = ref.childByAutoId()
        let toId = user!.id!
        let fromId = Auth.auth().currentUser!.uid
        //let timestamp = NSDate().timeIntervalSince1970
        let timestamp: NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        var inputText = ["toId": toId , "fromId": fromId, "timeStamp": timestamp] as [String : Any]
        properties.forEach({inputText[$0] = $1 as! NSObject})
        //autoIdRef.updateChildValues(inputText as Any as! [AnyHashable : Any])
        autoIdRef.updateChildValues(inputText , withCompletionBlock: {(err, ref) in
            if err != nil {
                print("handleSend error")
                return
            }
            self.msgTextField.text = nil
            let senderIdRef = Database.database().reference().child("user-messages")
            let msgkeyId = autoIdRef.key
            senderIdRef.child(fromId).child(toId).updateChildValues([msgkeyId: 1])
            
            let receipentIdRef = Database.database().reference().child("user-messages")
            receipentIdRef.child(toId).child(fromId).updateChildValues([msgkeyId: 1])
            
        })
        
    }
   
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override var inputAccessoryView: UIView?{
        get{
            return containerView
        }
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        if let text = messages[indexPath.item].text{
            height = estimateFrameForText(text: text).height + 20
        }else if let imageHeight = messages[indexPath.item].imageHeight?.floatValue, let imageWidth = messages[indexPath.item].imageWidth?.floatValue {
            height = CGFloat(imageHeight/imageWidth*200)
        }
//        if let image = messages[indexPath.row].imageUrl{
//            height = estimateFrameForText(text: image).height
//        }
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect{
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesLineFragmentOrigin.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    var msgCell:Message?
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! UserChatCell
            //cell.backgroundColor = UIColor.blue
        cell.ChatController = self
        
        let msg = messages[indexPath.item]
        self.msgCell = msg
        cell.messages = msg
        cell.textView.text = msg.text
        setupCellAndMessage(cell: cell, message: msg)
        if let text = msg.text{
            cell.textView.isHidden = false
        cell.bubbleViewWidthConstraint?.constant = estimateFrameForText(text: text).width +  32
        }else
        if msg.imageUrl != nil{
            cell.textView.isHidden = true
            cell.senderImageView.isUserInteractionEnabled = true
            cell.senderImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomImage)))
            cell.bubbleViewWidthConstraint?.constant = 200
        }
//        if let text = msg.imageUrl{
//        cell.bubbleViewWidthConstraint?.constant = estimateFrameForText(text: text).width +  32
//        }
        
        
            cell.playButton.isHidden = msg.videoUrl == nil
        //cell.playButton.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
       
           //cell.prepareForReuse()
        
       
        return cell
    }
//    var player: AVPlayer?
//    var playerLayer: AVPlayerLayer?
//    @objc func handlePlay(cell: UserChatCell){
//        if let videoUrl = self.msgCell?.videoUrl, let url = NSURL(string: videoUrl){
//            player = AVPlayer(url: url as URL)
//            playerLayer = AVPlayerLayer(player: player)
//            playerLayer?.frame = cell.bubbleView.bounds
//            cell.bubbleView.layer.addSublayer(playerLayer!)
//
//
//             player?.play()
//            cell.activatorIndicatorView.startAnimating()
//            cell.playButton.isHidden = true
//
//            print("star")
//        }
//
//   }
    
    
    
    private func setupCellAndMessage(cell: UserChatCell, message: Message){
        if let profileImageUrl = self.user?.ProfileImageURL{
            cell.profileImage.loadcachedImagedUsingUtlString(urlString: profileImageUrl)
        }
        
        if message.fromId == Auth.auth().currentUser?.uid{
          cell.bubbleView.backgroundColor = UserChatCell.blueColor
            cell.textView.textColor = UIColor.white
            cell.profileImage.isHidden = true
            cell.bubbleViewLeftAnchorConstraint?.isActive = false
            cell.bubbleViewRightAnchorConstraint?.isActive = true
        
        }else{
           
            cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            cell.textView.textColor = UIColor.black
             cell.profileImage.isHidden = false
            cell.bubbleViewLeftAnchorConstraint?.isActive = true
            cell.bubbleViewRightAnchorConstraint?.isActive = false
        }
        
        if let messageImageUrl  = message.imageUrl{
            cell.senderImageView.loadcachedImagedUsingUtlString(urlString: messageImageUrl)
            cell.senderImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
        }else{
            cell.senderImageView.isHidden = true

        }
        
       
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        containerView.endEditing(true)
//    }
    
    @objc func handleZoomImage(tapGesture: UITapGestureRecognizer){
        if self.msgCell?.videoUrl != nil{
            return
        }
        if let imageView = tapGesture.view as? UIImageView{
           self.setImageZoomForStartingFrame(startingImage: imageView)
        
    }
    }
    var startingFrame: CGRect?
    var blackbackgroundView: UIView?
    var startingImage: UIImageView?
    func setImageZoomForStartingFrame(startingImage: UIImageView){
        self.startingImage = startingImage
         startingFrame = startingImage.superview?.convert(startingImage.frame, to: nil)
        let zoomImageView = UIImageView(frame: startingFrame!)
         zoomImageView.backgroundColor = UIColor.red
         zoomImageView.image = startingImage.image
         zoomImageView.isUserInteractionEnabled = true
         zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setZoomOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow{
             blackbackgroundView = UIView(frame: keyWindow.frame)
            blackbackgroundView?.backgroundColor = UIColor.black
            
            keyWindow.addSubview(blackbackgroundView!)
            keyWindow.addSubview(zoomImageView)
         
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                let height = (self.startingFrame?.height)!/(self.startingFrame?.width)!*keyWindow.frame.width
                zoomImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomImageView.center = keyWindow.center
                self.containerView.alpha = 0
                }, completion: nil)
        }
    }
    @objc func setZoomOut(tapGesture: UITapGestureRecognizer){
        if let zoomOutImage = tapGesture.view{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutImage.frame = self.startingFrame!
                self.containerView.alpha = 1
                self.blackbackgroundView?.alpha = 0
            }, completion: {(completed) in
                zoomOutImage.removeFromSuperview()
                self.startingImage?.isHidden = false
                
                })
        }
    }
}//clasas















































































