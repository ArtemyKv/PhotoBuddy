//
//  ImageScrollView.swift
//  PhotoBuddy
//
//  Created by Artem Kvashnin on 16.11.2022.
//

import UIKit

class ImageScrollView: UIScrollView {
    var imageZoomView: UIImageView!
    
    lazy var zoomingTap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleZoomingTap(sender:)))
        tap.numberOfTapsRequired = 2
        return tap
    }()
    
    func set(image: UIImage) {
        imageZoomView?.removeFromSuperview()
        imageZoomView = nil
        
        imageZoomView = UIImageView(image: image)
        self.addSubview(imageZoomView)
        configureFor(imageSize: image.size)
    }
    
    func configureFor(imageSize: CGSize) {
        self.contentSize = imageSize
        setCurrentZoomScales()
        self.zoomScale = minimumZoomScale
        
        self.imageZoomView.addGestureRecognizer(zoomingTap)
        self.imageZoomView.isUserInteractionEnabled = true
    }
    
    func setCurrentZoomScales() {
        let boundsSize = UIScreen.main.bounds.size
        let imageSize = imageZoomView.bounds.size
        //Min scale
        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height
        let minScale = min(xScale, yScale)
        self.minimumZoomScale = minScale
        //Max scale
        var maxScale: CGFloat = 1.0
        if minScale < 0.1 {
            maxScale = 0.3
        }
        else if minScale >= 0.1 && minScale < 0.5 {
            maxScale = 0.7
        }
        else if minScale >= 0.5 {
            maxScale = max(1, minScale)
        }
        
        self.minimumZoomScale = minScale
        self.maximumZoomScale = maxScale
        print("min: \(minScale), max: \(maxScale), boundsSize: \(boundsSize), imageSize: \(imageSize)")
    }
    
    func centerImage() {
        let boundsSize = self.frame.size
        var frameToCenter = imageZoomView.frame
        
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.height) / 2 - self.safeAreaInsets.top
        } else {
            frameToCenter.origin.y = 0
        }
        imageZoomView.frame = frameToCenter
    }
    
    @objc func handleZoomingTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: sender.view)
        self.zoom(point: location, animated: true)
    }
    
    func zoom(point: CGPoint, animated: Bool) {
        let currentScale = self.zoomScale
        let minScale = self.minimumZoomScale
        let maxScale = self.maximumZoomScale
        
        if (minScale == maxScale && minScale > 1) {
            return
        }
        
        let toScale = maxScale
        let finalScale = (currentScale == minScale) ? toScale : minScale
        let zoomRect = zoomRect(scale: finalScale, center: point)
        self.zoom(to: zoomRect, animated: animated)
    }
    
    func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        let bounds = self.bounds
        
        zoomRect.size.width = bounds.size.width / scale
        zoomRect.size.height = bounds.size.height / scale
        
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
        return zoomRect
    }
    
    override func layoutSubviews() {
        guard imageZoomView != nil else { return }
        centerImage()
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        self.delegate = self
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ImageScrollView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageZoomView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
}
