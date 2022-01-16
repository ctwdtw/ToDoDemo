//
//  ToDoDemoTests.swift
//  ToDoDemoTests
//
//  Created by Paul Lee on 2022/1/16.
//  Copyright © 2022 OneV's Den. All rights reserved.
//

import XCTest
@testable import ToDoDemo

class ToDoDemoTests: XCTestCase {
    func test_viewDidLoad_requestToDos() {
        //
        let sut = makeSUT()
        var callCount = 0
        sut.getTodo = { _ in callCount +=  1 }
        
        //
        sut.loadViewIfNeeded()
        
        //
        XCTAssertEqual(callCount, 1)
    }
    
    func test_renderTwoSections() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.numberOfRenderedSections, 2)
    }
    
    func test_renderOneTableViewInputCellOnInputSection() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        assertRenderOneInputView(on: sut)
    }
    
    func test_renderEmptyToDos_onEmptyToDo() {
        let sut = makeSUT()
        let toDos = [String]()
        sut.getTodo = { completion in completion(toDos) }
        
        sut.loadViewIfNeeded()
        
        assertThat(sut, render: toDos)
    }
    
    func test_renderOneToDo_OnOneToDo() {
        let sut = makeSUT()
        let toDos = ["First-Todo"]
        sut.getTodo = { completion in completion(toDos) }
        
        sut.loadViewIfNeeded()
        
        assertThat(sut, render: toDos)
    }
    
    func test_renderManyToDo_onManyToDo() {
        let sut = makeSUT()
        let toDos = ["First-Todo", "Second-Todo", "Third-Todo"]
        sut.getTodo = { completion in completion(toDos) }
        
        sut.loadViewIfNeeded()
        
        assertThat(sut, render: toDos)
    }
    
    func test_renderToDoCounts() {
        let sut = makeSUT()
        let toDos = ["First-Todo", "Second-Todo"]
        sut.getTodo = { completion in completion(toDos) }
        
        sut.loadViewIfNeeded()
        
        assertThat(sut, rendersToDoCount: toDos.count)
    }
    
    func test_renderAddAction() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, enableAdd: false)
        
        sut.simulateInputText("a")
        assertThat(sut, enableAdd: false)
        
        sut.simulateInputText("ab")
        assertThat(sut, enableAdd: false)
        
        sut.simulateInputText("abc")
        assertThat(sut, enableAdd: true)
        
        sut.simulateInputText("ab")
        assertThat(sut, enableAdd: false)
    }
    
    func test_renderAddedToDo_onAdd() {
        let sut = makeSUT()
        sut.getTodo = { _ in }
        
        sut.loadViewIfNeeded()
        assertThat(sut, render: [])
        
        sut.simulateAddToDo("A-new-ToDo")
        assertThat(sut, render: ["A-new-ToDo"])
    }
    
    func test_removeToDo_onRemove() {
        let sut = makeSUT()
        let toDos = ["First-Todo", "Second-Todo", "Third-Todo"]
        sut.getTodo = { completion in completion(toDos) }

        sut.loadViewIfNeeded()
        assertThat(sut, render: toDos)

        sut.simulateRemoveToDo(at: 1)

        assertThat(sut, render: ["First-Todo", "Third-Todo"])
    }
    
    private func makeSUT() -> TableViewController {
        let navc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UINavigationController
        let sut = navc.children[0] as! TableViewController
        return sut
    }
    
}

extension ToDoDemoTests {
    private func assertThat(_ sut: TableViewController, render toDos: [String], file: StaticString = #filePath, line: UInt = #line) {
        sut.view.forceLayout()
        toDos.enumerated().forEach { (index, toDo) in
            let toDoView = sut.cell(at: index, section: sut.toDosSection)
            XCTAssertEqual(toDoView?.textLabel?.text, toDo, file: file, line: line)
        }
    }
    
    private func assertThat(_ sut: TableViewController, rendersToDoCount count: Int, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(sut.title?.contains("\(count)"), true, file: file, line: line)
    }
    
    private func assertRenderOneInputView(on sut: TableViewController, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(sut.numberOfRenderedCell(in: sut.inputSection), 1, file: file, line: line)
        XCTAssertNotNil(sut.inputView(), file: file, line: line)
    }
    
    private func assertThat(_ sut: TableViewController, enableAdd isEnabled: Bool, file: StaticString = #filePath, line: UInt = #line) {
        sut.view.forceLayout()
        XCTAssertEqual(sut.addBarButtonItem?.isEnabled, isEnabled, file: file, line: line)
    }
    
}

private extension UITableViewController {
    var numberOfRenderedSections: Int? {
        return tableView.dataSource?.numberOfSections?(in: tableView)
    }
    
    func numberOfRenderedCell(in section: Int) -> Int? {
        tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section)
    }
    
    func cell(at index: Int, section: Int) -> UITableViewCell? {
        tableView.dataSource?.tableView(tableView, cellForRowAt: IndexPath(row: index, section: section))
    }
}

private extension TableViewController {
    var addBarButtonItem: UIBarButtonItem? {
        navigationItem.rightBarButtonItem
    }
    
    var inputSection: Int {
        return 0
    }
    
    var toDosSection: Int {
        return 1
    }
    
    func inputView() -> TableViewInputCell? {
        return cell(at: 0, section: inputSection) as? TableViewInputCell
    }
    
    func toDoCell(at index: Int) -> UITableViewCell? {
        return cell(at: index, section: toDosSection)
    }
    
    func simulateInputText(_ text: String) {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: inputSection)) as? TableViewInputCell
        let textField = cell?.textField
        textField?.text = text
        textField?.sendActions(for: .editingChanged)
    }
    
    func simulateAddToDo(_ toDo: String) {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: inputSection)) as? TableViewInputCell
        cell?.textField.text = toDo
        let target = addBarButtonItem?.target
        let action = addBarButtonItem?.action
        UIApplication.shared.sendAction(action!, to: target, from: nil, for: nil)
    }
    
    func simulateRemoveToDo(at index: Int) {
        tableView.delegate?.tableView?(tableView, didSelectRowAt: IndexPath(row: index, section: toDosSection))
    }
}

extension UIView {
    func forceLayout() {
        layoutIfNeeded()
        RunLoop.main.run(until: Date())
    }
}
