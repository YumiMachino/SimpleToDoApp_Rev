//
//  AddEditTableViewCell.swift
//  SimpleToDoApp_rev
//
//  Created by Yumi Machino on 2021/01/11.
//

import UIKit

class AddEditTableViewCell: UITableViewCell {

    let textField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textField)
        textField.matchParent(padding: .init(top: 10, left: 8, bottom: 10, right: 8))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
