//
//  CollectionViewController.swift
//  CardCollectionView
//
//  Created by Kyle Zaragoza on 7/11/16.
//  Copyright © 2016 Kyle Zaragoza. All rights reserved.
//

import UIKit

class CardCollectionViewController: UICollectionViewController {
    /// The pan gesture will be used for this scroll view so the collection view can page items smaller than it's width
    lazy var pagingScrollView: UIScrollView = { [unowned self] in
        let scrollView = UIScrollView()
        scrollView.hidden = true
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        return scrollView
    }()
    
    /// Layer used for styling the background view
    private lazy var backgroundGradientLayer: CAGradientLayer = { [unowned self] in
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.colors = [
            UIColor(hue: 214/360, saturation: 4/100, brightness: 44/100, alpha: 1).CGColor,
            UIColor(hue: 240/360, saturation: 14/100, brightness: 17/100, alpha: 1).CGColor
        ]
        return gradient
    }()
    
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // inset collection view left/right-most cards can be centered
        let flowLayout = self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        let edgePadding = (self.collectionView!.bounds.size.width - flowLayout.itemSize.width)/2
        self.collectionView!.contentInset = UIEdgeInsets(top: 0, left: edgePadding, bottom: 0, right: edgePadding)
        
        // style
        self.collectionView?.backgroundView = {
            let view = UIView(frame: self.view.bounds)
            view.layer.addSublayer(self.backgroundGradientLayer)
            return view
        }()

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
    
    
    // MARK: - Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradientLayer.frame = self.view.bounds
    }
    
    
    // MARK: - Status Bar
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}


// MARK: - Collection View Delegate

extension CardCollectionViewController {
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = DetailViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


// MARK: - Collection View Datasource

extension CardCollectionViewController {
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

extension CardCollectionViewController {
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView === pagingScrollView {
            // adjust collection view scroll view to match paging scroll view
            let contentOffset = CGPoint(x: scrollView.contentOffset.x - self.collectionView!.contentInset.left,
                                        y: self.collectionView!.contentOffset.y)
            self.collectionView!.contentOffset = contentOffset
        }
    }
}


// MARK: - Transition Delegate

extension CardCollectionViewController: CardToDetailViewAnimating {
    // returns index path at center of screen (if there is one)
    private func centeredIndexPath() -> NSIndexPath? {
        guard let collectionView = self.collectionView else { return nil }
        let centerPoint = CGPoint(x: collectionView.contentOffset.x + self.view.bounds.midX,
                                  y: collectionView.bounds.midY)
        return collectionView.indexPathForItemAtPoint(centerPoint)
    }
    // returns cell at center of screen (if there is one)
    private func centeredCell() -> UICollectionViewCell? {
        guard let collectionView = self.collectionView else { return nil }
        if let indexPath = centeredIndexPath() {
            return collectionView.cellForItemAtIndexPath(indexPath)
        } else {
            return nil
        }
    }
    func viewForTransition() -> UIView {
        guard let cell = centeredCell() else { fatalError("this transition should never exist w/o starting cell") }
        return cell
    }
    func beginFrameForTransition() -> CGRect {
        guard let indexPath = centeredIndexPath() else { fatalError("this transition should never exist w/o starting index path") }
        guard let attributes = self.collectionView!.collectionViewLayout.layoutAttributesForItemAtIndexPath(indexPath) else { fatalError("layout is not returning attributes for path: \(indexPath)") }
        // get frame of centered cell, converting to window coordinates
        var frame = attributes.frame
        frame.origin.x -= self.collectionView!.contentOffset.x
        frame.origin.y += self.topLayoutGuide.length + CardLayoutConst.maxYOffset
        return frame
    }
}
