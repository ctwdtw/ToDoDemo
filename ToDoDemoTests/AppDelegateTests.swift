//
//  AppDelegateTests.swift
//  ToDoDemoTests
//
//  Created by Paul Lee on 2022/1/17.
//  Copyright © 2022 OneV's Den. All rights reserved.
//

import XCTest
@testable import ToDoDemo

class AppDelegateTests: XCTestCase {

    func test_didFinishLaunch_configureWindow() {
        let sut = AppDelegate()
        sut.window = UIWindow()
        _ = sut.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
        
        XCTAssertNotNil(sut.window?.rootViewController as? UINavigationController)
        XCTAssertNotNil(sut.window?.rootViewController?.children[0] as? TableViewController)
    }
}
