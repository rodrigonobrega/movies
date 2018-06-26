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
        
        //Alamofire.request(.GET, urlString)
        Alamofire.request(urlString)
            .responseImage { response in
                if let image = response.result.value {
                    self.image = image
                    Util.cacheImage(image: image, urlString: urlString)
                }
        }
    }
    
    
        
    
        
    
}

extension UIImage {
    
    func imageWithAlpha(alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let img = newImage {
            return img
        }
        return UIImage()
    }
    
    
    
        static func fromColor(color: UIColor) -> UIImage {
            let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
            UIGraphicsBeginImageContext(rect.size)
            let context = UIGraphicsGetCurrentContext()
            context!.setFillColor(color.cgColor)
            context!.fill(rect)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            if let new = img {
                return new
            }
            return UIImage()
        }
    
}

extension UISegmentedControl {
    func removeBorders() {
        setBackgroundImage(imageWithColor(color: backgroundColor!), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: tintColor!), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        //let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}
