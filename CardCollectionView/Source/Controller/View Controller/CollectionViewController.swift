//
//  CollectionViewController.swift
//  CardCollectionView
//
//  Created by Kyle Zaragoza on 7/11/16.
//  Copyright © 2016 Kyle Zaragoza. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    /// The pan gesture will be used for this scroll view so the collection view can page items smaller than it's width
    lazy var pagingScrollView: UIScrollView = { [unowned self] in
        let scrollView = UIScrollView()
        scrollView.hidden = true
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        return scrollView
    }()
    
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove nav
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // inset collection view left/right-most cards can be centered
        let flowLayout = self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        let edgePadding = (self.collectionView!.bounds.size.width - flowLayout.itemSize.width)/2
        self.collectionView!.contentInset = UIEdgeInsets(top: 0, left: edgePadding, bottom: 0, right: edgePadding)
        
        // style
        let backgroundView: UIView = {
            let view = UIView(frame: self.view.bounds)
            let gradient = CAGradientLayer()
            gradient.frame = view.frame
            gradient.startPoint = CGPoint.zero
            gradient.endPoint = CGPoint(x: 1, y: 1)
            gradient.colors = [
                UIColor(hue: 214/360, saturation: 4/100, brightness: 44/100, alpha: 1).CGColor,
                UIColor(hue: 240/360, saturation: 14/100, brightness: 17/100, alpha: 1).CGColor
            ]
            view.layer.addSublayer(gradient)
            return view
        }()
        self.collectionView?.backgroundView = backgroundView

        // Register cell classes
        self.collectionView!.registerClass(CardCollectionViewCell.self, forCellWithReuseIdentifier: CardCollectionViewCellConst.reuseId)

        // add scroll view which we'll hijack scrolling from
        let scrollViewFrame = CGRect(
            x: self.view.bounds.width,
            y: 0,
            width: flowLayout.itemSize.width,
            height: self.view.bounds.height)
        pagingScrollView.frame = scrollViewFrame
        pagingScrollView.contentSize = CGSize(width: flowLayout.itemSize.width*4, height: self.view.bounds.height)
        self.collectionView!.superview!.insertSubview(pagingScrollView, belowSubview: self.collectionView!)
        self.collectionView!.addGestureRecognizer(pagingScrollView.panGestureRecognizer)
        self.collectionView!.scrollEnabled = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CardCollectionViewCellConst.reuseId, forIndexPath: indexPath)
        return cell
    }
}


// MARK: - Scroll Delegate

extension CollectionViewController {
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView === pagingScrollView {
            // adjust collection view scroll view to match paging scroll view
            let contentOffset = CGPoint(x: scrollView.contentOffset.x - self.collectionView!.contentInset.left,
                                        y: self.collectionView!.contentOffset.y)
            self.collectionView!.contentOffset = contentOffset
        }
    }
}
