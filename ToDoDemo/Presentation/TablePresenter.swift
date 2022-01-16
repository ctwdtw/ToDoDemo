//
//  TablePresenter.swift
//  ToDoDemo
//
//  Created by Paul Lee on 2022/1/16.
//  Copyright © 2022 OneV's Den. All rights reserved.
//

import Foundation
protocol TitleView: class {
    func didUpDateTitle(_ title: String)
}

protocol TableView: class {
    func didUpdateTable()
}

protocol AddActionView: class {
    func didUpadAddActionView(isEnabled: Bool)
}

class TablePresenter {
    var getTodo: (@escaping ([String]) -> Void) -> Void = ToDoStore.shared.getToDoItems(completionHandler:)
    
    weak var titleView: TitleView?
    
    weak var tableView: TableView?
    
    weak var addActionView: AddActionView?
    
    private(set) var todos: [String] = []
    
    func getInitialViewData() {
        titleView?.didUpDateTitle("TODO - (0)")
        addActionView?.didUpadAddActionView(isEnabled: false)
    }
    
    func fetchToDo() {
        getTodo { (todos) in
            self.todos = todos
            self.titleView?.didUpDateTitle("TODO - (\(todos.count))")
            self.tableView?.didUpdateTable()
        }
    }
    
    func removeToDo(at index: Int) {
        todos.remove(at: index)
        titleView?.didUpDateTitle("TODO - (\(todos.count))")
        tableView?.didUpdateTable()
    }
    
    func insertToDo(_ toDo: String) {
        todos.insert(toDo, at: 0)
        titleView?.didUpDateTitle("TODO - (\(todos.count))")
        tableView?.didUpdateTable()
    }
    
    func inputText(_ text: String) {
        let isItemLengthEnough = text.count >= 3
        addActionView?.didUpadAddActionView(isEnabled: isItemLengthEnough)
    }
}
