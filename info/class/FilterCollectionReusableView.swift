//
//  FilterCollectionReusableView.swift
//
//  Created by Rodrigo Nóbrega
//  Copyright © 2016 Rodrigo Nóbrega. All rights reserved.
//

import UIKit

class FilterCollectionReusableView: UICollectionReusableView {
    
    var delegate:AnyObject?
    
    @IBAction func updateMovieList(sender: AnyObject) {
        let segment = sender as! UISegmentedControl
        if ((delegate?.respondsToSelector(#selector(updateMovieList(_:)))) != nil) {
            (delegate as! MovieCollectionViewController).updateMovieList(segment.selectedSegmentIndex)
        }
    }
    
}
