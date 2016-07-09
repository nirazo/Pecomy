//
//  CheckinBottomBar.swift
//  Pecomy
//
//  Created by Kenzo on 7/9/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation

class CheckinBottomBar: UIView {
    
    let checkinBaseView = UIView()
    let checkinButton = UIButton()
    let checkinButtonLabel = UILabel()
    let favoriteButton = UIButton()
    let checkedinIconImageView = UIImageView(image: R.image.detail_checkin_off())
    
    var checkedin = false {
        didSet {
            if checkedin {
                self.checkinButton.backgroundColor = Const.RANKING_TOP_COLOR
                self.checkinButtonLabel.text = NSLocalizedString("Checkedin", comment:"")
                self.checkedinIconImageView.image = R.image.detail_checkin_on()
            } else {
                self.checkinButton.backgroundColor = Const.PECOMY_THEME_COLOR
                self.checkinButtonLabel.text = NSLocalizedString("DoCheckin", comment:"")
                self.checkedinIconImageView.image = R.image.detail_checkin_off()
            }
        }
    }
    
    var favorite = false {
        didSet {
            if favorite {
                self.favoriteButton.setBackgroundImage(R.image.detail_favorite_on(), forState: .Normal)
            } else {
                self.favoriteButton.setBackgroundImage(R.image.detail_favorite_off(), forState: .Normal)
            }
        }
    }
    
    init(frame:CGRect, checkedin: Bool, favorite: Bool) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        
        self.checkinBaseView.backgroundColor = .redColor()
        self.checkinBaseView.layer.cornerRadius = self.frame.height/2 - 7
        self.checkinBaseView.clipsToBounds = true
        self.addSubview(self.checkinBaseView)
        self.checkinBaseView.snp_makeConstraints { make in
            make.top.equalTo(self).offset(7)
            make.left.equalTo(self).offset(52.5)
            make.right.equalTo(self).offset(-62.5)
            make.bottom.equalTo(self).offset(-7)
        }
        
        
        self.checkinButton.backgroundColor = Const.PECOMY_THEME_COLOR
        self.checkinBaseView.addSubview(self.checkinButton)
        self.checkinButton.snp_makeConstraints { make in
            make.size.equalTo(self.checkinBaseView)
            make.center.equalTo(self.checkinBaseView)
        }
        
        self.checkinButtonLabel.text = NSLocalizedString("DoCheckin", comment:"")
        self.checkinButtonLabel.font = UIFont(name: Const.PECOMY_FONT_BOLD, size: 17)
        self.checkinButtonLabel.textColor = .whiteColor()
        self.checkinButtonLabel.textAlignment = .Center
        self.checkinButton.addSubview(self.checkinButtonLabel)
        self.checkinButtonLabel.snp_makeConstraints { make in
            make.size.equalTo(self.checkinButton)
            make.center.equalTo(self.checkinButton)
        }
        
        self.checkinButton.addSubview(self.checkedinIconImageView)
        self.checkedinIconImageView.snp_makeConstraints { make in
            make.centerY.equalTo(self.checkinButton)
            make.width.height.equalTo(24)
            make.right.equalTo(self.checkinButton).offset(-12)
        }
        
        self.favoriteButton.setBackgroundImage(R.image.detail_favorite_off(), forState: .Normal)
        self.addSubview(self.favoriteButton)
        self.favoriteButton.snp_makeConstraints { make in
            make.centerY.equalTo(self)
            make.width.height.equalTo(24)
            make.right.equalTo(self).offset(-19)
        }
    }
}