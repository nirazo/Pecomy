//
//  DebugSettingsViewController.swift
//  Pecomy
//
//  Created by Kenzo on 1/29/17.
//  Copyright © 2017 Pecomy. All rights reserved.
//

import UIKit

fileprivate enum DebugSectionType: Int {
    case location
    
    func sectionTitle() -> String? {
        switch self {
        case .location:
            return R.string.localizable.debugSettingsLocationSection()
        }
    }
    
    func identifier() -> String? {
        switch self {
        case .location:
            return "locationCell"
        }
    }
}

class DebugSettingsViewController: UIViewController {
    let tableView = UITableView(frame: .zero, style: .grouped)
    final let cellIdentifier = "CellIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.center.size.equalToSuperview()
        }
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        self.tableView.register(TableViewSwitchCell.self, forCellReuseIdentifier: "locationSwitch")
        self.tableView.estimatedRowHeight = 50
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.navigationItem.title = R.string.localizable.settingsDebug()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension DebugSettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = DebugSectionType(rawValue: indexPath.row)
        guard let type = sectionType else {
            return tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        }
        
        switch type {
        case .location:
            var identifier = ""
            if indexPath.row == 0 {
                identifier = "locationSwitch"
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TableViewSwitchCell
                cell.configureCell(withTitle: R.string.localizable.fixLocationSettingTitle(), switchState: AppState.sharedInstance.useFixedLocation) { (isOn) in
                    AppState.sharedInstance.useFixedLocation = isOn
                    print("fixed: \(isOn)")
                }
                return cell
            } else if indexPath.row == 1 {
                identifier = "locationCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
                return cell
            } else {
                return tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return DebugSectionType(rawValue: section)?.sectionTitle() ?? ""
    }
}

extension DebugSettingsViewController: UITableViewDelegate {
    
}
