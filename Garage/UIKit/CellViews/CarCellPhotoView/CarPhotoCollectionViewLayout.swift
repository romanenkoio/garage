//
//  CarPhotoCollectionViewLayout.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 10.07.23.
//

import UIKit

final class CarPhotoCollectionViewLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        var offsetAdjusment = CGFloat.greatestFiniteMagnitude
        let horizontalCenter = proposedContentOffset.x + (collectionView.bounds.width / 2)
        
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)
        layoutAttributesArray?.forEach({ (layoutAttributes) in
            let itemHorizontalCenter = layoutAttributes.center.x
            
            if abs(itemHorizontalCenter - horizontalCenter) < abs(offsetAdjusment) {
                if abs(velocity.x) < 0.3 {
                    offsetAdjusment = itemHorizontalCenter - horizontalCenter
                } else if velocity.x > 0 {
                    offsetAdjusment = itemHorizontalCenter - horizontalCenter + layoutAttributes.bounds.width
                } else {
                    offsetAdjusment = itemHorizontalCenter - horizontalCenter - layoutAttributes.bounds.width
                }
            }
        })
        
        return CGPoint(x: proposedContentOffset.x + offsetAdjusment, y: proposedContentOffset.y)
    }
}
