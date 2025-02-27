//
//  DemoApp.swift
//  Demo
//
//  Created by Yuki Kuwashima on 2025/02/14.
//

import SwiftUI

@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                NavigationLink("Sample1") {
                    Sample1()
                }
                NavigationLink("Sample2") {
                    Sample2()
                }
                NavigationLink("Sample3") {
                    Sample3()
                }
                NavigationLink("Sample4") {
                    Sample4()
                }
            }
        }
    }
}
