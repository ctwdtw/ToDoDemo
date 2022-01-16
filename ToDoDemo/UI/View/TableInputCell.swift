//
//  TableInputCell.swift
//  ToDoDemo
//
//  Created by WANG WEI on 2017/7/6.
//  Copyright © 2017年 OneV's Den. All rights reserved.
//

import UIKit

class TableViewInputCell: UITableViewCell {
    
    var presenter: TablePresenter?
    
    @IBOutlet weak var textField: UITextField!
    @objc @IBAction func textFieldValueChanged(_ sender: UITextField) {
        presenter?.inputText(sender.text ?? "")
    }
}
