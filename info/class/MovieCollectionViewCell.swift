//
//  MovieCollectionViewCell.swift
//
//  Created by Rodrigo Nóbrega
//  Copyright © 2016 Rodrigo Nóbrega. All rights reserved.
//

import UIKit
import Alamofire

class MovieCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var imagePoster: UIImageView!
    
    var movie: Movie! {
        didSet {
            self.configureCell()
        }
    }
    
    func configureCell() {
        
        self.imagePoster.image = UIImage(named: "loading")
        
        if let imgURL = createUrlImage() {
            if let img = Util.cachedImage(urlString: imgURL){
                self.imagePoster.image = img
            } else {
                self.imagePoster.imageFromUrl(urlString: imgURL)
            }
        }     }
    
    func createUrlImage() -> String? {
        if movie.posterImg == "" {
            self.imagePoster.image = UIImage(named: "not_loading")
            return nil
        }
        
        if let imgURL = movie.posterImg {
            let newImageUrl = Util.getBaseUrl() + Util.getBaseSize() + imgURL
            
            return newImageUrl
        }
        return nil
        
    }
    
}
