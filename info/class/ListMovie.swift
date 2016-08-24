//
//  ListMovie.swift
//
//  Created by Rodrigo Nóbrega
//  Copyright © 2016 Rodrigo Nóbrega. All rights reserved.
//

import UIKit
import SwiftyJSON

// model for list of movies
class ListMovie: NSObject {

    var page:           Int
    var listMovie:      [Movie]
    var totalPages:     Int?
    var total_results:  Int?
    
    init(json: JSON) {
        page            = Util.jsonIntValue(json, attribute: "page")
        totalPages      = Util.jsonIntValue(json, attribute: "total_pages")
        total_results  = Util.jsonIntValue(json, attribute: "total_results")
        
        listMovie = []
        
        let list: Array<JSON> = json["results"].arrayValue
        
        for  item in list {
            listMovie.append(Movie(json: item))
        }

    }
}
