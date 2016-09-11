//
//  RegisterPopupView.swift
//  Pecomy
//
//  Created by Kenzo on 7/9/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation

enum RegisterType {
    case Checkin, Favorite
    
    func iconImage() -> UIImage {
        switch self {
        case .Checkin:
            return R.image.modal_checkin()!
        case .Favorite:
            return R.image.modal_favorite()!
        }
    }
    
    func reportString(shopName: String) -> NSAttributedString {
        var str = ""
        switch self {
        case .Checkin:
            str = String(format: NSLocalizedString("CheckinReport", comment: ""), shopName)
        case .Favorite:
            str = String(format: NSLocalizedString("FavoriteReport", comment: ""), shopName)
        }
        return self.makeAttrText(str, shopName: shopName)
    }
    
    private func makeAttrText(text: String, shopName: String) -> NSAttributedString {
        let attrText = NSMutableAttributedString(string: text)
        let shopNameRange = NSMakeRange(0, shopName.characters.count)
        attrText.beginEditing()
        attrText.addAttribute(NSForegroundColorAttributeName, value: Const.RANKING_TOP_COLOR, range: shopNameRange)
        attrText.addAttribute(NSFontAttributeName, value: UIFont(name: Const.PECOMY_FONT_BOLD, size: 14)!, range: shopNameRange)
        attrText.endEditing()
        return attrText
    }
}

class RegisterPopupView: UIView {
    
    let iconView = UIImageView()
    var type = RegisterType.Checkin
    let reportLabel = UILabel()
    var shopName = ""
    
    init(frame: CGRect, shopName: String, type: RegisterType) {
        super.init(frame: frame)
        self.shopName = shopName
        self.type = type
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        self.layer.cornerRadius = Const.CORNER_RADIUS
        self.backgroundColor = .whiteColor()
        
        self.iconView.image = self.type.iconImage()
        self.addSubview(self.iconView)
        self.iconView.snp_makeConstraints { make in
            make.top.equalTo(self).offset(28)
            make.centerX.equalTo(self)
            make.width.height.equalTo(70)
        }
        
        self.reportLabel.font = UIFont(name: Const.PECOMY_FONT_NORMAL, size: 14)
        self.reportLabel.textAlignment = .Center
        self.reportLabel.numberOfLines = 0
        self.reportLabel.attributedText = self.type.reportString(self.shopName)
        self.addSubview(self.reportLabel)
        self.reportLabel.snp_makeConstraints { make in
            make.top.equalTo(self.iconView.snp_bottom).offset(20)
            make.left.equalTo(self).offset(15)
            make.right.equalTo(self).offset(-15)
            make.bottom.equalTo(self).offset(-20)
        }
    }
}