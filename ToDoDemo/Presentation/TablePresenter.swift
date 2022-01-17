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
    func didUpdateAddActionView(isEnabled: Bool)
}

protocol InputView: class {
    func didUpdateInputText(_ text: String)
}

class TablePresenter {
    var getTodo: (@escaping ([String]) -> Void) -> Void = ToDoStore.shared.getToDoItems(completionHandler:)
    
    weak var titleView: TitleView?
    
    weak var addActionView: AddActionView?
    
    weak var tableView: TableView?
    
    weak var inputView: InputView?
    
    private var todos: [String] = []
    
    var numberOfToDos: Int {
        return todos.count
    }
    
    let inputSection = 0
    
    var inputIndexPath: IndexPath {
        IndexPath(row: 0, section: inputSection)
    }
    
    func getInitialViewData() {
        titleView?.didUpDateTitle("TODO - (0)")
        addActionView?.didUpdateAddActionView(isEnabled: false)
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
        inputView?.didUpdateInputText("")
        addActionView?.didUpdateAddActionView(isEnabled: false)
    }
    
    func inputText(_ text: String) {
        let isItemLengthEnough = text.count >= 3
        addActionView?.didUpdateAddActionView(isEnabled: isItemLengthEnough)
    }
    
    func toDoViewModel(at index: Int) -> String {
        return todos[index]
    }
}
