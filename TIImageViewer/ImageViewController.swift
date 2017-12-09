//
//  ModalViewController.swift
//  ImageViewController
//
//  Created by Todd Isaacs on 12/18/16.
//

import UIKit

public class ImageViewController: UIViewController {
  
  var scrollView:UIScrollView!
  var imageView:UIImageView!
  
  var delegate:ImageViewControllerDelegate?
  
  var image:UIImage? {
    didSet {
      print("image set")
    }
  }
  
  var scrollViewTopConstraint: NSLayoutConstraint!
  var scrollViewBottomConstraint: NSLayoutConstraint!
  var scrollViewLeadingConstraint: NSLayoutConstraint!
  var scrollViewTrailingConstraint: NSLayoutConstraint!
  
  var imageViewTopConstraint: NSLayoutConstraint!
  var imageViewBottomConstraint: NSLayoutConstraint!
  var imageViewLeadingConstraint: NSLayoutConstraint!
  var imageViewTrailingConstraint: NSLayoutConstraint!
  
  var doubleTap: UITapGestureRecognizer!
  var flickDown: UISwipeGestureRecognizer!
  
  var imageFullSizeImageZoomScale:CGFloat = 1.0
  var imageFullSizeViewZoomScale:CGFloat = 1.0
  
  var index:Int = 0
  
  required public init(image: UIImage) {
    super.init(nibName: nil, bundle: nil)
    
    self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
    
    //adjust the layout margins to remove them
    self.view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    self.image = image
    
    setupScrollView()
    addScrollViewConstraints()
    setupImageView(image: image)
    addImageViewConstraints()
  }
  
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override public func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    resizeViewToFit(animated: false)
    centerView()
  }
  
  
  func show(fromController: UIViewController, fullScreen:Bool) {
    fromController.definesPresentationContext = !fullScreen
    fromController.present(self, animated: true, completion: nil)
    
    resizeViewToFit(animated: false)
  }
  
  
  private func setupScrollView() {
    scrollView = UIScrollView()
    
    scrollView.delegate = self
    scrollView.minimumZoomScale = 0.25
    scrollView.maximumZoomScale = 10
    scrollView.zoomScale = 1
    scrollView.showsHorizontalScrollIndicator = true
    scrollView.showsVerticalScrollIndicator = true
    scrollView.isUserInteractionEnabled = true
    scrollView.isScrollEnabled = true
    
    let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
    swipeDownGesture.direction = .down
    swipeDownGesture.numberOfTouchesRequired = 1
    
    scrollView.addGestureRecognizer(swipeDownGesture)
    
    view.addSubview(scrollView)
  }
  
  private func setupImageView(image: UIImage) {
    //not sure why we need both lines but the frame is not correct without it
    imageView = UIImageView(image:  image)
    imageView.image = image
    
    imageView.contentMode = UIViewContentMode.scaleAspectFit
    imageView.isUserInteractionEnabled = true
    scrollView.addSubview(imageView)
    
    doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
    doubleTap.numberOfTapsRequired = 2
    
    imageView.addGestureRecognizer(doubleTap)
  }
  
  
  private func addScrollViewConstraints() {
    scrollViewTopConstraint = NSLayoutConstraint(item: scrollView,
                                                 attribute: .top,
                                                 relatedBy: .equal,
                                                 toItem: view,
                                                 attribute: .top,
                                                 multiplier: 1,
                                                 constant: 0)
    
    scrollViewBottomConstraint = NSLayoutConstraint(item: scrollView,
                                                    attribute: .bottom,
                                                    relatedBy: .equal,
                                                    toItem: view,
                                                    attribute: .bottom,
                                                    multiplier: 1,
                                                    constant: 0)
    
    scrollViewLeadingConstraint = NSLayoutConstraint(item: scrollView,
                                                     attribute: .leading,
                                                     relatedBy: .equal,
                                                     toItem: view,
                                                     attribute: .leading,
                                                     multiplier: 1,
                                                     constant: 0)
    
    scrollViewTrailingConstraint = NSLayoutConstraint(item: scrollView,
                                                      attribute: .trailing,
                                                      relatedBy: .equal,
                                                      toItem: view,
                                                      attribute: .trailing,
                                                      multiplier: 1,
                                                      constant: 0)
    
    //disable auto resizing mask
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    
    scrollViewTopConstraint.isActive = true
    scrollViewBottomConstraint.isActive = true
    scrollViewLeadingConstraint.isActive = true
    scrollViewTrailingConstraint.isActive = true
  }
  
  
  private func addImageViewConstraints() {
    imageViewTopConstraint = NSLayoutConstraint(item: imageView,
                                                attribute: .top,
                                                relatedBy: .equal,
                                                toItem: scrollView,
                                                attribute: .top,
                                                multiplier: 1,
                                                constant: 0)
    
    imageViewBottomConstraint = NSLayoutConstraint(item: imageView,
                                                   attribute: .bottom,
                                                   relatedBy: .equal,
                                                   toItem: scrollView,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                                   constant: 0)
    
    imageViewLeadingConstraint = NSLayoutConstraint(item: imageView,
                                                    attribute: .leading,
                                                    relatedBy: .equal,
                                                    toItem: scrollView,
                                                    attribute: .leading,
                                                    multiplier: 1,
                                                    constant: 0)
    
    imageViewTrailingConstraint = NSLayoutConstraint(item: imageView,
                                                     attribute: .trailing,
                                                     relatedBy: .equal,
                                                     toItem: scrollView,
                                                     attribute: .trailing,
                                                     multiplier: 1,
                                                     constant: 0)
    
    //disable auto resizing mask
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    //activate
    imageViewTopConstraint.isActive = true
    imageViewBottomConstraint.isActive = true
    imageViewLeadingConstraint.isActive = true
    imageViewTrailingConstraint.isActive = true
  }
  
  
  @objc func handleSwipeDown(gesture: UISwipeGestureRecognizer) {
    dismiss(animated: true, completion: nil)
  }
  
  @objc func handleDoubleTap(gesture: UITapGestureRecognizer) {
    zoomFullScreenHeightOrWidth()
  }
  
  func zoomFullScreenHeightOrWidth() {
    if scrollView.zoomScale > imageFullSizeImageZoomScale {
      resizeViewToFit(animated: true)
      centerView()
    } else {
      scrollView.setZoomScale(imageFullSizeViewZoomScale, animated: true)
    }
  }
  
  
  
  public func resizeViewToFit(animated: Bool) {
    //calculate zoom that shows the whole image
    let widthScale = view.bounds.width / imageView.bounds.width
    let heightScale = view.bounds.height / imageView.bounds.height
    
    imageFullSizeImageZoomScale = min(heightScale, widthScale)
    imageFullSizeViewZoomScale = max(heightScale, widthScale)
    
    scrollView.setZoomScale(imageFullSizeImageZoomScale, animated: animated)
    
  }
  
  public func centerView() {
    let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
    let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
    self.scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, 0, 0)
  }
}



extension ImageViewController: UIScrollViewDelegate {
  
  public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
  
  public func scrollViewDidZoom(_ scrollView: UIScrollView) {
    centerView()
  }
  
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    view.layoutIfNeeded()
  }
  
  public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
    delegate?.imageViewWillBeginZooming?()
  }
}

@objc protocol ImageViewControllerDelegate: class {
  @objc optional func imageViewWillBeginZooming()
}

