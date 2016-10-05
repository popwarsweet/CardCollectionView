//
//  NavigationTransitionController.swift
//  CardCollectionView
//
//  Created by Kyle Zaragoza on 7/11/16.
//  Copyright © 2016 Kyle Zaragoza. All rights reserved.
//

import UIKit

class NavigationTransitionController: NSObject, UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationControllerOperation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // if coming from or going to card controller, use our animation controller
        if operation == .push {
            if fromVC is CardCollectionViewController {
                return CardToDetailViewAnimator()
            }
        } else if operation == .pop {
            if toVC is CardCollectionViewController {
                return DetailViewToCardAnimator()
            }
        }
        return nil
    }
    
}
