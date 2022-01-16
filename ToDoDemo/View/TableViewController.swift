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
    enum Section: Int {
        case input = 0, todos, max
    }
    
    var presenter = TablePresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getInitialViewData()
        presenter.fetchToDo()
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        let inputIndexPath = IndexPath(row: 0, section: Section.input.rawValue)
        guard let inputCell = tableView.cellForRow(at: inputIndexPath) as? TableViewInputCell,
              let text = inputCell.textField.text else
        {
            return
        }
        
        presenter.insertToDo(text)
    
    }
}

extension TableViewController: TitleView, TableView, AddActionView {
    func didUpDateTitle(_ title: String) {
        self.title = title
    }
    
    func didUpdateTable() {
        tableView.reloadData()
    }
    
    func didUpadAddActionView(isEnabled: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isEnabled
    }
}

extension TableViewInputCell: InputView {
    func didUpdateInputText(_ text: String) {
        textField.text = text
    }
}

extension TableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.max.rawValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            fatalError()
        }
        switch section {
        case .input: return 1
        case .todos: return presenter.todos.count
        case .max: fatalError()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError()
        }
        
        switch section {
        case .input:
            let cell = tableView.dequeueReusableCell(withIdentifier: inputCellReuseId, for: indexPath) as! TableViewInputCell
            cell.presenter = presenter
            return cell
        case .todos:
            let cell = tableView.dequeueReusableCell(withIdentifier: todoCellResueId, for: indexPath)
            cell.textLabel?.text = presenter.todos[indexPath.row]
            return cell
        default:
            fatalError()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == Section.todos.rawValue else {
            return
        }
        
        presenter.removeToDo(at: indexPath.row)
    }
}

