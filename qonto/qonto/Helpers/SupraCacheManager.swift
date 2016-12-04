//
//  SupraCacheManager.swift
//  SupraCacheManager
//
//  Created by Igor Angeloc on 3/12/2016.
//  Copyright © 2016 Beepings. All rights reserved.
//

import Foundation


let kInfoCacheKeyURL        :String = "_URL"
let kInfoCacheKeyCreateAt   :String = "_CREATE_AT"
let kInfoCacheKeyFileName   :String = "_FILE_PATH"
let kInfoCacheKeyExpiredAt  :String = "_EXPIRED_AT"
let kInfoCacheKeyCanExpired :String = "_CAN_EXPIRED"
let kInfoCacheKeyType       :String = "_TYPE"

class SupraCacheManager {
    
    typealias callBackResource = (_ endCall: responseCallBack) -> Void
    typealias responseCallBack = (_ errors :NSError?, _ data: NSData?) -> Void
    
    enum CacheType : String {
        case IMAGE = "_IMAGE"
        case DATA  = "_DATA"
    }
    
    enum ErrorCacheImage : Int {
        case CANNOT_LOAD_IMAGE
        case RESSOURCE_CALL_NOT_FOUND
        case RESSOURCE_CANNOT_DOWNLOAD_IMAGE
        case NOT_SPACE_AVAIBLE
        case DATA_EMPTY
    }
    
    /**
     Create a date with a delay Hour
     
     - parameter hourLater: NSTimeInterval
     
     - returns: NSDate
     */
    class func makeExpiredDayHour(hourLater: TimeInterval) -> NSDate {
        
        return NSDate().addingTimeInterval(60*60*hourLater)
    }
    
    /**
     Create a date with a delay Hour
     
     - parameter hourLater: NSTimeInterval
     
     - returns: NSDate
     */
    class func makeExpiredDayLater(dayLater: TimeInterval) -> NSDate {
        
        return NSDate().addingTimeInterval(60*60*24*dayLater)
    }
    
    /**
     Create a date with a delay week
     
     - parameter weekLater: NSTimeInterval
     
     - returns: NSDate
     */
    class func makeExpiredDayWeek(weekLater: TimeInterval) -> NSDate {
        
        return NSDate().addingTimeInterval(60*60*24*7*weekLater)
    }
    
    /**
     Create a date with a delay week
     
     - parameter weekLater: NSTimeInterval
     
     - returns: NSDate
     */
    class func makeExpiredYear(yearLater: TimeInterval) -> NSDate {
        
        return NSDate().addingTimeInterval(60*60*24*365 * yearLater)
    }
    
    /**
     Create a dictionnary an info
     
     - parameter url:       String
     - parameter canExpire: Bool
     - parameter expiredAt: NSDate
     
     - returns: NSDictionnary
     */
    private class func createDictionnaryInfo(
        type :CacheType,
        data: NSData!,
        url: String,
        expiredAt: NSDate!) -> NSError? {
            
            var info : NSMutableDictionary!
            let namefile = self.randomNameFile()
            let pathfile = type == .IMAGE ?  self.getPathImage() : self.getPathData() + "/" + namefile
            
            self.removeAllExpiredInfo()
            
            if data == nil || data.length == 0 {
                return createError(error: .DATA_EMPTY, desc: "data empty")
            }
            
            if !(getFreeSpace() > Int64(data.length) && data.write(toFile: pathfile, atomically: true)) {
                return createError(error: .NOT_SPACE_AVAIBLE, desc: "Not availble space")
            }
            
            info = NSMutableDictionary()
            info.setObject(url, forKey: kInfoCacheKeyURL as NSCopying)
            info.setObject(expiredAt != nil, forKey: kInfoCacheKeyCanExpired as NSCopying)
            if expiredAt != nil {
                info.setObject(expiredAt, forKey: kInfoCacheKeyExpiredAt as NSCopying)
            }
            info.setObject(type.rawValue, forKey: kInfoCacheKeyType as NSCopying)
            info.setObject(NSDate(), forKey: kInfoCacheKeyCreateAt as NSCopying)
            info.setObject(namefile, forKey: kInfoCacheKeyFileName as NSCopying)
            self.setInfoCache(info: info)
            
            return nil
    }
    
