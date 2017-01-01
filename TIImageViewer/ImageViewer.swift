//
//  PagedImageController.swift
//
//  Created by Todd Isaacs on 12/24/16.
//

import UIKit

class ImageViewer: UIPageViewController {
  
  public var currentIndex: Int = 0
  public var images: [UIImage] = []
  
  var singleTap:UITapGestureRecognizer!
  var doubleTap:UITapGestureRecognizer!
  
  
  required init(images: [UIImage], startIdx: Int, options: [String : Any]? = nil) {
    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    
    currentIndex = startIdx
    self.images = images
  }
  
  
  required init(options: [String : Any]? = nil) {
    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
  }
  
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  
  static func show(fromController: UIViewController, image:UIImage, fullScreen:Bool) {
    let imageController = ImageViewController(image: image)
    imageController.show(fromController: fromController, fullScreen: fullScreen)
  }
  
  //this just feels dirty but using till I figure out a better way
  static func show(from: UIViewController, images:[UIImage], startIndex:Int, fullScreen:Bool, spacing: Int = 8) -> ImageViewer {
    let spacingStr = String(spacing)
    
    let imageViewer = ImageViewer(images: images,
                                  startIdx: startIndex,
                                  options: [UIPageViewControllerOptionInterPageSpacingKey: spacingStr])
    
    //imageViewer.view.backgroundColor = UIColor.white
    imageViewer.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
    
    from.definesPresentationContext = !fullScreen
    
    //wrap in nav controller
    let navController = UINavigationController(rootViewController: imageViewer)
    from.present(navController, animated: true, completion: nil)
    
    let backButton = UIBarButtonItem(barButtonSystemItem: .stop, target: imageViewer, action: #selector(handleDone))
    imageViewer.navigationItem.leftBarButtonItem = backButton
    
    return imageViewer
  }
  
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    dataSource = self
    
    automaticallyAdjustsScrollViewInsets = false
    
    doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
    doubleTap.numberOfTapsRequired = 2
    
    singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
    singleTap.numberOfTapsRequired = 1
    singleTap.require(toFail: doubleTap)
    
    view.addGestureRecognizer(singleTap)
    view.addGestureRecognizer(doubleTap)
    
    let firstViewController = viewPhotoCommentController(index: currentIndex)
    
    setViewControllers(
      [firstViewController],
      direction: .forward,
      animated: true,
      completion: nil
    )
  }
  
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let nav = navigationController {
      nav.hidesBarsOnTap = true
      nav.isNavigationBarHidden = false
      nav.isToolbarHidden = false
    }
  }
  
  
  func handleSingleTap(gesture: UITapGestureRecognizer) {
    if let nav = navigationController {
      let hideFlag = !nav.isNavigationBarHidden
      setToolbarVisibilty(hidden: hideFlag)
    }
    
  }
  
  func setToolbarVisibilty(hidden: Bool) {
    if let nav = navigationController {
      nav.setNavigationBarHidden(hidden, animated: true)
      nav.setToolbarHidden(hidden, animated: true)
    }
  }
  
  
  func handleDoubleTap(gesture: UITapGestureRecognizer) {
    //this is just a placeholder to delay the single so we can recognize the image double tap
  }
  
  
  func handleDone() {
    dismiss(animated: true, completion: nil)
  }
  
  
  func viewPhotoCommentController(index: Int) -> ImageViewController {
    let view = ImageViewController(image: images[index])
    view.index = index
    view.delegate = self
    
    return view
  }
}


//MARK: implementation of UIPageViewControllerDataSource
extension ImageViewer: UIPageViewControllerDataSource {
  
  public func pageViewController(_ pageViewController: UIPageViewController,
                                 viewControllerAfter viewController: UIViewController) -> UIViewController? {
    
    let index = (viewController as! ImageViewController).index
    
    if (index < images.count - 1) {
      return viewPhotoCommentController(index: index + 1)
    } else {
      return nil
    }
  }
  
  
  public func pageViewController(_ pageViewController: UIPageViewController,
                                 viewControllerBefore viewController: UIViewController) -> UIViewController? {
    
    let index = (viewController as! ImageViewController).index
    
    if (index > 0) {
      return viewPhotoCommentController(index: index - 1)
    } else {
      return nil
    }
  }
}


//MARK: implementation of ImageViewControllerDelegate
extension ImageViewer: ImageViewControllerDelegate {
  func imageViewWillBeginZooming() {
    setToolbarVisibilty(hidden: true)
  }
}



