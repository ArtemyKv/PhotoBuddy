//
//  SearchResultsLayout.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 30.06.2023.
//

import UIKit

protocol SearchResultsLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}


class SearchResultsLayout: UICollectionViewLayout {
    
    weak var delegate: SearchResultsLayoutDelegate?
    
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 6
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var footerAttributes: UICollectionViewLayoutAttributes?
    
    private var contentHeight: CGFloat = 0.0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard let collectionView = collectionView, collectionView.numberOfSections > 0 else { return }
        cache = []
        footerAttributes = nil
        contentHeight = 0.0
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        
        for item in 0..<itemsCount {
            let indexPath = IndexPath(item: item, section: 0)
            
            let photoHeight = delegate?.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath) ?? 180
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: columnWidth,
                               height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            if contentHeight - yOffset[column] > height {
                continue
            } else {
                column = column < (numberOfColumns - 1) ? (column + 1) : 0
            }
            
            footerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: BottomRefreshControl.elementKind, with: IndexPath(row: itemsCount - 1, section: 0))
            footerAttributes?.frame = CGRect(x: 0, y: contentHeight, width: collectionView.frame.width, height: 60)
            contentHeight += 60
        }
        
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []

        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        if let footerAttributes, footerAttributes.frame.intersects(rect) {
            visibleLayoutAttributes.append(footerAttributes)
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.item < cache.count else { return nil }
        return cache[indexPath.item]
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard elementKind == BottomRefreshControl.elementKind else { return nil }
        return footerAttributes
    }
    
}
