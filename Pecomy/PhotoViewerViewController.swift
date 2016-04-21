//
//  PhotoViewerViewController.swift
//  Pecomy
//
//  Created by Kenzo on 2016/04/09.
//  Copyright © 2016年 Pecomy. All rights reserved.
//

import UIKit
import SDWebImage

// MARK: - PhotoViewNavigationBar
class PhotoViewNavigationBar: UIView {
    let gradientHeight: CGFloat = 64.0
    let opacity: CGFloat = 0.8
    var gradientLayer: CAGradientLayer?
    let indexLabel = UILabel()
    let closeButton = UIButton()
    
    override func layoutSublayersOfLayer(layer: CALayer) {
        super.layoutSublayersOfLayer(layer)
        
        if self.layer == layer && self.gradientLayer == nil {
            self.commonInit()
        }
    }
    
    func commonInit() {
        // グラデーション
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.blackColor().CGColor,
            UIColor(white: 0.0, alpha: opacity).CGColor,
            UIColor.clearColor().CGColor
        ]
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.bounds.size.width, height: self.bounds.size.height)
        layer.insertSublayer(gradient, atIndex: 0)
        self.gradientLayer = gradient
        
        self.addSubview(self.closeButton)
        self.closeButton.snp_makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(self).offset(16)
            make.width.equalTo(80)
            make.height.equalTo(self)
        }
        let closeLabel = UILabel()
        closeLabel.text = NSLocalizedString("Close", comment: "")
        closeLabel.textColor = .whiteColor()
        self.closeButton.addSubview(closeLabel)
        closeLabel.snp_makeConstraints { make in
            make.center.equalTo(self.closeButton)
            make.size.equalTo(self.closeButton)
        }
        
        self.indexLabel.textColor = .whiteColor()
        self.indexLabel.font = UIFont(name: Const.PECOMY_FONT_NORMAL, size: 18)
        self.indexLabel.textAlignment = .Center
        self.addSubview(self.indexLabel)
        self.indexLabel.snp_makeConstraints { make in
            make.center.equalTo(self)
            make.width.equalTo(150)
            make.height.equalTo(self)
        }
    }
}

// MARK: - PhotoPageView
class PhotoPageView: UIView {
    private var imageView: UIImageView
    private var loadingIndicator = UIActivityIndicatorView()
    
    var url: NSURL? {
        didSet {
            if let url = url {
                self.loadingIndicator.startAnimating()
                imageView.sd_setImageWithURL(url, completed: { [weak self] (image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) in
                    guard let strongSelf = self else { return }
                    strongSelf.loadingIndicator.stopAnimating()
                })
            } else {
                imageView.image = nil
            }
        }
    }
    
