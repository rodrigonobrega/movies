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
        Util.playSound(soundName: "change")
        
        let segment = sender as! UISegmentedControl
        //if ((delegate?.responds(to: )(#selector(updateMovieList(sender:)))) != nil) {
            (delegate as! MovieCollectionViewController).updateMovieList(indexSelected: segment.selectedSegmentIndex)
        //}
    }
    
}
