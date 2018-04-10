//
//  UserChatCell.swift
//  FirebaseChating
//
//  Created by sanjeevkumar on 02/04/18.
//  Copyright © 2018 sanjeevkumar. All rights reserved.
//

import UIKit
import AVFoundation

class UserChatCell: UICollectionViewCell {
    var ChatController: ChatController?
    var messages: Message?
     

    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "hello"
        //tv.textAlignment = NSTextAlignment.right
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.backgroundColor = UIColor.clear
        tv.textColor = UIColor.white
        tv.isEditable = false
       // tv.backgroundColor = UIColor.yellow
        tv.translatesAutoresizingMaskIntoConstraints = false
        
       return tv
    }()
    
    let senderImageView: UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 16
        img.layer.masksToBounds = true
        img.contentMode = .scaleAspectFill
//        img.isUserInteractionEnabled = true
//        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomImage)))
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
//    @objc func handleZoomImage(tapGesture: UITapGestureRecognizer){
//        if let imageView = tapGesture.view as? UIImageView{
//            self.ChatController?.setImageZoomForStartingFrame(startingImage: imageView)
//        }
//    }
    lazy var playButton: UIButton = {
       let button = UIButton()
        let image = UIImage(named: "play")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
         button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(self.handlePlay(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
 
    
    let activatorIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.hidesWhenStopped = true
        aiv.translatesAutoresizingMaskIntoConstraints = false
       return aiv
    }()
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    @objc  func handlePlay(sender: UIButton){
        if let videoUrl = messages?.videoUrl, let url = NSURL(string:  videoUrl){
            player = AVPlayer(url: url as URL)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = bubbleView.bounds
            bubbleView.layer.addSublayer(playerLayer!)
            player?.play()
            activatorIndicatorView.startAnimating()
            playButton.isHidden = true
        }
       
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
//        ChatController?.playerLayer?.removeFromSuperlayer()
//        ChatController?.player?.pause()
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        activatorIndicatorView.stopAnimating()
        
      
    }
    let profileImage: UIImageView = {
       let img = UIImageView()
        img.image = UIImage(named: "sachin")
        img.layer.cornerRadius = 16
        img.layer.masksToBounds = true
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    static let blueColor = UIColor(r: 0, g: 139, b: 249)
    let bubbleView:UIView = {
       let bv = UIView()
        bv.backgroundColor = UserChatCell.blueColor
        bv.layer.cornerRadius = 16
        bv.layer.masksToBounds = true
        bv.translatesAutoresizingMaskIntoConstraints = false
        
        return bv
    }()
    
    var bubbleViewWidthConstraint: NSLayoutConstraint?
    var bubbleViewLeftAnchorConstraint: NSLayoutConstraint?
    var bubbleViewRightAnchorConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImage)
        bubbleView.addSubview(senderImageView)
        bubbleView.addSubview(playButton)
        bubbleView.addSubview(activatorIndicatorView)
        
        playButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        activatorIndicatorView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        activatorIndicatorView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        activatorIndicatorView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        activatorIndicatorView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        senderImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor ).isActive = true
        senderImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        senderImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        //textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        senderImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImage.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        bubbleViewLeftAnchorConstraint = bubbleView.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 8)
        bubbleViewLeftAnchorConstraint?.isActive = false
        
        bubbleViewRightAnchorConstraint = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRightAnchorConstraint?.isActive = true
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        bubbleViewWidthConstraint = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleViewWidthConstraint?.isActive = true
        
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8 ).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        //textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("UserChatCell error")
    }
  
}
