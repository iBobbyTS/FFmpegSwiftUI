//
//  ContentView.swift
//  FFmpegSwiftUI
//
//  Created by iBobby on 2025-08-18.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @StateObject private var taskManager = FFmpegTaskManager()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            AddTaskView(taskManager: taskManager)
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("添加任务")
                }
                .tag(0)
            
            TaskPresetsView()
                .tabItem {
                    Image(systemName: "list.bullet.rectangle")
                    Text("任务预设")
                }
                .tag(1)
            
            TaskListView(taskManager: taskManager)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("任务列表")
                }
                .tag(2)
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
}
