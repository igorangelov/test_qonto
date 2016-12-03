//
//  UrlHelper.swift
//  OodriveTest
//
//  Created by Igor Angelov on 30/11/2016.
//  Copyright © 2016 Igor Angelov. All rights reserved.
//

import UIKit

class UrlHelper {

    
    // MARK: - GENERAL
    
    class func getBaseURL()->String
    {
        return "https://jsonplaceholder.typicode.com"
    }
    
   
    // MAKR: - USER

    class func urlGetUserList()->String
    {
        return "\(UrlHelper.getBaseURL())/users"
    }

    class func urlGetUserAlbums(id:Int)->String
    {
        return "\(UrlHelper.getBaseURL())/users/\(id)/albums"
    }
    
    class func urlGetAlbumPhotos(id:Int)->String
    {
        return "\(UrlHelper.getBaseURL())/albums/\(id)/photos"
    }

    
}
