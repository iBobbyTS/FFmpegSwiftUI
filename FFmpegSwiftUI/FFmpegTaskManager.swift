import Foundation
import SwiftUI

enum TaskStatus: String, CaseIterable {
    case waiting = "等待中"
    case processing = "转码中"
    case completed = "已完成"
    case failed = "失败"
}

struct FFmpegTask: Identifiable {
    let id = UUID()
    let name: String
    let inputFile: String
    let outputFile: String
    let parameters: String
    var status: TaskStatus
    var progress: Double
    var startTime: Date?
    var endTime: Date?
    var errorMessage: String?
}

class FFmpegTaskManager: ObservableObject {
    @Published var tasks: [FFmpegTask] = []
    @Published var isProcessing = false
    
    private let ffmpegPath: String
    
    init() {
        // Get the path to ffmpeg executable in the app bundle
        if let bundlePath = Bundle.main.path(forResource: "ffmpeg", ofType: nil) {
            self.ffmpegPath = bundlePath
        } else {
            // Fallback to system path if not found in bundle
            self.ffmpegPath = "/usr/local/bin/ffmpeg"
        }
    }
    
    func addTask(name: String, inputFile: String, outputFile: String, parameters: String = "") {
        let task = FFmpegTask(
            name: name,
            inputFile: inputFile,
            outputFile: outputFile,
            parameters: parameters,
            status: .waiting,
            progress: 0.0
        )
        
        DispatchQueue.main.async {
            self.tasks.append(task)
        }
    }
    
    func startTask(_ task: FFmpegTask) {
        guard let taskIndex = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        
        DispatchQueue.main.async {
            self.tasks[taskIndex].status = .processing
            self.tasks[taskIndex].startTime = Date()
            self.isProcessing = true
        }
        
        // Execute FFmpeg command
        executeFFmpegCommand(task: task, taskIndex: taskIndex)
    }
    
    private func executeFFmpegCommand(task: FFmpegTask, taskIndex: Int) {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: ffmpegPath)
        
        // Build command arguments
        var arguments = ["-i", task.inputFile]
        
        if !task.parameters.isEmpty {
            arguments.append(contentsOf: task.parameters.components(separatedBy: " "))
        }
        
        arguments.append(task.outputFile)
        
        process.arguments = arguments
        
        // Set up pipe for output
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        
        // Handle process completion
        process.terminationHandler = { [weak self] process in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if process.terminationStatus == 0 {
                    self.tasks[taskIndex].status = .completed
                    self.tasks[taskIndex].progress = 1.0
                    self.tasks[taskIndex].endTime = Date()
                } else {
                    self.tasks[taskIndex].status = .failed
                    self.tasks[taskIndex].errorMessage = "FFmpeg process failed with exit code \(process.terminationStatus)"
                }
                
                self.isProcessing = false
            }
        }
        
        do {
            try process.run()
        } catch {
            DispatchQueue.main.async {
                self.tasks[taskIndex].status = .failed
                self.tasks[taskIndex].errorMessage = "Failed to start FFmpeg: \(error.localizedDescription)"
                self.isProcessing = false
            }
        }
    }
    
    func removeTask(_ task: FFmpegTask) {
        DispatchQueue.main.async {
            self.tasks.removeAll { $0.id == task.id }
        }
    }
    
    func clearCompletedTasks() {
        DispatchQueue.main.async {
            self.tasks.removeAll { $0.status == .completed || $0.status == .failed }
        }
    }
}
