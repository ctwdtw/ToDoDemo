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
        
        XCTAssertEqual(sut.numberOfRenderedCell(in: sut.inputSection), 1)
        XCTAssertNotNil(sut.inputView(at: 0))
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
    
    private func makeSUT() -> TableViewController {
        let navc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UINavigationController
        let sut = navc.children[0] as! TableViewController
        return sut
    }
    
}

extension ToDoDemoTests {
    private func assertThat(_ sut: TableViewController, render toDos: [String], file: StaticString = #filePath, line: UInt = #line) {
        
        toDos.enumerated().forEach { (index, toDo) in
            let toDoView = sut.cell(at: index, section: sut.toDosSection)
            XCTAssertEqual(toDoView?.textLabel?.text, toDo, file: file, line: line)
        }
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
    var inputSection: Int {
        return 0
    }
    
    var toDosSection: Int {
        return 1
    }
    
    func inputView(at index: Int) -> TableViewInputCell? {
        return cell(at: index, section: inputSection) as? TableViewInputCell
    }
    
    func toDoCell(at index: Int) -> UITableViewCell? {
        return cell(at: index, section: toDosSection)
    }
}