    override init(frame: CGRect) {
        self.imageView = UIImageView(frame: frame)
        super.init(frame: frame)
        self.imageView.contentMode = .ScaleAspectFit
        self.addSubview(self.imageView)
        self.loadingIndicator.activityIndicatorViewStyle = .WhiteLarge
        self.loadingIndicator.hidesWhenStopped = true
        self.addSubview(self.loadingIndicator)
        self.loadingIndicator.snp_makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.center.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - PhotoViewerViewController
class PhotoViewerViewController: UIViewController {
    
    // Consts
    let displayDuration: NSTimeInterval = 0.2
    let gapBetweenPhotoViews: CGFloat = 20.0
    let opacity: CGFloat = 0.9
    
    // Properties
    let scrollView = UIScrollView()
    var imageUrlStrings = [String]()
    var currentPage = 0
    var transitionImageView: UIImageView? // 遷移画像ビュー
    var coverView: UIView? // 遷移画像ビューの下に敷く黒いビュー
    var pageViews = [PhotoPageView]()
    var initialOffsetX: CGFloat = 0.0 // ドラッグ開始時のスクロール位置X
    
    let navigationBar = PhotoViewNavigationBar()
    
    var onClose: (() -> ())?

    init(imageUrlStrings: [String], index: Int) {
        self.imageUrlStrings = imageUrlStrings
        self.currentPage = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.pagingEnabled = true
        self.scrollView.delegate = self
        self.scrollView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: self.opacity)
        self.view.addSubview(self.scrollView)
        self.scrollView.snp_makeConstraints { make in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view).offset(-20)
            make.right.equalTo(self.view).offset(20)
            make.height.equalTo(self.view)
        }
        
        self.view.addSubview(self.navigationBar)
        self.navigationBar.snp_makeConstraints { make in
            make.top.equalTo(self.view).offset(20)
            make.left.equalTo(self.view)
            make.width.equalTo(self.view)
            make.height.equalTo(64)
        }
        self.navigationBar.closeButton.addTarget(self, action: #selector(PhotoViewerViewController.closePhoto), forControlEvents: .TouchUpInside)
        
        self.view.layoutIfNeeded()
        self.setUpPages()
    }
    
    
    func display(view view: UIView, imageView: UIImageView, yStartAdjustment: CGFloat = 0.0, yDestinationAdjustment: CGFloat = 0.0,  onClose: (() -> ())? = nil) {
        guard let image = imageView.image else { return }
        self.view.hidden = true
        let departView = self.view
        self.onClose = onClose
        
        let coverView = UIView(frame: UIScreen.mainScreen().bounds)
        coverView.backgroundColor = .blackColor()
        coverView.alpha = 0.0
        
        // 遷移画像ビューを最前面に置く
        var initialFrame = imageView.convertRect(imageView.frame, toView: departView)
        initialFrame.origin.y += yStartAdjustment
        let transitionImageView = UIImageView(image: imageView.image)
        transitionImageView.contentMode = .ScaleAspectFill
        transitionImageView.frame = initialFrame
        transitionImageView.clipsToBounds = true
        if let window = UIApplication.sharedApplication().windows.first {
            window.addSubview(coverView)
            window.addSubview(transitionImageView)
        }
        
        var w = departView.bounds.size.width
        var h = image.size.height * w / image.size.width
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        if h > departView.bounds.size.height {
            h = departView.bounds.size.height
            w = image.size.width * (h / image.size.height)
            x = floor((departView.bounds.size.width - w) / 2.0)
        } else {
            y = floor((self.scrollView.bounds.size.height - h) / 2.0)
        }
        y += yDestinationAdjustment
        let endFrame = CGRect(x: x, y: y, width: w, height: h)
        
        self.coverView = coverView
        self.transitionImageView = transitionImageView
        
        UIView.animateWithDuration(self.displayDuration, delay: 0.0, options: .CurveEaseOut, animations: { () in
            transitionImageView.frame = endFrame
            self.coverView!.alpha = 1.0
        }) { (finished) in
            self.removeTransitionImageView()
            self.view.hidden = false
            self.configureImages()
        }
    }
    
    
    func closePhoto() {
        UIView.animateWithDuration(self.displayDuration, animations: { () in
            self.view.alpha = 0.0
        }) { finished in
            self.dismissViewControllerAnimated(false) {
                self.onClose?()
            }
        }
    }
    
    func setUpPages() {
        for i in 0..<self.imageUrlStrings.count {
            let pageView = PhotoPageView(frame: self.view.bounds)
            pageView.frame.origin.x = CGFloat(i) * (self.gapBetweenPhotoViews * 2 + view.bounds.size.width) + self.gapBetweenPhotoViews
            self.pageViews.append(pageView)
            self.scrollView.addSubview(pageView)
        }
    }

    
    func configureImages() {
        let numOfPhotos = self.imageUrlStrings.count
        self.scrollView.contentSize.width = CGFloat(max(3, numOfPhotos)) * (self.gapBetweenPhotoViews * 2 + self.view.bounds.size.width)
        self.scrollView.contentOffset.x = CGFloat(self.currentPage) * (self.gapBetweenPhotoViews * 2 + self.view.bounds.size.width)
        
        for (i, pageView) in self.pageViews.enumerate() {
            if i == self.currentPage - 1 || i == self.currentPage || i == self.currentPage + 1 {
                let photo = self.imageUrlStrings[i]
                if let url = NSURL(string: photo) {
                    pageView.url = url
                }
            } else {
                pageView.url = nil
            }
        }
        self.initialOffsetX = self.scrollView.contentOffset.x
        self.updateIndexLabel()
    }
    
    
    // 遷移画像ビューを消す
    func removeTransitionImageView() {
        if let coverView = self.coverView, transitionImageView = self.transitionImageView {
            coverView.removeFromSuperview()
            transitionImageView.removeFromSuperview()
            self.coverView = nil
            self.transitionImageView = nil
        }
        self.navigationBar.alpha = 0.0
        UIView.animateWithDuration(self.displayDuration, animations: { () in
            self.navigationBar.alpha = 1.0
        })
    }
    
    // インデックスラベル更新
    func updateIndexLabel() {
        self.navigationBar.indexLabel.text = "\(self.currentPage + 1)/\(self.imageUrlStrings.count)"
    }
}

extension PhotoViewerViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.scrollView.userInteractionEnabled = false
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.scrollView.userInteractionEnabled = true
        
        let x0 = Int(floor(self.initialOffsetX))
        let x1 = Int(floor(self.scrollView.contentOffset.x))
        
        if x1 > x0 {
            self.currentPage += 1
        } else if x1 < x0 {
            self.currentPage -= 1
        }
        self.configureImages()
    }
}
