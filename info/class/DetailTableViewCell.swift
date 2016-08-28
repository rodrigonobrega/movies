//
//  DetailTableViewCell.swift
//
//  Created by Rodrigo Nóbrega
//  Copyright © 2016 Rodrigo Nóbrega. All rights reserved.
//

import UIKit

protocol VoteControl {
    func updateVote();
}

class DetailTableViewCell: UITableViewCell, VoteControl {

    @IBOutlet weak var imagePoster: UIImageView!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var lblYear:     UILabel!
    @IBOutlet weak var lblAverage:  UILabel!
    @IBOutlet weak var labelVote:   UILabel!
    @IBOutlet weak var lblRuntime:  UILabel!
    @IBOutlet weak var lblGenre:    UILabel!
    
    var movie: Movie! {
        didSet{
            if movie != nil {
                self.configureCell()
            }
        }
    }
    
    var imgPoster:UIImage! {
        didSet{
            showImage()
        }
    }
    
    func showImage() {
        if imgPoster == nil {
            return
        }
        let frame = self.imagePoster.frame
        var newFrame = frame
        
        newFrame.origin.x = -frame.size.width * 2
        newFrame.size.height = newFrame.size.height * 2
        newFrame.size.width = newFrame.size.width * 2
        self.imagePoster.frame = newFrame
        
        UIView.animateWithDuration(0.4, animations: {
            self.imagePoster.frame = frame
            }) { (Bool) in
                Util.playSound("drop")
                self.performSelector(#selector(self.averageVoteStart), withObject: nil, afterDelay: 0.2)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        resetCell()
    }
    
    func resetCell() {
        if movie == nil {
            self.lblAverage.text    = ""
            self.lblYear.text       = ""
            self.lblOverview.text   = ""
            self.labelVote.text     = ""
            self.lblRuntime.text    = ""
            self.lblGenre.text      = ""
            return
        } else {
          self.labelVote.text = "⭐️";
        }
    }
    
    func configureCell() {
        
        
        Connection.loadMovieExtraData(movie.id, onSuccess: { (retorno) -> Void in
            
            self.movie!.runtime = retorno.runtime
            self.movie?.genres = retorno.genres
            
            if self.movie?.runtime == 0 {
                self.lblRuntime.text = "loading..."
            } else {
                self.lblRuntime.text = String(format: "%dmin", (self.movie?.runtime)!)
            }
            
            for value in self.movie.genres {
                
                if self.lblGenre.text == "" {
                    self.lblGenre.text = "\(value)"
                } else {
                    self.lblGenre.text = "\(self.lblGenre.text!), \(value)"
                }
            }
            
            }, onError: { (NSError) -> Void in
                
                Util.showErrorMessage()
        })
        
        
        if let average = movie?.voteAverage ?? nil {
            self.lblAverage.text = String(format: "%@/10", String(average))
        }
        
        if let img = imgPoster {
            self.imagePoster.image = img
            self.imagePoster.setNeedsDisplay()
        }
        
        self.lblOverview.text = movie?.overview
        if let date = movie?.releaseDate {
            self.lblYear.text = date.componentsSeparatedByString("-")[0]
        }
    }
    
    
    func updateVote() {
        
        self.labelVote.text = "\(self.labelVote.text!)⭐️";
        let charsCount = self.labelVote.text?.characters.count
        if charsCount >= 6 {
            self.labelVote.text = "⭐️";
            Util.playSound("vote0")
        } else {
            if charsCount == 5 {
                Util.vibrate()
            }
            Util.playSound("vote1")
        }

    }
    
    func averageVoteStart() {
        let average = Int(movie.voteAverage!)
        let averageStars = average/2
        self.labelVote.text = "";
        
        for index in 0...averageStars {
            let delay = 0.2 * Double(index)
            self.performSelector(#selector(update), withObject: nil, afterDelay: NSTimeInterval(delay))
        }
    }
    
    func update() {
        self.labelVote.text = "\(self.labelVote.text!)⭐️";
        Util.playSound("tick")
        self.labelVote.setNeedsLayout()
    }
}