    /**
     get a image in cached if existe, ohterwise set it.
     
     - parameter url:          string
     - parameter expiredAt:    NSDate
     - parameter completion:   responseCallBack
     - parameter callResource: callBackResource
     */
    class func getImage(
        url: String,
        expiredAt: NSDate! = nil,
        completion:@escaping responseCallBack,
        callResource:callBackResource? = nil) ->  Void {
            self.getCached(type: .IMAGE, url: url, expiredAt: expiredAt, completion: completion, callResource: callResource)
    }
    
    /**
     Method to cache directely cached data. It return if success to cached
     
     - parameter url:       string
     - parameter expiredAt: NSDate
     - parameter data:      NSData
     
     */
    class func pushDataToCache(url: String,
        expiredAt: NSDate! = nil,
        data: NSData) {
            let _ = self.createDictionnaryInfo(type: .DATA, data: data, url: url, expiredAt: expiredAt)
    }
    
    
    /**
     Method to cache directely cached data. It return if success to cached
     
     - parameter url:       string
     - parameter expiredAt: NSDate
     - parameter data:      NSData
     
     */
    class func pushImageToCache(url: String,
                               expiredAt: NSDate! = nil,
                               data: NSData) {
        let _ = self.createDictionnaryInfo(type: .IMAGE, data: data, url: url, expiredAt: expiredAt)
    }
    
    /**
     get a data in cached if existe, ohterwise set it.
     
     - parameter url:          string
     - parameter expiredAt:    NSDate
     - parameter completion:   responseCallBack
     - parameter callResource: callBackResource
     */
    class func getData(
        url: String,
        expiredAt: NSDate! = nil,
        completion:@escaping responseCallBack,
        callResource:callBackResource? = nil) ->  Void {
            self.getCached(type: .DATA, url: url, expiredAt: expiredAt, completion: completion, callResource: callResource)
    }
    
    class private func getCached(type: CacheType,
        url: String,
        expiredAt: NSDate! = nil,
        completion:@escaping responseCallBack,
        callResource:callBackResource? = nil) ->  Void {
            
            if let info = getMainInfoCacheDictionnary().object(forKey: url) as? NSDictionary {
                
                let canExpired = info.object(forKey: kInfoCacheKeyCanExpired) as! Bool
                if canExpired == true {
                    let expiredDate = info.object(forKey: kInfoCacheKeyExpiredAt) as! NSDate
                    // compare date file expired
                    if NSDate().compare(expiredDate as Date) == ComparisonResult.orderedDescending  {
                        // if expired remove and refresh
                        removeInfoCache(key: url)
                        self.prepareCallResource(type: type, url: url, expiredAt: expiredAt, completion: completion, callResource: callResource)
                    } else {// if date no expired yet !!!
                        self.loadContentFromInfoCacheDictionnary(type: type, infoCache: info, completion: completion)
                    }
                } else {// if no expired date file !!!
                    self.loadContentFromInfoCacheDictionnary(type: type, infoCache: info, completion: completion)
                }
                
            } else {// if image || data not exist yet !!!
                self.prepareCallResource(type: type, url: url, expiredAt: expiredAt, completion: completion, callResource: callResource)
            }
    }
    
    
    /**
     Create a custom error
     
     - parameter error: ErrorCacheImage
     - parameter desc:  string
     
     - returns: NSError
     */
    private class func createError(error :ErrorCacheImage, desc: String = "") -> NSError {
        return NSError(domain: "CacheManager", code: error.rawValue, userInfo: ["errors": desc])
    }
    
    /**
     Return the filepath by giving a infoCached Dictionnary
     
     - parameter info: NSDictionnary
     
     - returns: String
     */
    class func getInfoFilePath(info: NSDictionary) -> String {
        var filePath = info.object(forKey: kInfoCacheKeyFileName) as! String
        
        if let type = info.object(forKey: kInfoCacheKeyType) as? String {
            switch type {
            case CacheType.IMAGE.rawValue:
                filePath = getPathImage() + "/" + filePath
                break
            case CacheType.DATA.rawValue:
                filePath = getPathData() + "/" + filePath
                break
            default:break
            }
        }
        return filePath
    }
    
