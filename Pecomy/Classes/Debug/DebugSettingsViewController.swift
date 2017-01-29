//
//  DebugSettingsViewController.swift
//  Pecomy
//
//  Created by Kenzo on 1/29/17.
//  Copyright © 2017 Pecomy. All rights reserved.
//

import UIKit

fileprivate enum DebugSectionType: Int {
    case location, _counter
    
    func sectionTitle() -> String? {
        switch self {
        case .location:
            return R.string.localizable.debugSettingsLocationSection()
        default:
            return nil
        }
    }
    
    func identifier() -> String? {
        switch self {
        case .location:
            return "locationCell"
        default:
            return nil
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
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
        self.tableView.register(TableViewSwitchCell.self, forCellReuseIdentifier: "locationSwitch")
        self.tableView.estimatedRowHeight = 50
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.navigationItem.title = R.string.localizable.settingsDebug()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
}

extension DebugSettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return DebugSectionType._counter.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = DebugSectionType(rawValue: section)!
        switch sectionType {
        case .location:
            return 2
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = DebugSectionType(rawValue: indexPath.section)
        guard let type = sectionType else {
            return tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        }
        
        switch type {
        case .location:
            var identifier = ""
            if indexPath.row == 0 {
                identifier = "locationSwitch"
                let ud = UserDefaults.standard
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TableViewSwitchCell
                cell.configureCell(withTitle: R.string.localizable.fixLocationSettingTitle(), switchState: ud.bool(forKey: Const.isFixLocationKey)) { (isOn) in
                    ud.set(isOn, forKey: Const.isFixLocationKey)
                    ud.synchronize()
                }
                return cell
            } else if indexPath.row == 1 {
                identifier = "locationCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
                cell.textLabel?.font = UIFont(name: Const.PECOMY_FONT_NORMAL, size: 14)
                cell.textLabel?.text = "lat: \(Const.fixedLatitude), lon: \(Const.fixedLongitude)"
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .none
                return cell
            } else {
                return tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            }
        default:
            fatalError("Unforgiven section")
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return DebugSectionType(rawValue: section)?.sectionTitle() ?? ""
    }
}

extension DebugSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionType = DebugSectionType(rawValue: indexPath.section)
        guard let type = sectionType else { return }
        switch type {
        case .location:
            if indexPath.row == 1 {
                let mapVC = DebugMapViewController()
                self.navigationController?.pushViewController(mapVC, animated: true)
            }
        default:
            fatalError("Unforgiven section")
        }
    }
}
