//
//  Connection.swift
//
//  Created by Rodrigo Nóbrega
//

import UIKit
import Alamofire
import SwiftyJSON
import WatchConnectivity

class Connection: NSObject, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    
    static let sortPopularity = "popular"
    static let sortAverage = "top_rated"
    
    //MARK: = urls base
    static let api_key          = "xxx" //Please use your key
    static let server           = "http://api.themoviedb.org/3"
    static let urlConfig        = "\(server)/configuration?api_key=%@"           //config
    static let urlList          = "\(server)/movie/%@?api_key=\(api_key)&page=%d"  //movie list
    static let urlVideos        = "\(server)/movie/%d/videos?api_key=\(api_key)" //trailer list
    static let urlMovieExtra    = "\(server)/movie/%d?api_key=\(api_key)"   // one movie extra details
    
    // call config url
    class func configApplication(onSuccess:@escaping (_ message:String?) -> Void, onError:@escaping (NSError) -> Void) {
        let url = String(format: urlConfig, api_key)
        
        if !Util.isConnectToNetwork() {
            onError(NSError(domain: url, code: -999, userInfo: nil))
            return;
        }
        
        Alamofire.request(url).responseJSON { (responseData) in
            if let json = responseData.result.value {
                let js = JSON(json)
                _ = Config(json: js)
                if js["status_code"] != nil{
                    if let msg = js["status_message"].string {
                        onSuccess(msg)
                    } else {
                        onSuccess("Please verify your API Key")
                    }
                } else {
                    onSuccess(nil)
                }
            } else {
                onError(NSError(domain: url, code: (responseData.result.error?._code)!, userInfo: nil))
            }
        }
        
//        Alamofire.request(.GET, url).responseJSON { (responseData) -> Void in
//            if let json = responseData.result.value {
//                let js = JSON(json)
//                _ = Config(json: js)
//                if js["status_code"] != nil{
//                    if let msg = js["status_message"].string {
//                        onSuccess(message: msg)
//                    } else {
//                        onSuccess(message: "Please verify your API Key")
//                    }
//                } else {
//                    onSuccess(message: nil)
//                }
//            } else {
//                onError(NSError(domain: url, code: (responseData.result.error?.code)!, userInfo: nil))
//            }
//        }
    }
    
    // load movies by page - 20 per call
    class func loadMovies(page:Int, sort_by:Int, onSuccess: @escaping (_ retorno: ListMovie) -> Void, onError: @escaping (NSError) -> Void) {
        var sort = sortPopularity
        if sort_by == 1 {
            sort = sortAverage
        }
        
        let url = String(format: urlList, sort,page)
        
        if !Util.isConnectToNetwork() {
            onError(NSError(domain: url, code: -999, userInfo: nil))
            return;
        }
        
        Alamofire.request(url).responseJSON { (responseData) in
        //Alamofire.request(.GET, url).responseJSON { (responseData) -> Void in
            
            if let json = responseData.result.value {
                let js = JSON(json)
                let listMovie = ListMovie(json: js)
                onSuccess(listMovie)
            } else {
                onError(NSError(domain: url, code: (responseData.result.error?._code)!, userInfo: nil))
            }
        }
    }
    
    // load trailers by id movie
    class func loadTrailers(idMovie:Int, onSuccess: @escaping (_ retorno: ListTrailer) -> Void, onError: @escaping (NSError) -> Void) {
        
        let url = String(format: urlVideos, idMovie)
        
        if !Util.isConnectToNetwork() {
            onError(NSError(domain: url, code: -999, userInfo: nil))
            return;
        }
        
        Alamofire.request(url).responseJSON { (responseData) in
        //Alamofire.request(.GET, url).responseJSON { (responseData) -> Void in
            
            if let json = responseData.result.value {
                let js = JSON(json)
                let listTrailer = ListTrailer(json: js)
                onSuccess(listTrailer)
            } else {
                onError(NSError(domain: url, code: (responseData.result.error?._code)!, userInfo: nil))
            }
        }
    }
    
    //call extra for other attributes thats haven't in first call, like runtime
    class func loadMovieExtraData(idMovie:Int, onSuccess: @escaping (_ retorno: Movie) -> Void, onError: @escaping (NSError) -> Void) {
        
        let url = String(format: urlMovieExtra, idMovie)
        
        if !Util.isConnectToNetwork() {
            onError(NSError(domain: url, code: -999, userInfo: nil))
            return;
        }
        
        Alamofire.request(url).responseJSON { (responseData) in
        //Alamofire.request(.GET, url).responseJSON { (responseData) -> Void in
            
            if let json = responseData.result.value {
                let js = JSON(json)
                let movie = Movie(json: js)
                onSuccess(movie)
            } else {
                onError(NSError(domain: url, code: (responseData.result.error?._code)!, userInfo: nil))
            }
        }
    }
    
}
