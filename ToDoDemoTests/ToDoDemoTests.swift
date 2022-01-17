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
        var callCount = 0
        let sut = makeSUT(getToDo: { _ in callCount +=  1 } )
        
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
        
        sut.loadViewIfNeeded()
        
        assertThat(sut, render: [])
    }
    
    func test_renderOneToDo_OnOneToDo() {
        let toDos = ["First-Todo"]
        let sut = makeSUT(stubToDos: toDos)
        
        sut.loadViewIfNeeded()
        
        assertThat(sut, render: toDos)
    }
    
    func test_renderManyToDo_onManyToDo() {
        let toDos = ["First-Todo", "Second-Todo", "Third-Todo"]
        let sut = makeSUT(stubToDos: toDos)
        
        sut.loadViewIfNeeded()
        
        assertThat(sut, render: toDos)
    }
    
    func test_renderToDoCounts() {
        let toDos = ["First-Todo", "Second-Todo"]
        let sut = makeSUT(stubToDos: toDos)
        
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
        
        sut.loadViewIfNeeded()
        assertThat(sut, render: [])
        
        sut.simulateAddToDo("A-new-ToDo")
        assertThat(sut, render: ["A-new-ToDo"])
    }
    
    func test_disableAddAction_afterAdd() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, render: [])
        
        sut.simulateAddToDo("A-new-ToDo")
        assertThat(sut, enableAdd: false)
    }
    
    func test_removeToDo_onRemove() {
        let toDos = ["First-Todo", "Second-Todo", "Third-Todo"]
        let sut = makeSUT(stubToDos: toDos)
        
        sut.loadViewIfNeeded()
        assertThat(sut, render: toDos)

        sut.simulateRemoveToDo(at: 1)
        assertThat(sut, render: ["First-Todo", "Third-Todo"])
    }
    
    private func makeSUT(
        stubToDos: [String] = [],
        file: StaticString = #filePath, line: UInt = #line
    ) -> TableViewController {
        
        let sut = ToDoUIComposer.compose(getToDo: { complete in complete(stubToDos) })
        
        trackForMemoryLeak(sut, file: file, line: line)
        
        return sut
    }
    
    private func makeSUT(
        getToDo: @escaping (([String]) -> Void) -> Void,
        file: StaticString = #filePath, line: UInt = #line
    ) -> TableViewController {
        
        let sut = ToDoUIComposer.compose(getToDo: getToDo)
        
        trackForMemoryLeak(sut, file: file, line: line)
        
        return sut
    }
}

extension ToDoDemoTests {
    private func assertThat(_ sut: TableViewController, render toDos: [String], file: StaticString = #filePath, line: UInt = #line) {
        sut.view.forceLayout()
        toDos.enumerated().forEach { (index, toDo) in
            let toDoView = sut.cell(at: index, section: sut.toDosSection)
            XCTAssertEqual(toDoView?.textLabel?.text, toDo, "receive \(String(describing: toDoView?.textLabel?.text)), but expect \(toDo)", file: file, line: line)
        }
    }
    
    private func assertThat(_ sut: TableViewController, rendersToDoCount count: Int, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(sut.title?.contains("\(count)"), true, "title :\(String(describing: sut.title)), does not contain number \(count)", file: file, line: line)
    }
    
    private func assertRenderOneInputView(on sut: TableViewController, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(sut.numberOfRenderedCell(in: sut.inputSection), 1,
                       "receive \(String(describing: sut.numberOfRenderedCell(in: sut.inputSection))) rows at inputSection but expect 1", file: file, line: line)
        XCTAssertNotNil(sut.inputView(), "InputView should not be nil", file: file, line: line)
    }
    
    private func assertThat(_ sut: TableViewController, enableAdd isEnabled: Bool, file: StaticString = #filePath, line: UInt = #line) {
        sut.view.forceLayout()
        XCTAssertEqual(sut.addBarButtonItem?.isEnabled, isEnabled,
                       "addAction enable status is \(String(describing: sut.addBarButtonItem?.isEnabled)), but expect \(isEnabled)", file: file, line: line)
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
        simulateInputText(toDo)
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

extension XCTestCase {
    func trackForMemoryLeak(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "instance \(String(describing: instance)) should have been deallocated", file: file, line: line)
        }
    }
}

