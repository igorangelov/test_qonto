//
//  Photo.swift
//  qonto
//
//  Created by Igor Angelov on 02/12/2016.
//  Copyright © 2016 Igor Angelov. All rights reserved.
//

import UIKit

class Photo: NSObject {

    var id : Int! = 0
    var photoTitle : String! = ""
    var photoThumbnailUrl : String! = ""
    
    init(dict:[String:Any]){
        super.init()
        
        self.id = dict["id"] as? Int ?? 0
        self.photoTitle = dict["title"] as? String ?? ""
        self.photoThumbnailUrl = dict["thumbnailUrl"] as? String ?? ""
    }

}
