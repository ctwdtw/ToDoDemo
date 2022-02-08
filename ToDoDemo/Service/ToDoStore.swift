//
//  ToDoStore.swift
//  ToDoDemo
//
//  Created by 王 巍 on 2017/7/6.
//  Copyright © 2017年 OneV's Den. All rights reserved.
//

import Foundation

let dummy = [
    ToDo(id: UUID(), title: "Buy the milk"),
    ToDo(id: UUID(), title: "Take my dog"),
    ToDo(id: UUID(), title: "Rent a car")
]

struct ToDoStore {
    static let shared = ToDoStore()
    func getToDoItems(completionHandler: @escaping ((GetToDoResult) -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completionHandler(dummy)
        }
    }
}
