//
//  FilterCollectionReusableView.swift
//
//  Created by Rodrigo Nóbrega
//  Copyright © 2016 Rodrigo Nóbrega. All rights reserved.
//


import UIKit

class FilterCollectionReusableView: UICollectionReusableView {
    
    var delegate:AnyObject?
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func updateMovieList(sender: AnyObject) {
        Util.playSound("change")
        
        let segment = sender as! UISegmentedControl
        if ((delegate?.respondsToSelector(#selector(updateMovieList(_:)))) != nil) {
            (delegate as! MovieCollectionViewController).updateMovieList(segment.selectedSegmentIndex)
        }
    }
    
}
