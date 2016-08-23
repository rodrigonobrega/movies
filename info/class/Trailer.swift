//
//  Movie.swift
//
//  Created by Rodrigo Nóbrega
//  Copyright © 2016 Rodrigo Nóbrega. All rights reserved.
//

import UIKit
import SwiftyJSON

// model trailer
class Trailer: NSObject {

    var id:     Int
    var site:   String?
    var name:   String?
    var type:   String?
    var key:    String?
    
    init(json: JSON) {
        id   = Util.jsonIntValue(json, attribute: "id")
        site = Util.jsonStringValue(json, attribute: "site")
        name = Util.jsonStringValue(json, attribute: "name")
        type = Util.jsonStringValue(json, attribute: "type")
        key  = Util.jsonStringValue(json, attribute: "key")
    }

}