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

struct ToDoViewData: Identifiable {
    let id: UUID
    let title: String
}

class TablePresenter {
    private let getTodo: (@escaping (GetToDoResult) -> Void) -> Void
    
    private let titleView: TitleView?
    
    private let addActionView: AddActionView?
    
    private let tableView: TableView?
    
    var inputView: InputView?
    
    init(titleView: TitleView,
         addActionView: AddActionView,
         tableView: TableView,
         getTodo: @escaping (@escaping (GetToDoResult) -> Void) -> Void = ToDoStore.shared.getToDoItems(completionHandler:)
    ) {
        self.titleView = titleView
        self.addActionView = addActionView
        self.tableView = tableView
        self.getTodo = getTodo
    }
    
    private var todos: [ToDo] = []
    
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
        getTodo { [weak self] (todos) in
            guard let self = self else { return }
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
    
    func insertToDo(_ title: String) {
        todos.insert(ToDo(id: UUID(), title: title), at: 0)
        titleView?.didUpDateTitle(presentedToDoCount())
        tableView?.didUpdateTable()
        inputView?.didUpdateInputText("")
        addActionView?.didUpdateAddActionView(isEnabled: false)
    }
    
    func inputText(_ text: String) {
        let isItemLengthEnough = text.count >= 3
        addActionView?.didUpdateAddActionView(isEnabled: isItemLengthEnough)
    }
    
    func toDoViewData(at index: Int) -> ToDoViewData {
        let todo = todos[index]
        return ToDoViewData(id: todo.id, title: todo.title)
    }
    
    //MARK: - presentation
    private func presentedToDoCount() -> String {
        return "TODO = \(todos.count)"
    }
}
