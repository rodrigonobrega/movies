//
//  Images.swift
//
//  Created by Rodrigo Nóbrega
//  Copyright © 2016 Rodrigo Nóbrega. All rights reserved.
//

import UIKit
import SwiftyJSON

//model images for using in config call
class Images: NSObject {

    var baseUrl:        String!
    var posterSizes:    [String]
    
    init(json: JSON) {
        baseUrl = Util.jsonStringValue(json: json, attribute: "base_url")
        
        posterSizes = []
        
        let list: Array<JSON> = json["poster_sizes"].arrayValue
        
        for  item in list {
            posterSizes.append(item.string!)
        }
        
        Util.saveAttribute(value: baseUrl, key: "base_url")
        if posterSizes.count > 0 {
            Util.saveAttribute(value: posterSizes[posterSizes.count/2], key: "base_size")
        }
    }
}
