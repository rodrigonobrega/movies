//
//  TitleTableViewCell.swift
//
//  Created by Rodrigo Nóbrega
//  Copyright © 2016 Rodrigo Nóbrega. All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    
    let originalColor   = UIColor(red: 0, green: 157/255, blue: 139/255, alpha: 1)
    
    
    var movie: Movie! {
        didSet{
            if movie != nil {
                self.configureCell()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblTitle.text = "No movie selected"
    }
    
    func configureCell() {
        
        self.selectionStyle = .None
        self.userInteractionEnabled = false
        self.contentView.backgroundColor = Util.darkColor
        self.lblTitle.textColor = originalColor
        
        if self.lblTitle.text == movie?.title {
            
            UIView.animateWithDuration(0.2, animations: {
                self.contentView.backgroundColor = self.originalColor
                }, completion: { Void in
                    UIView.transitionWithView(self.lblTitle, duration: 0.2, options: .TransitionFlipFromTop, animations: {
                        self.lblTitle.textColor = UIColor.whiteColor()
                        }, completion: nil)
            })
        }
        self.lblTitle.text = movie?.title
    }
    
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
