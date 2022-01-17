//
//  ToDoUIComposer.swift
//  ToDoDemo
//
//  Created by Paul Lee on 2022/1/17.
//  Copyright © 2022 OneV's Den. All rights reserved.
//

import UIKit

class ToDoUIComposer {
    static func compose(getToDo: @escaping (([String]) -> Void) -> Void) -> TableViewController {
        let navc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UINavigationController
        let sut = navc.childViewControllers[0] as! TableViewController
        let presenter = TablePresenter()
        presenter.getTodo = getToDo
        presenter.titleView = sut
        presenter.tableView = sut
        presenter.addActionView = sut
        sut.presenter = presenter
        return sut
    }
}
