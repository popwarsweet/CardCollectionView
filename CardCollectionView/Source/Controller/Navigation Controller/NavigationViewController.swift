//
//  NavigationViewController.swift
//  CardCollectionView
//
//  Created by Kyle Zaragoza on 7/11/16.
//  Copyright © 2016 Kyle Zaragoza. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    var statusBarStyle = UIStatusBarStyle.LightContent
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return statusBarStyle
    }
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        // keep status bar updated
        updateStatusBarForTopViewController()
    }
    
    override func popViewControllerAnimated(animated: Bool) -> UIViewController? {
        let vc = super.popViewControllerAnimated(animated)
        // keep status bar updated
        updateStatusBarForTopViewController()
        return vc
    }
    
    override func popToRootViewControllerAnimated(animated: Bool) -> [UIViewController]? {
        let vcs = super.popToRootViewControllerAnimated(animated)
        // keep status bar updated
        updateStatusBarForTopViewController()
        return vcs
    }
    
    private func updateStatusBarForTopViewController() {
        if let top = self.topViewController {
            statusBarStyle = top.preferredStatusBarStyle()
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

}
