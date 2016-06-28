//
//  UPCarouselFlowLayout.swift
//  UPCarouselFlowLayoutDemo
//
//  Created by Paul Ulric on 23/06/2016.
//  Copyright © 2016 Paul Ulric. All rights reserved.
//

import UIKit


public enum UPCarouselFlowLayoutSpacingMode {
    case fixed(spacing: CGFloat)
    case overlap(visibleOffset: CGFloat)
}


public class UPCarouselFlowLayout: UICollectionViewFlowLayout {
    
    private struct LayoutState {
        var size: CGSize
        var direction: UICollectionViewScrollDirection
        func isEqual(otherState: LayoutState) -> Bool {
            return CGSizeEqualToSize(self.size, otherState.size) && self.direction == otherState.direction
        }
    }
    
    @IBInspectable public var sideItemScale: CGFloat = 0.6
    @IBInspectable public var sideItemAlpha: CGFloat = 0.6
    public var spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: 40)
    
    private var state = LayoutState(size: CGSizeZero, direction: .Horizontal)
    
    
    override public func prepareLayout() {
        super.prepareLayout()
        
        let currentState = LayoutState(size: self.collectionView!.bounds.size, direction: self.scrollDirection)
        
        if !self.state.isEqual(currentState) {
            self.setupCollectionView()
            self.updateLayout()
            self.state = currentState
        }
    }
    
    private func setupCollectionView() {
        guard let collectionView = self.collectionView else { return }
        if collectionView.decelerationRate != UIScrollViewDecelerationRateFast {
            collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        }
    }
    
    private func updateLayout() {
        guard let collectionView = self.collectionView else { return }
        
        let collectionSize = collectionView.bounds.size
        let isHorizontal = (self.scrollDirection == .Horizontal)
        
        let yInset = (collectionSize.height - self.itemSize.height) / 2
        let xInset = (collectionSize.width - self.itemSize.width) / 2
        self.sectionInset = UIEdgeInsetsMake(yInset, xInset, yInset, xInset)
        
        let side = isHorizontal ? self.itemSize.width : self.itemSize.height
        let scaledItemOffset =  (side - side*self.sideItemScale) / 2
        switch self.spacingMode {
        case .fixed(let spacing):
            self.minimumLineSpacing = spacing - scaledItemOffset
        case .overlap(let visibleOffset):
            let fullSizeSideItemOverlap = visibleOffset + scaledItemOffset
            let inset = isHorizontal ? xInset : yInset
            self.minimumLineSpacing = inset - fullSizeSideItemOverlap
        }
    }
    
    override public func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override public func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElementsInRect(rect),
            let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
            else { return nil }
        return attributes.map({ self.transformLayoutAttributes($0) })
    }
    
    private func transformLayoutAttributes(attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = self.collectionView else { return attributes }
        let isHorizontal = (self.scrollDirection == .Horizontal)
        
        let collectionCenter = isHorizontal ? collectionView.frame.size.width/2 : collectionView.frame.size.height/2
        let offset = isHorizontal ? collectionView.contentOffset.x : collectionView.contentOffset.y
        let normalizedCenter = (isHorizontal ? attributes.center.x : attributes.center.y) - offset
        
        let maxDistance = (isHorizontal ? self.itemSize.width : self.itemSize.height) + self.minimumLineSpacing
        let distance = min(abs(collectionCenter - normalizedCenter), maxDistance)
        let ratio = (maxDistance - distance)/maxDistance
        
        let alpha = ratio * (1 - self.sideItemAlpha) + self.sideItemAlpha
        let scale = ratio * (1 - self.sideItemScale) + self.sideItemScale
        attributes.alpha = alpha
        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        
        return attributes
    }
    
    override public func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView where !collectionView.pagingEnabled,
            let layoutAttributes = self.layoutAttributesForElementsInRect(collectionView.bounds)
            else { return super.targetContentOffsetForProposedContentOffset(proposedContentOffset) }
        
        let isHorizontal = (self.scrollDirection == .Horizontal)
        
        let midSide = (isHorizontal ? collectionView.bounds.size.width : collectionView.bounds.size.height) / 2
        let proposedContentOffsetCenterOrigin = (isHorizontal ? proposedContentOffset.x : proposedContentOffset.y) + midSide
        
        var targetContentOffset: CGPoint
        if isHorizontal {
            let closest = layoutAttributes.sort { abs($0.center.x - proposedContentOffsetCenterOrigin) < abs($1.center.x - proposedContentOffsetCenterOrigin) }.first ?? UICollectionViewLayoutAttributes()
            targetContentOffset = CGPoint(x: floor(closest.center.x - midSide), y: proposedContentOffset.y)
        }
        else {
            let closest = layoutAttributes.sort { abs($0.center.y - proposedContentOffsetCenterOrigin) < abs($1.center.y - proposedContentOffsetCenterOrigin) }.first ?? UICollectionViewLayoutAttributes()
            targetContentOffset = CGPoint(x: proposedContentOffset.x, y: floor(closest.center.y - midSide))
        }
        
        return targetContentOffset
    }
}

