//
//  ToDoListView.swift
//  ToDoDemo
//
//  Created by Paul Lee on 2022/1/22.
//  Copyright © 2022 OneV's Den. All rights reserved.
//

import SwiftUI

struct ToDoListViewPreview: PreviewProvider {
    static var previews: some View {
        let (listView, _) = ToDoSwiftUIComposer.compose { complete in
            complete([ToDo(id: UUID(), title: "hi-there")])
        }

        return listView
    }
}

struct ToDoListView: View {
    @State private var todos: [ToDoViewData] = []
    
    var body: some View {
        
        List($todos, id: \.id) { $todo in
            Text(todo.title)
            
        }.onAppear {
            presenter.fetchToDo()
            presenter.getInitialViewData()
        }
    }
    
    let presenter: TablePresenter!
    
    init(presenter: TablePresenter) {
        self.presenter = presenter
    }
    
}

extension ToDoListView: TableView {
    func didUpdateTable() {
        let fetchedToDoViewData = presenter.toDoViewDatas()
        todos = fetchedToDoViewData
    }
}

extension ToDoListView: TitleView {
    func didUpDateTitle(_ title: String) {
        
    }
}

extension ToDoListView: AddActionView {
    func didUpdateAddActionView(isEnabled: Bool) {
        
    }
}



extension ToDoListView: InputView {
    func didUpdateInputText(_ text: String) {
        
    }
}

//MARK: - TablePresenter + SwiftUI
extension TablePresenter {
    func toDoViewDatas() -> [ToDoViewData] {
        (0...numberOfToDos-1).map { toDoViewData(at:$0) }
    }
}
