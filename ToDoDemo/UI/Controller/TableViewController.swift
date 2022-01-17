//
//  TableViewController.swift
//  ToDoDemo
//
//  Created by WANG WEI on 2017/7/6.
//  Copyright © 2017年 OneV's Den. All rights reserved.
//

import UIKit

let inputCellReuseId = "inputCell"
let todoCellResueId = "todoCell"

class TableViewController: UITableViewController {
    var presenter: TablePresenter!
    
    private lazy var sections: [Section] = [
        Section(dataSource: InputSection(presenter: presenter)),
        Section(dataSource: ToDoSection(presenter: presenter))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getInitialViewData()
        presenter.fetchToDo()
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        guard let inputCell = tableView.cellForRow(at: presenter.inputIndexPath) as? TableViewInputCell,
              let text = inputCell.textField.text else
        {
            return
        }
        
        presenter.insertToDo(text)
    
    }
}

//MARK: - UI
extension TableViewController: TitleView, TableView, AddActionView {
    func didUpDateTitle(_ title: String) {
        self.title = title
    }
    
    func didUpdateTable() {
        tableView.reloadData()
    }
    
    func didUpdateAddActionView(isEnabled: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isEnabled
    }
}

extension TableViewInputCell: InputView {
    func didUpdateInputText(_ text: String) {
        textField.text = text
    }
}

//MARK: - DataSource & Delegate
extension TableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let ds = sections[section].dataSource
        return ds.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ds = sections[indexPath.section].dataSource
        return ds.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dl = sections[indexPath.section].delegate
        dl?.tableView?(tableView, didSelectRowAt: indexPath)
    }
}

