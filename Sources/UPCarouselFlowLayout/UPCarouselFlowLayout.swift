//
//  UPCarouselFlowLayout.swift
//  UPCarouselFlowLayoutDemo
//
//  Created by Paul Ulric on 23/06/2016.
//  Copyright © 2016 Paul Ulric. All rights reserved.
//

import UIKit

// MARK: - Enums

public enum CarouselFlowLayoutSpacingMode {
    case fixed(spacing: CGFloat)
    case overlap(visibleOffset: CGFloat)
}

// MARK: - Class

open class CarouselFlowLayout: UICollectionViewFlowLayout {

    // MARK: - Properties

    // Inspectable properties

    @IBInspectable open var sideItemScale: CGFloat = 0.8
    @IBInspectable open var sideItemAlpha: CGFloat = 0.6
    @IBInspectable open var sideItemShift: CGFloat = 0.0

    // Open properties

    open var spacingMode = CarouselFlowLayoutSpacingMode.fixed(spacing: DSMargin.margin8)

    // File private properties

    fileprivate var state = LayoutState(size: .zero, direction: .horizontal)

    // MARK: - Methods

    // Open methods

    override open func prepare() {
        super.prepare()
        let currentState = LayoutState(
            size: collectionView?.bounds.size ?? .init(),
            direction: scrollDirection
        )

        if !self.state.isEqual(currentState) {
            self.setupCollectionView()
            self.updateLayout()
            self.state = currentState
        }
    }

    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard
            let superAttributes = super.layoutAttributesForElements(in: rect),
            let attributes = NSArray(
                array: superAttributes,
                copyItems: true
            ) as? [UICollectionViewLayoutAttributes]
        else { return nil }

        return attributes.map({ self.transformLayoutAttributes($0) })
    }

    override open func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        guard
            let collectionView = collectionView, !collectionView.isPagingEnabled,
            let layoutAttributes = layoutAttributesForElements(in: collectionView.bounds)
        else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }

        let isHorizontal = scrollDirection == .horizontal

        let midSide = (isHorizontal ? collectionView.bounds.size.width : collectionView.bounds.size.height) / 2
        let proposedContentOffsetCenterOrigin = (isHorizontal ? proposedContentOffset.x : proposedContentOffset.y) + midSide

        var targetContentOffset: CGPoint
        if isHorizontal {
            let closest = layoutAttributes.sorted {
                abs($0.center.x - proposedContentOffsetCenterOrigin) < abs($1.center.x - proposedContentOffsetCenterOrigin)
            }.first ?? .init()

            targetContentOffset = .init(
                x: floor(closest.center.x - midSide),
                y: proposedContentOffset.y
            )

        } else {
            let closest = layoutAttributes.sorted {
                abs($0.center.y - proposedContentOffsetCenterOrigin) < abs($1.center.y - proposedContentOffsetCenterOrigin)
            }.first ?? .init()

            targetContentOffset = .init(
                x: proposedContentOffset.x,
                y: floor(closest.center.y - midSide)
            )
        }

        return targetContentOffset
    }

    // File private methods

    fileprivate func setupCollectionView() {
        guard let collectionView = collectionView else { return }
        if collectionView.decelerationRate != UIScrollView.DecelerationRate.fast {
            collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        }
    }

    fileprivate func updateLayout() {
        guard let collectionView = collectionView else { return }

        let collectionSize = collectionView.bounds.size
        let isHorizontal = scrollDirection == .horizontal

        let yInset = (collectionSize.height - itemSize.height) / 2
        let xInset = (collectionSize.width - itemSize.width) / 2
        sectionInset = .init(top: yInset, left: xInset, bottom: yInset, right: xInset)

        let side = isHorizontal ? itemSize.width : itemSize.height
        let scaledItemOffset =  (side - side*sideItemScale) / 2

        switch self.spacingMode {
        case .fixed(let spacing):
            minimumLineSpacing = spacing - scaledItemOffset
        case .overlap(let visibleOffset):
            let fullSizeSideItemOverlap = visibleOffset + scaledItemOffset
            let inset = isHorizontal ? xInset : yInset
            minimumLineSpacing = inset - fullSizeSideItemOverlap
        }
    }

    fileprivate func transformLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {

        guard let collectionView = collectionView else { return attributes }

        let isHorizontal = scrollDirection == .horizontal
        let collectionCenter = isHorizontal ? collectionView.frame.size.width/2 : collectionView.frame.size.height/2
        let offset = isHorizontal ? collectionView.contentOffset.x : collectionView.contentOffset.y
        let normalizedCenter = (isHorizontal ? attributes.center.x : attributes.center.y) - offset

        let maxDistance = (isHorizontal ? itemSize.width : itemSize.height) + minimumLineSpacing
        let distance = min(abs(collectionCenter - normalizedCenter), maxDistance)
        let ratio = (maxDistance - distance)/maxDistance

        let alpha = ratio * (1 - sideItemAlpha) + sideItemAlpha
        let scale = ratio * (1 - sideItemScale) + sideItemScale
        let shift = (1 - ratio) * sideItemShift

        attributes.alpha = alpha
        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        attributes.zIndex = Int(alpha * 10)

        if isHorizontal {
            attributes.center.y += shift
        } else {
            attributes.center.x += shift
        }

        return attributes
    }
}

// MARK: - Structs

extension CarouselFlowLayout {
    fileprivate struct LayoutState {
        var size: CGSize
        var direction: UICollectionView.ScrollDirection

        func isEqual(_ otherState: LayoutState) -> Bool {
            return self.size.equalTo(otherState.size) && self.direction == otherState.direction
        }
    }
}
