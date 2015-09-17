//
//  RestaurantDetailViewController.swift
//  Karuta
//
//  Created by Kenzo on 2015/08/10.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController {
    
    let url: NSURL
    
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
        self.view.addSubview(webView)
        let req = NSURLRequest(URL: self.url)
        webView.loadRequest(req)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
