//
//  ToDo.swift
//  ToDoDemo
//
//  Created by Paul Lee on 2022/1/28.
//  Copyright © 2022 OneV's Den. All rights reserved.
//

import Foundation
struct ToDo: Identifiable {
    let id: UUID
    let title: String
}

typealias GetToDoResult = [ToDo]
