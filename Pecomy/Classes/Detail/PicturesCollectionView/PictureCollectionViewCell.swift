//
//  PictureCollectionViewCell.swift
//  Pecomy
//
//  Created by Kenzo on 2016/01/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import UIKit
import SDWebImage

class PictureCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView
    var urlString = "" {
        didSet {
            let url = URL(string: urlString)
            self.imageView.sd_setImage(with: url) {[weak self] (image, error, imageCacheType, imageURL) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.imageView.alpha = 0
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
                    strongSelf.imageView.alpha = 1
                    }, completion: nil)
                }
        }
    }
    
    override init(frame: CGRect) {
        self.imageView = UIImageView(image: R.image.noimage())
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
        super.init(frame: frame)
        self.contentView.layer.cornerRadius = 5.0
        self.contentView.layer.masksToBounds = true
        self.contentView.addSubview(self.imageView)
        self.contentView.backgroundColor = .clear
        
        self.imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.contentView)
            make.centerY.equalTo(self.contentView)
            make.size.equalTo(self.contentView)
        }
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