    /**
     load the content form a infoCache Dictionnary
     
     - parameter info:       NSDictionnary
     - parameter completion: (errors :NSError!, data: NSData!) -> Void
     */
    class private func loadContentFromInfoCacheDictionnary(type: CacheType,
        infoCache info :NSDictionary,
        completion:(_ errors :NSError?, _ data: NSData?) -> Void) -> Void {
            
            let filePath = getInfoFilePath(info: info)
            
           debugPrint(filePath)
        
            if let data = NSData(contentsOfFile: filePath) {
                completion(nil, data)
            } else {
                completion(self.createError(error: .CANNOT_LOAD_IMAGE, desc: "cannot load data at path \(filePath)"), nil)
            }
    }
    /**
     remove all info
     */
    class func removeAllInfos() {
        
        print(self.getPathRoot())
        do {
            try FileManager.default.removeItem(atPath: self.getPathRoot())
        }
        catch { debugPrint("cannot remove main path") }
    }
    
    private class func removeAllInfoForType(type: CacheType) {
        let mainInfo = getMainInfoCacheDictionnary()
        
        let enumerator = mainInfo.keyEnumerator()
        while let key  = enumerator.nextObject() {
            if let info = mainInfo.object(forKey: key) as? NSDictionary {
                if let infoType = info.object(forKey: kInfoCacheKeyType) as? String  {
                    if infoType == type.rawValue {
                        mainInfo.removeObject(forKey: key)
                    }
                }
            }
        }
        do {
            try FileManager.default.removeItem(atPath: self.getPathImage())
        }
        catch { }
        mainInfo.write(toFile: self.pathNamefileMainInfoCache(), atomically: true)
    }
    
    /**
     remove all info data
     */
    class func removeAllInfoData() {
        removeAllInfoForType(type: SupraCacheManager.CacheType.DATA)
    }
    
    
    /**
     remove all info images
     */
    class func removeAllInfoImages() {
        removeAllInfoForType(type: SupraCacheManager.CacheType.IMAGE)
    }
    
    /**
     remove all info file & cache
     */
    class func removeAllExpiredInfo() {
        
        let mainInfo = getMainInfoCacheDictionnary()
        
        for (key,value) in mainInfo {
            if let info = value as? NSDictionary {
                let expiredDate = info.object(forKey: kInfoCacheKeyExpiredAt) as! NSDate
                // compare date file expired
                if NSDate().compare(expiredDate as Date) == ComparisonResult.orderedDescending  {
                    mainInfo.removeObject(forKey: key)
                    do {
                        try FileManager.default.removeItem(atPath: self.getInfoFilePath(info: info))
                    }
                    catch { }
                }
            }
        }
        mainInfo.write(toFile: self.pathNamefileMainInfoCache(), atomically: true)
    }
    
    /**
     Prepare to call to ressource
     
     - parameter type:         type new ressource -> CacheType
     - parameter url:          string
     - parameter expiredAt:    NSDate
     - parameter completion:   (errors :NSError!, data: NSData!)
     - parameter callResource: callResource
     */
    private class func prepareCallResource(type: CacheType, url: String,
        expiredAt: NSDate! = nil,
        completion:@escaping responseCallBack,
        callResource:callBackResource? = nil) {
            guard let callR = callResource else {
                completion(self.createError(error: .RESSOURCE_CALL_NOT_FOUND), nil)
                return
            }
            callR({ (errors: NSError!, data: NSData!) -> Void in
                if errors == nil {
                    let errors = self.createDictionnaryInfo(type: type, data: data, url: url, expiredAt: expiredAt)
                    completion(errors, data)
                } else {
                    completion(errors, nil)
                }
            } as! (NSError?, NSData?) -> Void)
    }
    
    private class func getPathImage() -> String {
        
        let dataPathImg     = getPathRoot() + "/img"
        
