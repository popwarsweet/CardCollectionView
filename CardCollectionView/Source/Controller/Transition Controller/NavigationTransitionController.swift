//
//  NavigationTransitionController.swift
//  CardCollectionView
//
//  Created by Kyle Zaragoza on 7/11/16.
//  Copyright © 2016 Kyle Zaragoza. All rights reserved.
//

import UIKit

class NavigationTransitionController: NSObject, UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController,
                              animationControllerForOperation operation: UINavigationControllerOperation,
                              fromViewController fromVC: UIViewController,
                              toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // if coming from or going to card controller, use our animation controller
        if operation == .Push {
            if fromVC is CardCollectionViewController {
                return CardToDetailViewAnimator()
            }
        } else if operation == .Pop {
            if toVC is CardCollectionViewController {
                return DetailViewToCardAnimator()
            }
        }
        return nil
    }
}
