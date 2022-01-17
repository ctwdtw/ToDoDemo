//
//  ToDoUIComposer.swift
//  ToDoDemo
//
//  Created by Paul Lee on 2022/1/17.
//  Copyright © 2022 OneV's Den. All rights reserved.
//

import UIKit

class ToDoUIComposer {
    static func compose(getToDo: @escaping (@escaping ([String]) -> Void) -> Void) -> (TableViewController, TablePresenter) {
        let navc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UINavigationController
        let sut = navc.children[0] as! TableViewController
        let presenter = TablePresenter(
            titleView: WeakRefVirtualProxy(sut),
            addActionView: WeakRefVirtualProxy(sut),
            tableView: WeakRefVirtualProxy(sut)
        )
        presenter.getTodo = getToDo
        
        sut.presenter = presenter
        return (sut, presenter)
    }
}
