//
//  UIImageViewExtension.swift
//  OodriveTest
//
//  Created by Igor Angelov on 03/12/2016.
//  Copyright © 2016 Igor Angelov. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        
        //manager cached data func
        func getCachedData()
        {
            
            SupraCacheManager.getData(url: url.absoluteString, expiredAt: SupraCacheManager.makeExpiredDayWeek(weekLater: 1), completion: { (errors, data) -> Void in
                
                if errors == nil {
                    
                    // if can find cached
                    if let image = UIImage(data: data as! Data) {
                        DispatchQueue.main.async() { () -> Void in
                            self.image = image
                        }
                        return
                    }
                }
                
            }, callResource: nil)
        }
        
        if(Reachability.isConnectedToNetwork() == false){
            getCachedData()
        }

        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            
            SupraCacheManager.pushDataToCache(url: url.absoluteString, expiredAt: SupraCacheManager.makeExpiredDayWeek(weekLater: 1), data: data as NSData)
            
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
