//
//  DetailViewController.swift
//
//  Created by Rodrigo Nóbrega
//  Copyright © 2016 Rodrigo Nóbrega. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {
    
    var imagePoster: UIImage?
    var listTrailer = [Trailer]()
    
    var loadingTrailers = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    var movie: Movie? {
        didSet {
            self.configureView()
        }
    }

    // load trailers and extra attributes
    func configureView() {
        if let detail = self.movie {
            if !loadingTrailers {
                loadingTrailers = true
                Connection.loadTrailers(detail.id, onSuccess: { (retorno) -> Void in

                    self.listTrailer = retorno.listTrailer
                    self.loadingTrailers = false
                    self.tableView.reloadData()
                    
                    }, onError: {
                        (NSError) -> Void in
                        self.loadingTrailers = false
                        Util.showErrorMessage()
                })
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 + self.listTrailer.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 && indexPath.section == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("CellTitle", forIndexPath: indexPath) as! TitleTableViewCell
            
            cell.movie = movie
            
            return cell
        } else if indexPath.row == 1 && indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("CellDetail", forIndexPath: indexPath) as! DetailTableViewCell
            if !loadingTrailers {
            cell.imgPoster = imagePoster
                cell.movie = movie
            }
            return cell

        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CellVideo", forIndexPath: indexPath) as! VideoTableViewCell
        let trailer = listTrailer[indexPath.row - 2]
        
        cell.lblName.text = trailer.name
        cell.selectionStyle = .Default
        cell.userInteractionEnabled = true
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 1 && indexPath.section == 0 {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! DetailTableViewCell
            cell.updateVote()
            return;
        }
        let trailer = listTrailer[indexPath.row - 2]
        if(trailer.site!.caseInsensitiveCompare("youtube") == NSComparisonResult.OrderedSame){
            let youtubeId = trailer.key!
            var url = NSURL(string:"youtube://\(youtubeId)")!
            if UIApplication.sharedApplication().canOpenURL(url)  {
                UIApplication.sharedApplication().openURL(url)
            } else {
                url = NSURL(string:"http://www.youtube.com/watch?v=\(youtubeId)")!
                UIApplication.sharedApplication().openURL(url)
            }
        } else {
            Util.showMessage("Content not available on Youtube")
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 && indexPath.section == 0 {
            return 144
        } else if indexPath.row == 1 && indexPath.section == 0 {
            return 357
        }
        return 70
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

