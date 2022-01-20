//
//  TablePresenter.swift
//  ToDoDemo
//
//  Created by Paul Lee on 2022/1/16.
//  Copyright © 2022 OneV's Den. All rights reserved.
//

import Foundation
protocol TitleView {
    func didUpDateTitle(_ title: String)
}

protocol TableView {
    func didUpdateTable()
}

protocol AddActionView {
    func didUpdateAddActionView(isEnabled: Bool)
}

protocol InputView {
    func didUpdateInputText(_ text: String)
}

class TablePresenter {
    private let getTodo: (@escaping ([String]) -> Void) -> Void
    
    private let titleView: TitleView?
    
    private let addActionView: AddActionView?
    
    private let tableView: TableView?
    
    var inputView: InputView?
    
    init(titleView: TitleView,
         addActionView: AddActionView,
         tableView: TableView,
         getTodo: @escaping (@escaping ([String]) -> Void) -> Void = ToDoStore.shared.getToDoItems(completionHandler:)
    ) {
        self.titleView = titleView
        self.addActionView = addActionView
        self.tableView = tableView
        self.getTodo = getTodo
    }
    
    private var todos: [String] = []
    
    var numberOfToDos: Int {
        return todos.count
    }
    
    let inputSection = 0
    
    var inputIndexPath: IndexPath {
        IndexPath(row: 0, section: inputSection)
    }
    
    func getInitialViewData() {
        titleView?.didUpDateTitle(presentedToDoCount())
        addActionView?.didUpdateAddActionView(isEnabled: false)
    }
    
    func fetchToDo() {
        getTodo { (todos) in
            self.todos = todos
            self.titleView?.didUpDateTitle(self.presentedToDoCount())
            self.tableView?.didUpdateTable()
        }
    }
    
    
    func removeToDo(at index: Int) {
        todos.remove(at: index)
        titleView?.didUpDateTitle(presentedToDoCount())
        tableView?.didUpdateTable()
    }
    
    func insertToDo(_ toDo: String) {
        todos.insert(toDo, at: 0)
        titleView?.didUpDateTitle(presentedToDoCount())
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
    
    //MARK: - presentation
    private func presentedToDoCount() -> String {
        return "TODO = \(todos.count)"
    }
}
