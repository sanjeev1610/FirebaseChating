//
//  Message.swift
//  FirebaseChating
//
//  Created by sanjeevkumar on 01/04/18.
//  Copyright © 2018 sanjeevkumar. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class Message: NSObject{
    var text: String?
    var fromId: String?
    var toId: String?
    var timeStamp: NSNumber?
    var imageUrl: String?
    var imageHeight: NSNumber?
    var imageWidth: NSNumber?
    var videoUrl: String?
    
    func chatPartnerId() -> String{

        return (fromId == Auth.auth().currentUser?.uid ? toId : fromId)!
    }
    init(dictionary: [String: AnyObject]){
        self.text = dictionary["text"] as? String
        self.fromId = dictionary["fromId"] as? String
        self.toId = dictionary["toId"] as? String
        self.timeStamp = dictionary["timeStamp"] as? NSNumber
        self.imageUrl = dictionary["imageUrl"] as? String
        self.imageHeight = dictionary["imageHeight"] as? NSNumber
        self.imageWidth = dictionary["imageWidth"] as? NSNumber
        self.videoUrl = dictionary["videoUrl"] as? String
    }
//    init(text: String, fromId: String, toId: String, timeStamp: NSNumber, imageUrl: String, imageHeight: NSNumber, imageWidth: NSNumber, videoUrl: String){
//        self.text = text
//        self.fromId = fromId
//        self.toId = toId
//        self.timeStamp = timeStamp
//        self.imageUrl = imageUrl
//        self.imageHeight = imageHeight
//        self.imageWidth = imageWidth
//        self.videoUrl = videoUrl
//    }
}
