//
//  PhotoViewModel.swift
//  qonto
//
//  Created by Igor Angelov on 03/12/2016.
//  Copyright © 2016 Igor Angelov. All rights reserved.
//

import UIKit

class PhotoViewModel: NSObject {

    private let photo : Photo
    var titleText : String
    var urlPhoto : String
    
    init(photo: Photo)
    {
        self.photo = photo
        self.titleText = self.photo.photoTitle
        self.urlPhoto = self.photo.photoThumbnailUrl
    }
    
}
