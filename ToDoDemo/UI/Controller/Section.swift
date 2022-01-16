//
//  Section.swift
//  ToDoDemo
//
//  Created by Paul Lee on 2022/1/16.
//  Copyright © 2022 OneV's Den. All rights reserved.
//

import UIKit
class Section {
    let dataSource: UITableViewDataSource
    let delegate: UITableViewDelegate?
    init(dataSource: UITableViewDataSource) {
        self.dataSource = dataSource
        self.delegate = dataSource as? UITableViewDelegate
    }
}
