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
        
        self.selectionStyle = .none
        self.isUserInteractionEnabled = false
        self.contentView.backgroundColor = Util.darkColor
        self.lblTitle.textColor = originalColor
        
        if self.lblTitle.text == movie?.title {
            
            UIView.animate(withDuration: 0.2, animations: {
                self.contentView.backgroundColor = self.originalColor
                }, completion: { Void in
                    UIView.transition(with: self.lblTitle, duration: 0.2, options: .transitionFlipFromTop, animations: {
                        self.lblTitle.textColor = UIColor.white
                        }, completion: nil)
            })
        }
        self.lblTitle.text = movie?.title
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
