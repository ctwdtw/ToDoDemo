//
//  ToDoSection.swift
//  ToDoDemo
//
//  Created by Paul Lee on 2022/1/16.
//  Copyright © 2022 OneV's Den. All rights reserved.
//

import UIKit
class ToDoSection: NSObject, UITableViewDataSource, UITableViewDelegate {
    private let presenter: TablePresenter
    
    init(presenter: TablePresenter) {
        self.presenter = presenter
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfToDos
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: todoCellResueId, for: indexPath)
        cell.textLabel?.text = presenter.toDoViewModel(at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.removeToDo(at: indexPath.row)
    }
}
