//
//  LoadingView.swift
//  Pecomy
//
//  Created by Kenzo on 2015/09/06.
//  Copyright (c) 2016 Pecomy. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    let loadingIndicator = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        self.alpha = 0.5
        self.loadingIndicator.activityIndicatorViewStyle = .whiteLarge
        self.loadingIndicator.hidesWhenStopped = true
        self.setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        self.addSubview(self.loadingIndicator)
        self.loadingIndicator.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.center.equalTo(self)
        }
        self.loadingIndicator.startAnimating()
    }
}
