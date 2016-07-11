//
//  CardLayout.swift
//  CardCollectionView
//
//  Created by Kyle Zaragoza on 7/11/16.
//  Copyright © 2016 Kyle Zaragoza. All rights reserved.
//

import UIKit

class CardLayout: UICollectionViewFlowLayout {
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // init setup
        self.scrollDirection = .Horizontal
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        self.itemSize = CGSize(width: 282, height: 428)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutAtts = super.layoutAttributesForElementsInRect(rect) else { return nil }
        // we copy layout attributes here to avoid collection view cache diff warning
        let modifiedLayoutAtts = Array(NSArray(array: layoutAtts, copyItems: true)) as! [UICollectionViewLayoutAttributes]
        let visibleRect = CGRect(origin: self.collectionView!.contentOffset, size: self.collectionView!.bounds.size)
        let activeWidth = self.collectionView!.bounds.size.width
        // adjust zoom of each cell so that the center cell is at 1x, while surrounding cells are as low as 0.9x depending on distance from center
        for attributes in modifiedLayoutAtts {
            if attributes.frame.intersects(visibleRect) {
                let distance = visibleRect.midX - attributes.center.x
                let normalDistance = distance / activeWidth
                if (abs(distance) < activeWidth) {
                    // tranlate
                    let yOffset = -10 * (1 - abs(normalDistance))
                    let offsetTransform = CATransform3DMakeTranslation(0, yOffset, 0)
                    // scale
                    let zoom = 0.90 + 0.1 * (1 - abs(normalDistance))
                    attributes.transform3D = CATransform3DScale(offsetTransform, zoom, zoom, 1)
                    attributes.zIndex = 1
                    // opacity
                    let alpha = 0.5 + 0.5 * (1-abs(normalDistance))
                    attributes.alpha = alpha
                }
            }
        }
        
        return modifiedLayoutAtts
    }

}