        if !FileManager.default.fileExists(atPath: dataPathImg) {
            do {
                try FileManager.default.createDirectory(atPath: dataPathImg, withIntermediateDirectories: false, attributes: nil)
            } catch {}
        }
        return dataPathImg
    }
    
    private  class func getPathData() -> String {
        
        let dataPathData     =  getPathRoot() + "/data"
        
        if !FileManager.default.fileExists(atPath: dataPathData) {
            do {
                try FileManager.default.createDirectory(atPath: dataPathData, withIntermediateDirectories: false, attributes: nil)
            } catch {}
        }
        return dataPathData
    }
    
    
    
    private class func getPathRoot() -> String {
        
        var path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory : String = path[0]
        
        let dataPathRoot    = documentsDirectory + "/xmcache"
        
        if !FileManager.default.fileExists(atPath: dataPathRoot) {
            do {
                try FileManager.default.createDirectory(atPath: dataPathRoot, withIntermediateDirectories: false, attributes: nil)
            } catch {}
        }
        return dataPathRoot
    }
    
    
    
    private class func setInfoCache(info: NSDictionary) {
        
        let pathMainInfoCacheDictionnary = pathNamefileMainInfoCache()
        
        guard let URL = info.object(forKey: kInfoCacheKeyURL) as? String else { return }
        
        let mainInfo = getMainInfoCacheDictionnary()
        mainInfo.setObject(info, forKey: URL as NSCopying)
        mainInfo.write(toFile: pathMainInfoCacheDictionnary, atomically: true)
    }
    
    
    private class func removeInfoCache(key: String) {
        
        let pathMainInfoCacheDictionnary = pathNamefileMainInfoCache()
        
        if let info = getMainInfoCacheDictionnary().object(forKey: key) as? NSDictionary {
            let filePath = getInfoFilePath(info: info)
            
            let fileManager = FileManager.default
            do { try fileManager.removeItem(atPath: filePath) }
            catch { }
            
            getMainInfoCacheDictionnary().removeObject(forKey: key)
            getMainInfoCacheDictionnary().write(toFile: pathMainInfoCacheDictionnary, atomically: true)
        }
    }
    
    private class func pathNamefileMainInfoCache() -> String {
        return getPathRoot() + "/xInfoCache.plist"
    }
    
    private class func getMainInfoCacheDictionnary() -> NSMutableDictionary {
        
        let pathMainInfoCacheDictionnary = pathNamefileMainInfoCache()
        
        
        var mainInfoDictionnary : NSMutableDictionary = NSMutableDictionary()
        
        if !FileManager.default.fileExists(atPath: pathMainInfoCacheDictionnary) {
            mainInfoDictionnary.write(toFile: pathMainInfoCacheDictionnary, atomically: true)
        } else {
            
            mainInfoDictionnary = NSMutableDictionary(contentsOfFile: pathMainInfoCacheDictionnary) ?? NSMutableDictionary()
        }
        return mainInfoDictionnary
    }
    
    /**
     get the file info by giving url downloading of the file
     
     - parameter key: string
     
     - returns: NSDictionary
     */
    class func getInfoCachedForFile(key: String) -> NSDictionary? {
        return getMainInfoCacheDictionnary().object(forKey: key) as? NSDictionary
    }
    
    class func updateInfoCachedForFile(key: String, canExpired: Bool, expiredAt: NSDate) {
        
        let main = self.getMainInfoCacheDictionnary()
        
        if let info = main.object(forKey:key) as? NSMutableDictionary {
            
            info.setObject(canExpired, forKey: kInfoCacheKeyCanExpired as NSCopying)
            info.setObject(expiredAt, forKey: kInfoCacheKeyExpiredAt as NSCopying)
        }
        
        main.write(toFile: self.pathNamefileMainInfoCache(), atomically: true)
    }
    
    // MARK: - TOOLS
    
    /**
    Get avalible space disk in byte
    
    - returns: NSNumber
    */
    class func getFreeSpace() -> Int64 {
        
        var length : Int64 = 0
        
        do {
            let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            length = ((systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value) ?? 0
        } catch {}
        
        return length
    }
    
    private class func randomNameFile () -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: 20)
    
        for _ in 0 ..< 20 {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString as String
    }
}
