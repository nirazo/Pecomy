//
//  RegisterPopupView.swift
//  Pecomy
//
//  Created by Kenzo on 7/9/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation

enum RegisterType {
    case checkin, favorite
    
    func iconImage() -> UIImage {
        switch self {
        case .checkin:
            return R.image.modal_checkin()!
        case .favorite:
            return R.image.modal_favorite()!
        }
    }
    
    func reportString(_ shopName: String) -> NSAttributedString {
        var str = ""
        switch self {
        case .checkin:
            str = String(format: NSLocalizedString("CheckinReport", comment: ""), shopName)
        case .favorite:
            str = String(format: NSLocalizedString("FavoriteReport", comment: ""), shopName)
        }
        return self.makeAttrText(str, shopName: shopName)
    }
    
    fileprivate func makeAttrText(_ text: String, shopName: String) -> NSAttributedString {
        let attrText = NSMutableAttributedString(string: text)
        let shopNameRange = NSMakeRange(0, shopName.count)
        attrText.beginEditing()
        attrText.addAttribute(NSAttributedStringKey.foregroundColor, value: Const.RANKING_TOP_COLOR, range: shopNameRange)
        attrText.addAttribute(NSAttributedStringKey.font, value: UIFont(name: Const.PECOMY_FONT_BOLD, size: 14)!, range: shopNameRange)
        attrText.endEditing()
        return attrText
    }
}

class RegisterPopupView: UIView {
    
    let iconView = UIImageView()
    var type = RegisterType.checkin
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
        self.backgroundColor = .white
        
        self.iconView.image = self.type.iconImage()
        self.addSubview(self.iconView)
        self.iconView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(28)
            make.centerX.equalTo(self)
            make.width.height.equalTo(70)
        }
        
        self.reportLabel.font = UIFont(name: Const.PECOMY_FONT_NORMAL, size: 14)
        self.reportLabel.textAlignment = .center
        self.reportLabel.numberOfLines = 0
        self.reportLabel.attributedText = self.type.reportString(self.shopName)
        self.addSubview(self.reportLabel)
        self.reportLabel.snp.makeConstraints { make in
            make.top.equalTo(self.iconView.snp.bottom).offset(20)
            make.left.equalTo(self).offset(15)
            make.right.equalTo(self).offset(-15)
            make.bottom.equalTo(self).offset(-20)
        }
    }
}
