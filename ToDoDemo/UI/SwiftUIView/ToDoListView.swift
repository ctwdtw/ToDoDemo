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
    private class ToDoListViewModel: ObservableObject {
        @Published
        var title = ""
        
        @Published
        var todos: [ToDoViewData] = []
        
        @Published
        var inputText = ""
        
        @Published
        var addActionEnabled = false
    }
    
    @ObservedObject private var viewModel: ToDoListViewModel = ToDoListViewModel()
    
    var body: some View {
        NavigationView {
            List {
                SwiftUI.Section("input") {
                    TextField(viewModel.inputText, text: $viewModel.inputText)
                        .onChange(of: viewModel.inputText) { newValue in
                            presenter.inputText(newValue)
                        }
                }
                
                SwiftUI.Section("todos") {
                    ForEach(Array(zip(viewModel.todos.indices, viewModel.todos)), id: \.1.id) { idx, todo in
                        Button(action: {
                            presenter.removeToDo(at: idx)
                            
                        }, label: {
                            Text(todo.title)
                            
                        })
                    }
                }
                
            }.navigationBarItems(
                trailing: Button(action: {
                    presenter.insertToDo(viewModel.inputText)
                    
                }) {
                    Image(systemName: "plus")
                }.disabled(!viewModel.addActionEnabled)
                
            ).navigationBarTitle(
                Text(viewModel.title),
                displayMode: .inline
            )
        }.onAppear {
            presenter.getInitialViewData()
            presenter.fetchToDo()
        }
        
    }
    
    let presenter: TablePresenter!
    
    init(presenter: TablePresenter) {
        self.presenter = presenter
    }
    
}

extension ToDoListView: TitleView {
    func didUpDateTitle(_ title: String) {
        viewModel.title = title
    }
}

extension ToDoListView: TableView {
    func didUpdateTable() {
        viewModel.todos = presenter.toDoViewDatas()
    }
}

extension ToDoListView: AddActionView {
    func didUpdateAddActionView(isEnabled: Bool) {
        viewModel.addActionEnabled = isEnabled
    }
}

extension ToDoListView: InputView {
    func didUpdateInputText(_ text: String) {
        viewModel.inputText = text
    }
}

//MARK: - TablePresenter + SwiftUI
extension TablePresenter {
    func toDoViewDatas() -> [ToDoViewData] {
        (0..<numberOfToDos).map { toDoViewData(at:$0) }
    }
}
