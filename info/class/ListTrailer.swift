//
//  ListMovie.swift
//
//  Created by Rodrigo Nóbrega
//  Copyright © 2016 Rodrigo Nóbrega. All rights reserved.
//

import UIKit
import SwiftyJSON

// model for list of trailers
class ListTrailer: NSObject {

    var listTrailer:[Trailer]
    
    init(json: JSON) {
        
        listTrailer = []
        let list: Array<JSON> = json["results"].arrayValue
        
        for  item in list {
            listTrailer.append(Trailer(json: item))
        }
    }
}
