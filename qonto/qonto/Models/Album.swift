//
//  Album.swift
//  qonto
//
//  Created by Igor Angelov on 01/12/2016.
//  Copyright © 2016 Igor Angelov. All rights reserved.
//

import UIKit

class Album: NSObject {

    var id : Int! = 0
    var albumTitle : String! = ""
    
    
    init(dict:[String:Any]){
        super.init()
        
        self.id = dict["id"] as? Int ?? 0
        self.albumTitle = dict["title"] as? String ?? ""
    }

    
}
