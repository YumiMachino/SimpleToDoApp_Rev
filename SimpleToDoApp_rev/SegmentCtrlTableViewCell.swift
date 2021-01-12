//
//  SegmentCtrlTableViewCell.swift
//  SimpleToDoApp_rev
//
//  Created by Yumi Machino on 2021/01/11.
//

import UIKit

class SegmentCtrlTableViewCell: UITableViewCell {
    
    let items = ["High", "Medium", "Low"]
    
    lazy var segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 1
        return control
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
         contentView.addSubview(segmentControl)
        segmentControl.matchParent(padding: .init(top: 30, left: 8, bottom: 30, right: 8))
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
