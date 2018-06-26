//
//  MovieCollectionViewController.swift
//
//  Created by Rodrigo Nóbrega
//  Copyright © 2016 Rodrigo Nóbrega. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MovieCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {

    
    @IBOutlet var collectionViewMovies: UICollectionView!
    
    var detailViewController: DetailViewController? = nil
    var finishedLoadMovies = false
    var error              = false
    var listMovie   = [Movie]()
    var sortBy = 0
    var page   = 1
    
    var tapWhenScrolling = false
    
    private var lastContentOffset: CGFloat = 0
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        collectionView?.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView?.reloadData()
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(MovieCollectionViewController.handleTap(sender:)))

        singleTap.cancelsTouchesInView = false
        singleTap.numberOfTapsRequired = 1
        singleTap.isEnabled = true
        singleTap.delegate = self
        self.view.addGestureRecognizer(singleTap)
        
        
        let flow = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        if #available(iOS 9.0, *) {
            flow.sectionHeadersPinToVisibleBounds = true
        }
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }

        self.collectionView?.reloadData()
        self.loadBegin()
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    func handleTap(sender:AnyObject?) {
        tapWhenScrolling = true
    }
    func loadBegin() {
        
        Connection.configApplication( onSuccess: {(message) -> Void in
            
            if let msg = message {
                Util.showMessage(msg: msg)
            } else { self.loadMovies() }
            
            }, onError: {
                (NSError) -> Void in
                Util.showErrorMessage()
                self.error = true
        })
    }
    
    func loadMovies() {
        if error {
            error = false
            loadBegin()
            return;
        }
        
        Connection.loadMovies(page: page, sort_by: sortBy, onSuccess: { (retorno) -> Void in
            self.finishedLoadMovies = true
            if retorno.listMovie.count > 0 {
                
                self.finishedLoadMovies = false
                self.listMovie.append(contentsOf: retorno.listMovie)
                
                
                var shotPercentageFloat: Float
                shotPercentageFloat = Float(self.listMovie.count)/Float(retorno.total_results!)
                
               let twoDecimalPlaces = String(format: "%.2f", shotPercentageFloat*100)
                
                self.navigationItem.prompt = "\(twoDecimalPlaces)% displayed"
                
                self.listMovie.append(Movie(json: ""))
            }
            
            self.collectionView?.reloadData()
            }, onError: {
                (NSError) -> Void in
                Util.showErrorMessage()
                self.error = true      
        })
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listMovie.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//    }
//
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//
        if indexPath.row + 1 == listMovie.count && !finishedLoadMovies { // if last element and can load more items
            let cellLoading = collectionView.dequeueReusableCell(withReuseIdentifier: "CellLoading", for: indexPath as IndexPath)
            page = page + 1
            listMovie.removeLast() //remove last element
            loadMovies()
            return cellLoading
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MovieCollectionViewCell
        let movie = listMovie[indexPath.row]
        cell.movie = movie
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let cellH = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CellHeader", for: indexPath as IndexPath) as! FilterCollectionReusableView

        let font = UIFont.systemFont(ofSize: 20)
        cellH.segmentedControl.setTitleTextAttributes([NSFontAttributeName: font],
                                                      for: .normal)
        cellH.segmentedControl.removeBorders()
        cellH.delegate = self
        cellH.segmentedControl.selectedSegmentIndex = sortBy
        return cellH
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let sizeTotal = collectionView.frame.size
        let newWidth = sizeTotal.width/2
        let newHeight = (Util.standarCellSize.height * newWidth)/Util.standarCellSize.width
        let newSize = CGSize(width: newWidth, height: newHeight)

        return newSize
    }
    
    func updateMovieList(indexSelected:Int) {
        sortBy = indexSelected
        page = 1
        self.listMovie.removeAll()
        self.collectionView?.reloadData()
        loadMovies()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//    }
//    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            
            let cellSelected = sender as! MovieCollectionViewCell
            
            if let indexPath = self.collectionView?.indexPath(for: cellSelected) {
                
                let movie = listMovie[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.movie = movie
                controller.imagePoster = cellSelected.imagePoster.image
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if tapWhenScrolling {
            navigationController?.setNavigationBarHidden(false, animated: true)
            tapWhenScrolling = false
        } else if navigationController?.isNavigationBarHidden == true {
            Util.playSound(soundName: "slide")
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        self.startAlphaToNavigation()
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage.fromColor(color: Util.darkColor.withAlphaComponent(0.4)), for: UIBarMetrics.default)
        navigationController?.setNavigationBarHidden(true, animated: true)

    }
    
    func startAlphaToNavigation() {
        var alpha = 0.5
        var tempo = 0.1
        for _ in 0...24 {
            perform(#selector(incrementAlphaToNavigation), with: NSNumber(value: alpha), afterDelay: tempo )
            alpha = alpha + 0.01
            tempo = tempo + 0.02
        }
        
    }
    
    func incrementAlphaToNavigation(alpha:NSNumber) {
        let cg = Float(alpha)
        self.navigationController!.navigationBar.setBackgroundImage(UIImage.fromColor(color: Util.darkColor.withAlphaComponent(CGFloat(cg))), for: UIBarMetrics.default)
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    
}
