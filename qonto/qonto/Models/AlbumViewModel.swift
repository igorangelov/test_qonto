//
//  AlbumViewModel.swift
//  qonto
//
//  Created by Igor Angelov on 02/12/2016.
//  Copyright © 2016 Igor Angelov. All rights reserved.
//

import UIKit

class AlbumViewModel: NSObject {

    private let album : Album
    var titleText : String
    
    init(album: Album)
    {
        self.album = album
        self.titleText = self.album.albumTitle
    }
}
