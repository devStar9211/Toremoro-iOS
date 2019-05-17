//
//  CarouselCollectionViewFlowLayout.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/09/25.
//  Copyright © 2018年 toremoro, inc. All rights reserved.
//

import UIKit

final class CarouselCollectionViewFlowLayout: UICollectionViewFlowLayout {

    // MARK: - Property

    var itemInterval: CGFloat = 15.0
    var itemHorizontalSpacing: CGFloat = 50.0
    var itemVerticalSpacing: CGFloat = 50.0
    var flickVelocityThreshold: CGFloat = 0.2
    var headerWidth: CGFloat = 0

    var currentPage: Int {
        return Int(round(currentPosition))
    }

    var pageWidth: CGFloat {
        return itemSize.width + minimumLineSpacing
    }

    private var currentPosition: CGFloat {
        return (collectionView?.contentOffset.x ?? 0) / pageWidth
    }

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        scrollDirection = .horizontal
    }

    // MARK: - UICollectionViewFlowLayout

    override func prepare() {
        if let collectionView = collectionView {
            minimumLineSpacing = itemInterval

            let itemSizeWidth = collectionView.bounds.width - itemHorizontalSpacing * 2.0
            let itemSizeHeight = collectionView.bounds.height - itemVerticalSpacing * 2.0
            itemSize = CGSize(width: itemSizeWidth, height: itemSizeHeight)

            let horizontalInset = (collectionView.bounds.width - itemSize.width) / 2.0
            let verticalInset = (collectionView.bounds.height - itemSize.height) / 2.0
            sectionInset = UIEdgeInsets(
                top: verticalInset,
                left: horizontalInset,
                bottom: verticalInset,
                right: horizontalInset
            )
        }

        super.prepare()
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        if fabs(velocity.x) > flickVelocityThreshold {
            let nextPage = velocity.x > 0.0 ? ceil(currentPosition) : floor(currentPosition)
            return CGPoint(x: (nextPage * pageWidth) + headerWidth, y: proposedContentOffset.y)
        } else {
            return CGPoint(x: (round(currentPosition) * pageWidth) + headerWidth, y: proposedContentOffset.y)
        }
    }
}
