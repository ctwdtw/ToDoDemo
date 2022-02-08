//
//  Section.swift
//  ToDoDemo
//
//  Created by Paul Lee on 2022/1/16.
//  Copyright © 2022 OneV's Den. All rights reserved.
//

import UIKit

protocol TableViewDataSourceDelegate: UITableViewDataSource, UITableViewDelegate {}

extension ToDoSection: TableViewDataSourceDelegate {}

extension InputSection: TableViewDataSourceDelegate {}
