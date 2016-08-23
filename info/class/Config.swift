//
//  Config.swift
//
//  Created by Rodrigo Nóbrega
//  Copyright © 2016 Rodrigo Nóbrega. All rights reserved.
//

import UIKit
import SwiftyJSON

//model config
class Config: NSObject {

    var images: Images?
    
    init(json: JSON){
        images = Images(json: json["images"])
    }

}
