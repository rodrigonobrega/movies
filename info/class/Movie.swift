//
//  Movie.swift
//
//  Created by Rodrigo Nóbrega
//  Copyright © 2016 Rodrigo Nóbrega. All rights reserved.
//

import UIKit
import SwiftyJSON

// model movie
class Movie: NSObject {

    var id:         Int
    var posterImg:  String?
    var overview:   String?
    var releaseDate:String?
    var title:      String?
    var voteAverage:Double?
    
    //extraData call
    var runtime:Int?
    var genres:[String]
    
    init(json: JSON) {
        posterImg   = Util.jsonStringValue(json, attribute: "poster_path")
        overview    = Util.jsonStringValue(json, attribute: "overview")
        releaseDate = Util.jsonStringValue(json, attribute: "release_date")
        title       = Util.jsonStringValue(json, attribute: "title")
        id          = Util.jsonIntValue(json, attribute: "id")
        runtime     = Util.jsonIntValue(json, attribute: "runtime")
        voteAverage = json["vote_average"].double
        
        genres = []
        let list: Array<JSON> = json["genres"].arrayValue
        
        for  item in list {
            genres.append(item["name"].string!)
        }
    }
}
