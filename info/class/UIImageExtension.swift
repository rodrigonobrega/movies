//
//  UIImageExtension.swift
//
//  Created by Rodrigo Nóbrega
//

import UIKit
import Alamofire

class UIImageExtension: NSObject {}

extension UIImageView {
    
    //Download image and put in cache
    public func imageFromUrl(urlString: String) {
        Alamofire.request(.GET, urlString)
            .responseImage { response in
                if let image = response.result.value {
                    self.image = image
                    Util.cacheImage(image, urlString: urlString)
                }
        }
    }
}
