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
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: indexPath, animated: true)
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
                Connection.loadTrailers(idMovie: detail.id, onSuccess: { (retorno) -> Void in

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
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.listTrailer.count > 0 {
            
            return 2 + self.listTrailer.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//    }
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
        if indexPath.row == 0 && indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellTitle", for: indexPath as IndexPath) as! TitleTableViewCell
            
            cell.movie = movie
            
            return cell
        } else if indexPath.row == 1 && indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellDetail", for: indexPath as IndexPath) as! DetailTableViewCell
            if !loadingTrailers {
            cell.imgPoster = imagePoster
                cell.movie = movie
            }
            return cell

        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellVideo", for: indexPath as IndexPath) as! VideoTableViewCell
        let trailer = listTrailer[indexPath.row - 2]
        
        cell.lblName.text = trailer.name
        cell.selectionStyle = .default
        cell.isUserInteractionEnabled = true
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 1 && indexPath.section == 0 {
            let cell = tableView.cellForRow(at: indexPath as IndexPath) as! DetailTableViewCell
            cell.updateVote()
            return;
        }
        let trailer = listTrailer[indexPath.row - 2]
        if(trailer.site!.caseInsensitiveCompare("youtube") == ComparisonResult.orderedSame){
            let youtubeId = trailer.key!
            var url = NSURL(string:"youtube://\(youtubeId)")!
            if UIApplication.shared.canOpenURL(url as URL)  {
                UIApplication.shared.openURL(url as URL)
            } else {
                url = NSURL(string:"http://www.youtube.com/watch?v=\(youtubeId)")!
                UIApplication.shared.openURL(url as URL)
            }
        } else {
            Util.showMessage(msg: "Content not available on Youtube")
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
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

