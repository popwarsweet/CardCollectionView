//
//  DetailViewToCardAnimator.swift
//  CardCollectionView
//
//  Created by Kyle Zaragoza on 7/11/16.
//  Copyright © 2016 Kyle Zaragoza. All rights reserved.
//

import UIKit

class DetailViewToCardAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        guard toViewController is CardCollectionViewController else { fatalError("\(String(self))) should only be used to transition to card view") }
        let cardController = toViewController as! CardCollectionViewController
        let cardFrame = cardController.beginFrameForTransition()
        let cardView = cardController.viewForTransition()
        let cardViewSnapshot = fromViewController.view.snapshotViewAfterScreenUpdates(false)
        // match corner radius to target views
        cardView.hidden = true
        cardViewSnapshot.layer.cornerRadius = cardView.layer.cornerRadius
        cardViewSnapshot.clipsToBounds = true
        cardViewSnapshot.frame = fromViewController.view.bounds
        // add required view to context
        transitionContext.containerView()?.addSubview(toViewController.view)
        transitionContext.containerView()?.addSubview(cardViewSnapshot)
        // animate
        UIView.animateWithDuration(
            self.transitionDuration(transitionContext),
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 12,
            options: [],
            animations: {
                cardViewSnapshot.frame = cardFrame
            }, completion: { _ in
                // finish animation and transition
                cardView.hidden = false
                cardViewSnapshot.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                
        })
    }
}
