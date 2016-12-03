//
//  ServicesManager.swift
//  OodriveTest
//
//  Created by Igor Angelov on 20/11/2016.
//  Copyright © 2016 Igor Angelov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

typealias ResultResponseManager = (_ errorResponse: ErrorResponseType, _ jsonResponse: Any?) -> Void

enum ErrorResponseType {
    case Unknown
    case None // No Error
    case Error // All Error
}

enum HeaderContentType : String {
    case Basic = "application/json"
    case Download = "application/octet-stream"
    case Upload = "upload" // don't use in header dictionary
}


class ServicesManager {

    //***************************
    //get User list for API
    //***************************
    class func getUsers(callback: @escaping ResultResponseManager) {
    
        debugPrint(UrlHelper.urlGetUserList())
        
        Alamofire.request(UrlHelper.urlGetUserList(),
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: ServicesManager.requestHeader(type:.Basic )
            ).response { (response) in
            

            guard let code = response.response?.statusCode else
                {
                    callback(.Error, nil )
                    return
                }
                

            ///* Request fine */
            if(ServicesManager.canSendResponse(code: code))
            {
                //Verifiy Data
                if let data = response.data{
                    let swiftyJsonVar : [Any] = JSON(data: data).arrayObject!
                    callback(.None, swiftyJsonVar )
                }
            }else{ ///* Request not fine */
                callback(.Error, nil )
            }
            
        }
        

    }
    
    
    //***************************
    //get Album list for API
    //***************************
    class func getUserAlbums(userId: Int, callback: @escaping ResultResponseManager) {
        
                debugPrint(UrlHelper.urlGetUserAlbums(id: userId))
        
        Alamofire.request(UrlHelper.urlGetUserAlbums(id: userId),
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: ServicesManager.requestHeader(type:.Basic )
            ).response { (response) in
                
                
                guard let code = response.response?.statusCode else
                {
                    callback(.Error, nil )
                    return
                }
                
                
                ///* Request fine */
                if(ServicesManager.canSendResponse(code: code))
                {
                    //Verifiy Data
                    if let data = response.data{
                        let swiftyJsonVar : [Any] = JSON(data: data).arrayObject!
                        callback(.None, swiftyJsonVar )
                    }
                }else{ ///* Request not fine */
                    callback(.Error, nil )
                }
                
        }
        
        
    }
    
    //***************************
    //get Photo list for API
    //***************************
    class func getAlbumPhotos(albumId: Int, callback: @escaping ResultResponseManager) {
        
                        debugPrint(UrlHelper.urlGetAlbumPhotos(id: albumId))
        
        Alamofire.request(UrlHelper.urlGetAlbumPhotos(id: albumId),
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: ServicesManager.requestHeader(type:.Basic )
            ).response { (response) in
                
                
                guard let code = response.response?.statusCode else
                {
                    callback(.Error, nil )
                    return
                }
                
                ///* Request fine */
                if(ServicesManager.canSendResponse(code: code))
                {
                    //Verifiy Data
                    if let data = response.data{
                        let swiftyJsonVar : [Any] = JSON(data: data).arrayObject!
                        callback(.None, swiftyJsonVar )
                    }
                }else{ ///* Request not fine */
                    callback(.Error, nil )
                }
                
        }
        
        
    }
    
    
    //***************************
    //retour bool depend of http code
    //***************************
    class func canSendResponse(code : Int) -> Bool {
        
        switch code {
        case 200...201 : /* Request fine */
            return true
        case 400...550 : /*errors*/
            return false
        default: /* Error no defined yet */
            return false
        }
        
    
    }
    //***************************
    //return header for request for type
    //***************************
    class func requestHeader(type:HeaderContentType, fileName:String = "")->[String:String]
    {
        let plainString = "noel:foobar" as String
        let plainData = plainString.data(using: .utf8)
        let base64String = plainData?.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
        
        var headers = [
            "Authorization":  "Basic " + base64String!,
            "Content-Type": type.rawValue
        ]
        
        if(type == .Upload)
        {
             headers = [
                "Authorization":  "Basic " + base64String!,
                "Content-Type": HeaderContentType.Download.rawValue,
                "Content-Disposition": "attachment;filename*=utf-8''"+fileName
            ]
        }
        
        return headers
        
    }
    
}

