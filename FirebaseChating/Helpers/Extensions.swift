//
//  Extensions.swift
//  FirebaseChating
//
//  Created by sanjeevkumar on 31/03/18.
//  Copyright © 2018 sanjeevkumar. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView{
    
   func loadcachedImagedUsingUtlString(urlString: String){
    if let cachedImg = imageCache.object(forKey: urlString as AnyObject){
        self.image = cachedImg as? UIImage
        return
    }
    
    let url = URL(string: urlString)
    URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, err) in
        if err != nil{
            print("download image url error")
        }
        
        
        DispatchQueue.main.async {
            if let downloadedImade = UIImage(data: data!){
                imageCache.setObject(downloadedImade, forKey: urlString as AnyObject)
            self.image = downloadedImade
                
            }
        }
    }).resume()

  }
}
