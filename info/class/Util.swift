//
//  Util.swift
//
//  Created by Rodrigo Nóbrega
//

import UIKit
import AlamofireImage
import SwiftyJSON
import AudioToolbox

class Util: NSObject {
    
    static let standarCellSize  = CGSizeMake(160, 240)// use for set default size in movie controller

    // verify internet access
    class func isConnectToNetwork() -> Bool {
        return Reachability.isConnectedToNetwork()
    }
    
    class func playSound(soundName:String) {
                
        dispatch_async(dispatch_get_main_queue(), {
            var mySound: SystemSoundID = 0
            let sound0 = NSBundle.mainBundle().URLForResource(soundName, withExtension: "wav")
            AudioServicesCreateSystemSoundID(sound0!, &mySound)
            AudioServicesPlaySystemSound(mySound);
        })

    }
    
    class  func vibrate() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    // show a default internet message error
    class func showErrorMessage() {
        UIAlertView(title: "Erro", message: "Make sure your device is connected to the internet", delegate: nil, cancelButtonTitle: "Ok").show()
    }
    
    // show a parameter msg
    class func showMessage(msg:String) {
        UIAlertView(title: "Info", message: msg, delegate: nil, cancelButtonTitle: "Ok").show()
    }
    
    //MARK: = Image Caching
    static let imageCache = AutoPurgingImageCache(
        memoryCapacity: 100 * 1024 * 1024,
        preferredMemoryUsageAfterPurge: 60 * 1024 * 1024
    )
    
    class func cacheImage(image: Image, urlString: String) {
        imageCache.addImage(image, withIdentifier: urlString)
    }
    
    class func cachedImage(urlString: String) -> Image? {
        return imageCache.imageWithIdentifier(urlString)
    }
    
    //MARK: = JSON string and int access
    class func jsonStringValue(json:JSON ,attribute: String) -> String {
        return json[attribute].string ?? ""
    }
    
    class func jsonIntValue(json:JSON ,attribute: String) -> Int {
        return json[attribute].int ?? 0
    }
    
    //MARK: = Save attibute in NSUserDefaults
    class func saveAttribute(value:String, key:String) {
        NSUserDefaults.standardUserDefaults().setValue(value, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    //MARK: = get base url and base image size from NSUserDefaults
    class func getBaseUrl() -> String {
        return NSUserDefaults.standardUserDefaults().stringForKey("base_url")!
    }
    
    class func getBaseSize() -> String {
        return NSUserDefaults.standardUserDefaults().stringForKey("base_size")!
    }
}
