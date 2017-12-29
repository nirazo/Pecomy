//
//  TableViewSwitchCell.swift
//  Pecomy
//
//  Created by Kenzo on 1/29/17.
//  Copyright © 2017 Pecomy. All rights reserved.
//

import UIKit

class TableViewSwitchCell: UITableViewCell {
    let cellSwitch = UISwitch()
    var switchChanged: ((Bool) -> Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSubviews() {
        self.accessoryView = self.cellSwitch
        self.cellSwitch.addTarget(self, action: #selector(switchTapped(sender:)), for: .touchUpInside)
    }
    
    func configureCell(withTitle: String?, switchState: Bool, changedClosure: ((Bool) -> Void)?) {
        self.textLabel?.text = withTitle
        self.switchChanged = changedClosure
        self.cellSwitch.isOn = switchState
    }
    
    @objc func switchTapped(sender: UISwitch) {
        self.switchChanged?(sender.isOn)
    }
}
