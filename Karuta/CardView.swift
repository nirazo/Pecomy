//
//  CardView.swift
//  Karuta
//
//  Created by Kenzo on 2015/07/04.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

import UIKit
import MDCSwipeToChoose

class CardView: UIView {
    
    init(frame: CGRect, shopID: Int, shopName: String, imageURL: NSURL, maxPrice: Int, minPrice: Int, distance: Double, options: MDCSwipeToChooseViewOptions) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
