//
//  PagedImageController.swift
//
//  Created by Todd Isaacs on 12/24/16.
//

import UIKit

public class ImageViewer: UIPageViewController {
  
  public var currentIndex: Int = 0
  public var images: [UIImage] = []
  
  var singleTap:UITapGestureRecognizer!
  var doubleTap:UITapGestureRecognizer!

  var showToolBar = false
  var shareMessage = ""
  
  public required init(images: [UIImage], startIdx: Int, options: [String : Any]? = nil) {
    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    
    currentIndex = startIdx
    self.images = images
  }
  
  
  public required init(options: [String : Any]? = nil) {
    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
  }
  
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  
  public static func show(fromController: UIViewController, image:UIImage, fullScreen:Bool) {
    let imageController = ImageViewController(image: image)
    imageController.show(fromController: fromController, fullScreen: fullScreen)
  }
  
  //this just feels dirty but using till I figure out a better way
  public static func show(from: UIViewController, images:[UIImage], startIndex:Int, fullScreen:Bool, toolBarMessage: String?, spacing: Int = 8) -> ImageViewer {
    let spacingStr = String(spacing)
    
    let imageViewer = ImageViewer(images: images,
                                  startIdx: startIndex,
                                  options: [UIPageViewControllerOptionInterPageSpacingKey: spacingStr])
    
    imageViewer.view.backgroundColor = UIColor.white
    imageViewer.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
    if let message = toolBarMessage {
      imageViewer.shareMessage = message
      imageViewer.showToolBar = true
    }
        
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
    delegate = self
    
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
  
  
  override public func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
  }
  
  
  override public func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let shareButton = UIBarButtonItem.init(barButtonSystemItem: .action, target: self, action: #selector(share))
    self.setToolbarItems([shareButton], animated: true)
    
    
    if let nav = navigationController {
      
      nav.hidesBarsOnTap = true
      nav.isNavigationBarHidden = false
      nav.isToolbarHidden = !showToolBar
    }
  }
    
  @objc func share() {
    let image = images[currentIndex]
        
    let controller = UIActivityViewController.init(activityItems: [image, shareMessage], applicationActivities: nil)
    present(controller, animated: true, completion: nil)
  }
  
  
  @objc func handleSingleTap(gesture: UITapGestureRecognizer) {
    if let nav = navigationController {
        let hideFlag = !nav.isNavigationBarHidden
      setToolbarVisibilty(hidden: hideFlag)
    }
    
  }
  
  func setToolbarVisibilty(hidden: Bool) {
    if let nav = navigationController {
      nav.setNavigationBarHidden(hidden, animated: true)
      if (showToolBar) {
        nav.setToolbarHidden(hidden, animated: true)
      }
    }
  }
  
  
  @objc func handleDoubleTap(gesture: UITapGestureRecognizer) {
    //this is just a placeholder to delay the single so we can recognize the image double tap
  }
  
  
  @objc func handleDone() {
    dismiss(animated: true, completion: nil)
  }
  
  
  func viewPhotoCommentController(index: Int) -> ImageViewController {
    let view = ImageViewController(image: images[index])
    view.index = index
    view.delegate = self
    
    return view
  }
}


//MARK: UIPageViewControllerDataSource
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

//MARK: UIPageViewControllerDelegate
extension ImageViewer: UIPageViewControllerDelegate {
    
  //This updates the currentIndex after the transition.
  public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    
    guard completed else { return }
    let pageContentViewController = pageViewController.viewControllers![0] as! ImageViewController
    let index = pageContentViewController.index
        
    currentIndex = index
  }
}


//MARK: implementation of ImageViewControllerDelegate
extension ImageViewer: ImageViewControllerDelegate {
  func imageViewWillBeginZooming() {
    setToolbarVisibilty(hidden: true)
  }
}



