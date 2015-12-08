//
//  RestaurantDetailViewController.swift
//  Karuta
//
//  Created by Kenzo on 2015/08/10.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController, UIWebViewDelegate {
    
    let ANALYTICS_TRACKING_CODE = "DetailViewController"
    
    let url: NSURL
    let loadingIndicator = UIActivityIndicatorView()
    
    init(url: NSURL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let webView = UIWebView(frame: self.view.frame)
        webView.delegate = self
        self.view.addSubview(webView)
        // インジケータ
        self.loadingIndicator.bounds = CGRectMake(0.0, 0.0, 50, 50)
        self.loadingIndicator.activityIndicatorViewStyle = .Gray
        self.loadingIndicator.center = webView.center
        self.loadingIndicator.hidesWhenStopped = true
        webView.addSubview(self.loadingIndicator)
        let req = NSURLRequest(URL: self.url)
        webView.loadRequest(req)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Google Analytics
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: self.ANALYTICS_TRACKING_CODE)
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: UIWebViewDelegate methods
    func webViewDidStartLoad(webView: UIWebView) {
        self.loadingIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.loadingIndicator.stopAnimating()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if (request.URL!.absoluteString.hasPrefix("http")) {
            return true
        } else {
            return false
        }
    }
    
}
