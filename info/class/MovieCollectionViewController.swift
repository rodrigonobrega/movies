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
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        collectionView?.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        collectionView?.reloadData()
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(MovieCollectionViewController.handleTap(_:)))

        singleTap.cancelsTouchesInView = false
        singleTap.numberOfTapsRequired = 1
        singleTap.enabled = true
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
    
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    func handleTap(sender:AnyObject?) {
        tapWhenScrolling = true
    }
    func loadBegin() {
        
        Connection.configApplication( {(message) -> Void in
            
            if let msg = message {
                Util.showMessage(msg)
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
        
        Connection.loadMovies(page, sort_by: sortBy, onSuccess: { (retorno) -> Void in
            self.finishedLoadMovies = true
            if retorno.listMovie.count > 0 {
                
                self.finishedLoadMovies = false
                self.listMovie.appendContentsOf(retorno.listMovie)
                
                
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
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listMovie.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.row + 1 == listMovie.count && !finishedLoadMovies { // if last element and can load more items
            let cellLoading = collectionView.dequeueReusableCellWithReuseIdentifier("CellLoading", forIndexPath: indexPath)
            page = page + 1
            listMovie.removeLast() //remove last element
            loadMovies()
            return cellLoading
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MovieCollectionViewCell
        let movie = listMovie[indexPath.row]
        cell.movie = movie
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let cellH = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "CellHeader", forIndexPath: indexPath) as! FilterCollectionReusableView

        let font = UIFont.systemFontOfSize(20)
        cellH.segmentedControl.setTitleTextAttributes([NSFontAttributeName: font],
                                                forState: UIControlState.Normal)
        cellH.segmentedControl.removeBorders()
        cellH.delegate = self
        cellH.segmentedControl.selectedSegmentIndex = sortBy
        return cellH
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        let sizeTotal = collectionView.frame.size
        let newWidth = sizeTotal.width/2
        let newHeight = (Util.standarCellSize.height * newWidth)/Util.standarCellSize.width
        let newSize = CGSizeMake(newWidth, newHeight)

        return newSize
    }
    
    func updateMovieList(indexSelected:Int) {
        sortBy = indexSelected
        page = 1
        self.listMovie.removeAll()
        self.collectionView?.reloadData()
        loadMovies()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            
            let cellSelected = sender as! MovieCollectionViewCell
            
            if let indexPath = self.collectionView?.indexPathForCell(cellSelected) {
                
                let movie = listMovie[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.movie = movie
                controller.imagePoster = cellSelected.imagePoster.image
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        if tapWhenScrolling {
            navigationController?.setNavigationBarHidden(false, animated: true)
            tapWhenScrolling = false
        } else if navigationController?.navigationBarHidden == true {
            Util.playSound("slide")
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        self.startAlphaToNavigation()
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage.fromColor(Util.darkColor.colorWithAlphaComponent(0.4)), forBarMetrics: UIBarMetrics.Default)
        navigationController?.setNavigationBarHidden(true, animated: true)

    }
    
    func startAlphaToNavigation() {
        var alpha = 0.5
        var tempo = 0.1
        for _ in 0...24 {
            performSelector(#selector(incrementAlphaToNavigation), withObject: NSNumber(double: alpha), afterDelay: tempo )
            alpha = alpha + 0.01
            tempo = tempo + 0.02
        }
        
    }
    
    func incrementAlphaToNavigation(alpha:NSNumber) {
        let cg = Float(alpha)
        self.navigationController!.navigationBar.setBackgroundImage(UIImage.fromColor(Util.darkColor.colorWithAlphaComponent(CGFloat(cg))), forBarMetrics: UIBarMetrics.Default)
    }
    
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    
}
