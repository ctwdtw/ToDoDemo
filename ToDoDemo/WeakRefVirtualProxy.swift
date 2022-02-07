//
//  WeakRefVirtualProxy.swift
//  ToDoDemo
//
//  Created by Paul Lee on 2022/1/17.
//  Copyright © 2022 OneV's Den. All rights reserved.
//

import Foundation
class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: TitleView where T: TitleView {
    func didUpDateTitle(_ title: String) {
        object?.didUpDateTitle(title)
    }
}

extension WeakRefVirtualProxy: TableView where T: TableView {
    func didUpdateTable() {
        object?.didUpdateTable()
    }
}

extension WeakRefVirtualProxy: AddActionView where T: AddActionView {
    func didUpdateAddActionView(isEnabled: Bool) {
        object?.didUpdateAddActionView(isEnabled: isEnabled)
    }
}
