//
//  ToDoUIComposer.swift
//  ToDoDemo
//
//  Created by Paul Lee on 2022/1/17.
//  Copyright © 2022 OneV's Den. All rights reserved.
//

import UIKit

class ToDoUIComposer {
    static func compose(getToDo: @escaping (@escaping (GetToDoResult) -> Void) -> Void) -> (TableViewController, TablePresenter) {
        let navc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UINavigationController
        let sut = navc.children[0] as! TableViewController
        let presenter = TablePresenter(getTodo: getToDo)
        sut.presenter = presenter
        sut.sections = [
            Section(dataSource: InputSection(presenter: presenter)),
            Section(dataSource: ToDoSection(presenter: presenter))
        ]
        
        presenter.titleView = WeakRefVirtualProxy(sut)
        presenter.addActionView = WeakRefVirtualProxy(sut)
        presenter.tableView = WeakRefVirtualProxy(sut)
        
        return (sut, presenter)
    }
}

class ToDoSwiftUIComposer {
    static func compose(getToDo: @escaping (@escaping (GetToDoResult) -> Void) -> Void) -> (ToDoListView, TablePresenter) {
        let presenter = TablePresenter(getTodo: getToDo)
        let sut = ToDoListView(presenter: presenter)
        
        presenter.titleView = sut
        presenter.tableView = sut
        presenter.inputView = sut
        presenter.addActionView = sut
        
        return (sut, presenter)
    }
}
