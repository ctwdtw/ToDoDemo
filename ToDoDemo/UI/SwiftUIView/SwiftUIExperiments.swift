//
//  ExperimentView.swift
//  ToDoDemo
//
//  Created by Paul Lee on 2022/1/26.
//  Copyright © 2022 OneV's Den. All rights reserved.
//

import Foundation
import SwiftUI
struct HeaderView: View {
    private let title: String
    
    private let subtitle: String
    
    private let desc: String
    
    private let back: Color
    
    private let textColor: Color
    
    init(_ title: String, subtitle: String, desc: String, back: Color, textColor: Color) {
        self.title = title
        self.subtitle = subtitle
        self.desc = desc
        self.back = back
        self.textColor = textColor
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("\(title)")
                .font(.largeTitle)
            Text("\(subtitle)")
                .font(.title)
                .foregroundColor(.gray)
            Text("\(desc)")
                .frame(maxWidth: .infinity)
                .font(.title)
                .foregroundColor(textColor)
                .padding()
                .background(back)
        }
    }
}

struct MyPreView: PreviewProvider {
    static var previews: some View {
        HeaderView(
            "Hello",
            subtitle: "World",
            desc: "Short description of what I am demonstrating goes here.",
            back: .blue,
            textColor: .white
        )
    }
}
