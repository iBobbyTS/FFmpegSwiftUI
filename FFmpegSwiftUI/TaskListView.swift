import SwiftUI

struct TaskListView: View {
    @State private var selectedProgress: Set<String> = ["等待中", "转码中", "已完成"]
    @ObservedObject var taskManager: FFmpegTaskManager
    
    let progressOptions = ["等待中", "转码中", "已完成"]
    
    var body: some View {
        NavigationSplitView {
            // 左侧栏
            VStack(alignment: .leading, spacing: 20) {
                Text("任务管理")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("过滤器")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(progressOptions, id: \.self) { option in
                            HStack {
                                Checkbox(isChecked: selectedProgress.contains(option)) {
                                    if selectedProgress.contains(option) {
                                        selectedProgress.remove(option)
                                    } else {
                                        selectedProgress.insert(option)
                                    }
                                }
                                Text(option)
                                    .font(.subheadline)
                            }
                        }
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("统计信息")
                            .font(.headline)
                        
                        HStack {
                            Text("总任务:")
                            Spacer()
                            Text("\(taskManager.tasks.count)")
                                .fontWeight(.semibold)
                        }
                        
                        HStack {
                            Text("等待中:")
                            Spacer()
                            Text("\(taskManager.tasks.filter { $0.status == .waiting }.count)")
                                .foregroundColor(.orange)
                        }
                        
                        HStack {
                            Text("转码中:")
                            Spacer()
                            Text("\(taskManager.tasks.filter { $0.status == .processing }.count)")
                                .foregroundColor(.blue)
                        }
                        
                        HStack {
                            Text("已完成:")
                            Spacer()
                            Text("\(taskManager.tasks.filter { $0.status == .completed }.count)")
                                .foregroundColor(.green)
                        }
                    }
                }
                
                Spacer()
                
                Button("清除已完成") {
                    taskManager.clearCompletedTasks()
                }
                .buttonStyle(.borderedProminent)
                .disabled(taskManager.tasks.filter { $0.status == .completed || $0.status == .failed }.isEmpty)
                .frame(maxWidth: .infinity)
            }
            .padding()
            .frame(minWidth: 300, maxWidth: 400)
        } detail: {
            // 右侧主内容
            VStack(spacing: 0) {
                // Task list
                List {
                    ForEach(filteredTasks) { task in
                        TaskRow(task: task) {
                            if task.status == .waiting {
                                taskManager.startTask(task)
                            }
                        }
                    }
                    .onDelete(perform: deleteTasks)
                }
            }
            .navigationTitle("任务列表")
        }
    }
    
    private var filteredTasks: [FFmpegTask] {
        taskManager.tasks.filter { task in
            selectedProgress.contains(task.status.rawValue)
        }
    }
    
    private func deleteTasks(offsets: IndexSet) {
        let tasksToDelete = offsets.map { filteredTasks[$0] }
        for task in tasksToDelete {
            taskManager.removeTask(task)
        }
    }
}

struct Checkbox: View {
    let isChecked: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                .foregroundColor(isChecked ? .blue : .gray)
                .font(.title2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TaskRow: View {
    let task: FFmpegTask
    let onStart: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(task.name)
                    .font(.headline)
                Spacer()
                Text(task.status.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(progressColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            if task.status == .processing {
                ProgressView(value: task.progress)
                    .progressViewStyle(LinearProgressViewStyle())
            }
            
            HStack {
                Text("输入: \(task.inputFile)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text("输出: \(task.outputFile)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if task.status == .waiting {
                Button("开始任务") {
                    onStart()
                }
                .buttonStyle(.bordered)
                .frame(maxWidth: .infinity)
            }
            
            if let errorMessage = task.errorMessage {
                Text("错误: \(errorMessage)")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 4)
    }
    
    private var progressColor: Color {
        switch task.status {
        case .waiting:
            return .orange
        case .processing:
            return .blue
        case .completed:
            return .green
        case .failed:
            return .red
        }
    }
}

#Preview {
    TaskListView(taskManager: FFmpegTaskManager())
}
