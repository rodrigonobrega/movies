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
    
    static let standarCellSize = CGSize(width: 160, height: 240)// CGSizeMake(160, 240)// use for set default size in movie controller
    static let darkColor       = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
    
    // verify internet access
    class func isConnectToNetwork() -> Bool {
        return Reachability.isConnectedToNetwork()
    }
    
    class func playSound(soundName:String) {
        
        DispatchQueue.main.async {
            
        
        
        //dispatch_async(dispatch_get_main_queue(), {
            var mySound: SystemSoundID = 0
            let sound0 = Bundle.main.url(forResource: soundName, withExtension: "wav")
            AudioServicesCreateSystemSoundID(sound0! as CFURL, &mySound)
            AudioServicesPlaySystemSound(mySound);
        }//)

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
        imageCache.add(image, withIdentifier: urlString)
    }
    
    class func cachedImage(urlString: String) -> Image? {
        return imageCache.image(withIdentifier: urlString)
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
        UserDefaults.standard.setValue(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    //MARK: = get base url and base image size from NSUserDefaults
    class func getBaseUrl() -> String {
        return UserDefaults.standard.string(forKey: "base_url")!
    }
    
    class func getBaseSize() -> String {
        return UserDefaults.standard.string(forKey: "base_size")!
    }
}
