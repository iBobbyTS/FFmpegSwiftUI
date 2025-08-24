import SwiftUI
import AppKit
import Foundation

struct AddTaskView: View {
    @State private var isSimpleMode = true
    @State private var inputFile = ""
    @State private var outputFile = ""
    @State private var filterParameters = ""
    @State private var selectedEncoder = "H.264"
    @State private var showingOutputPicker = false
    
    // 新增状态变量
    @State private var inputFileName = ""
    @State private var outputFileName = ""
    @State private var outputFullPath = ""
    @State private var isOutputFileNameManuallySet = false
    @State private var selectedFrameRate = "source"
    @State private var includeVideo = true
    @State private var includeAudio = true
    @State private var selectedExtension = "mp4"
    @State private var selectedVideoCodec = "h264"
    @State private var selectedVideoEncoder = "libx264"
    @State private var selectedPreset = "medium"
    @State private var selectedTune = "film"
    @State private var selectedRateControl = "crf"
    @State private var selectedAudioCodec = "aac"
    @State private var selectedAudioEncoder = "aac"
    @State private var audioBitrate = 128
    @State private var ffmpegCommand = ""
    
    @ObservedObject var taskManager: FFmpegTaskManager
    
    var body: some View {
        NavigationSplitView {
            // 左侧栏
            VStack(alignment: .leading, spacing: 20) {
                Text("任务配置")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("模式选择")
                        .font(.headline)
                    
                    HStack {
                        Text("简单模式")
                            .foregroundColor(isSimpleMode ? .primary : .secondary)
                        
                        Toggle("", isOn: $isSimpleMode)
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                        
                        Text("高级模式")
                            .foregroundColor(isSimpleMode ? .secondary : .primary)
                    }
                    .padding()
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(10)
                    
                    // Tooltip for simple mode
                    if isSimpleMode {
                        HStack {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                            Text("简单模式只支持1个输入文件、简单滤镜和1个输出文件")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
            .padding()
            .frame(minWidth: 300, maxWidth: 400)
        } detail: {
            // 右侧主内容
            VStack(spacing: 0) {
                // 可滚动的内容区域
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // 简单模式布局
                        if isSimpleMode {
                            simpleModeLayout
                        } else {
                            advancedModeLayout
                        }
                    }
                    .padding()
                }
                
                // 底部固定区域
                VStack(spacing: 15) {
                    Divider()
                    
                    // FFmpeg命令显示
                    VStack(alignment: .leading, spacing: 10) {
                        Text("FFmpeg命令")
                            .font(.headline)
                        
                        TextField("完整的ffmpeg命令", text: .constant(ffmpegCommand), axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(3...6)
                            .onAppear { updateFFmpegCommand() }
                    }
                    .padding(.horizontal)
                    
                    // 添加任务按钮
                    Button("添加任务") {
                        addTask()
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .disabled(inputFile.isEmpty || outputFileName.isEmpty)
                }
                .padding(.bottom)
                .background(Color(NSColor.controlBackgroundColor))
            }
            .navigationTitle("添加任务")
            .onAppear {
                print("🚀 [DEBUG] AddTaskView 加载完成")
                print("🚀 [DEBUG] 初始状态 - showingOutputPicker: \(showingOutputPicker)")
                print("🚀 [DEBUG] 初始状态 - inputFile: '\(inputFile)'")
                print("🚀 [DEBUG] 初始状态 - outputFile: '\(outputFile)'")
            }
            .onChange(of: showingOutputPicker) { _, _ in
                print("🔄 [DEBUG] showingOutputPicker 变化")
            }
        }
        .fileImporter(
            isPresented: $showingOutputPicker,
            allowedContentTypes: [.folder],
            allowsMultipleSelection: false
        ) { result in
            print("📁 [DEBUG] outputImporter 被触发")
            switch result {
            case .success(let files):
                print("✅ [DEBUG] 文件夹选择成功，文件夹数量: \(files.count)")
                if let file = files.first {
                    print("📁 [DEBUG] 选择的文件夹: \(file.path)")
                    outputFile = file.path
                    print("📁 [DEBUG] outputFile 已设置为: \(outputFile)")
                    // 选择输出文件夹后立即计算输出文件名
                    calculateOutputFileName()
                } else {
                    print("❌ [DEBUG] 文件夹列表为空")
                }
            case .failure(let error):
                print("❌ [DEBUG] 文件夹选择失败: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - 简单模式布局
    private var simpleModeLayout: some View {
        VStack(spacing: 20) {
            // 上方：2x2表格
            VStack(spacing: 15) {
                Text("文件选择")
                    .font(.headline)
                
                // 2x2表格
                VStack(spacing: 10) {
                    // 第一行：拖拽/点击选择区域
                    HStack(spacing: 20) {
                        // 输入文件选择
                        VStack {
                            Text("输入文件")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(NSColor.controlBackgroundColor))
                                    .frame(height: 80)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                                
                                VStack {
                                    Image(systemName: "arrow.down.doc")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                    Text("拖拽文件到这里\n或点击选择")
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .onTapGesture {
                                print("🎯 [DEBUG] 输入文件区域被点击")
                                openFileSelector()
                            }
                        }
                        
                        // 输出文件夹选择
                        VStack {
                            Text("输出文件夹")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(NSColor.controlBackgroundColor))
                                    .frame(height: 80)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                                
                                VStack {
                                    Image(systemName: "folder.badge.plus")
                                        .font(.title2)
                                        .foregroundColor(.green)
                                    Text("拖拽文件夹到这里\n或点击选择")
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .onTapGesture {
                                print("📁 [DEBUG] 输出文件夹区域被点击")
                                showingOutputPicker = true
                                print("📁 [DEBUG] 设置 showingOutputPicker = true")
                            }
                        }
                    }
                    
                                         // 第二行：路径输入框
                     HStack(spacing: 20) {
                         // 输入文件路径
                         VStack(alignment: .leading) {
                             Text("输入文件路径")
                                 .font(.subheadline)
                                 .fontWeight(.medium)
                             
                             TextField("自动填入", text: $inputFile)
                                 .textFieldStyle(.roundedBorder)
                                 .onChange(of: inputFile) { _, _ in
                                     print("🔄 [DEBUG] inputFile 发生变化: \(inputFile)")
                                     if !inputFile.isEmpty {
                                         let fileName = URL(fileURLWithPath: inputFile).lastPathComponent
                                         inputFileName = fileName
                                         print("🔄 [DEBUG] inputFileName 已更新为: \(fileName)")
                                         // 输入文件变化后重新计算输出文件名
                                         calculateOutputFileName()
                                     }
                                 }
                         }
                         
                         // 输出文件路径
                         VStack(alignment: .leading) {
                             Text("输出文件路径")
                                 .font(.subheadline)
                                 .fontWeight(.medium)
                             
                             TextField("自动生成", text: $outputFullPath)
                                 .textFieldStyle(.roundedBorder)
                                 .onChange(of: outputFullPath) { oldValue, newValue in
                                     // 如果用户手动修改了完整路径，标记为手动设置
                                     if !oldValue.isEmpty && !newValue.isEmpty && oldValue != newValue {
                                         isOutputFileNameManuallySet = true
                                         print("🖊️ [DEBUG] 用户手动修改输出路径: \(newValue)")
                                         
                                         // 从完整路径中提取文件夹和文件名
                                         let url = URL(fileURLWithPath: newValue)
                                         outputFile = url.deletingLastPathComponent().path
                                         outputFileName = url.lastPathComponent
                                     }
                                 }
                                 .onChange(of: outputFile) { _, _ in
                                     calculateOutputFileName()
                                 }
                                 .onChange(of: inputFileName) { _, _ in
                                     calculateOutputFileName()
                                 }
                                 .onChange(of: selectedExtension) { _, _ in
                                     calculateOutputFileName()
                                 }
                         }
                     }
                }
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(10)
            
            // 输入参数容器
            VStack(spacing: 15) {
                Text("输入参数")
                    .font(.headline)
                
                VStack(alignment: .leading, spacing: 15) {
                    // 帧率选择
                    HStack {
                        Text("帧率:")
                            .frame(minWidth: 80, alignment: .leading)
                        
                        Picker("", selection: $selectedFrameRate) {
                            ForEach(FFmpegConfig.frameRates, id: \.value) { frameRate in
                                Text(frameRate.displayName).tag(frameRate.value)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(10)
            
            // 输出设置容器
            VStack(spacing: 15) {
                Text("输出设置")
                    .font(.headline)
                
                // 视频/音频选择
                VStack(alignment: .leading, spacing: 10) {
                    Text("输出轨道")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    HStack {
                        Checkbox(isChecked: includeVideo) {
                            includeVideo.toggle()
                        }
                        Text("视频")
                        
                        Checkbox(isChecked: includeAudio) {
                            includeAudio.toggle()
                        }
                        Text("音频")
                    }
                }
                VStack(alignment: .leading, spacing: 15) {
                    // 扩展名选择
                    HStack {
                        Text("扩展名:")
                            .frame(minWidth: 80, alignment: .leading)
                        
                        Picker("", selection: $selectedExtension) {
                            let extensions = includeVideo ? FFmpegConfig.videoExtensions : FFmpegConfig.audioExtensions
                            ForEach(extensions, id: \.self) { ext in
                                Text(ext).tag(ext)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onChange(of: includeVideo) { _, _ in
                            // 当切换视频/音频时，自动切换到合适的扩展名
                            let newExtensions = includeVideo ? FFmpegConfig.videoExtensions : FFmpegConfig.audioExtensions
                            if !newExtensions.contains(selectedExtension) {
                                selectedExtension = newExtensions.first ?? "mp4"
                            }
                            updateCodecForExtension()
                        }
                        .onChange(of: selectedExtension) { _, _ in
                            updateCodecForExtension()
                        }
                    }
                }
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(10)
                
            // 视频编码配置容器
            if includeVideo {
                VStack(spacing: 15) {
                    Text("视频编码配置")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        // 视频编码
                        HStack {
                            Text("视频编码:")
                                .frame(minWidth: 80, alignment: .leading)
                            
                            Picker("", selection: $selectedVideoCodec) {
                                let supportedCodecs = FFmpegConfig.getSupportedVideoCodecs(for: selectedExtension)
                                ForEach(supportedCodecs, id: \.self) { codec in
                                    Text(FFmpegConfig.videoCodecs[codec]?.displayName ?? codec).tag(codec)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .onChange(of: selectedVideoCodec) { _, _ in
                                updateEncoderForCodec()
                            }
                        }
                        
                        // 编码器
                        HStack {
                            Text("编码器:")
                                .frame(minWidth: 80, alignment: .leading)
                            
                            Picker("", selection: $selectedVideoEncoder) {
                                let encoders = FFmpegConfig.getEncoders(for: selectedVideoCodec)
                                ForEach(encoders, id: \.self) { encoder in
                                    Text(encoder).tag(encoder)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        // 预设
                        HStack {
                            Text("预设:")
                                .frame(minWidth: 80, alignment: .leading)
                            
                            Picker("", selection: $selectedPreset) {
                                let presets = FFmpegConfig.getPresets(for: selectedVideoCodec)
                                ForEach(presets, id: \.self) { preset in
                                    Text(preset).tag(preset)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        // 调优
                        HStack {
                            Text("调优:")
                                .frame(minWidth: 80, alignment: .leading)
                            
                            Picker("", selection: $selectedTune) {
                                let tunes = FFmpegConfig.getTunes(for: selectedVideoCodec)
                                ForEach(tunes, id: \.self) { tune in
                                    Text(tune).tag(tune)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        // 码率控制
                        HStack {
                            Text("码率控制:")
                                .frame(minWidth: 80, alignment: .leading)
                            
                            Picker("", selection: $selectedRateControl) {
                                let rateControls = FFmpegConfig.getRateControls(for: selectedVideoCodec)
                                ForEach(rateControls, id: \.self) { rateControl in
                                    Text(rateControl).tag(rateControl)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding()
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(10)
            }
            
            // 音频编码配置容器
            if includeAudio {
                VStack(spacing: 15) {
                    Text("音频编码配置")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        // 音频编码
                        HStack {
                            Text("音频编码:")
                                .frame(minWidth: 80, alignment: .leading)
                            
                            Picker("", selection: $selectedAudioCodec) {
                                let supportedCodecs = FFmpegConfig.getSupportedAudioCodecs(for: selectedExtension)
                                ForEach(supportedCodecs, id: \.self) { codec in
                                    Text(FFmpegConfig.audioCodecs[codec]?.displayName ?? codec).tag(codec)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .onChange(of: selectedAudioCodec) { _, _ in
                                updateAudioEncoderForCodec()
                            }
                        }
                        
                        // 编码器
                        HStack {
                            Text("编码器:")
                                .frame(minWidth: 80, alignment: .leading)
                            
                            Picker("", selection: $selectedAudioEncoder) {
                                let encoders = FFmpegConfig.getAudioEncoders(for: selectedAudioCodec)
                                ForEach(encoders, id: \.self) { encoder in
                                    Text(encoder).tag(encoder)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        // 码率
                        let bitrates = FFmpegConfig.getBitrates(for: selectedAudioCodec)
                        if !bitrates.isEmpty {
                            HStack {
                                Text("码率:")
                                    .frame(minWidth: 80, alignment: .leading)
                                
                                Picker("", selection: $audioBitrate) {
                                    ForEach(bitrates, id: \.self) { bitrate in
                                        Text("\(bitrate) kbps").tag(bitrate)
                                    }
                                }
                                .pickerStyle(.menu)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }
                .padding()
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(10)
            }
        }
    }
    
    // MARK: - 高级模式布局
    private var advancedModeLayout: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("高级模式")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(spacing: 10) {
                HStack {
                    Text("输入文件:")
                    Spacer()
                    Button(inputFile.isEmpty ? "选择文件" : "已选择") {
                        openFileSelector()
                    }
                    .buttonStyle(.bordered)
                }
                
                HStack {
                    Text("输出文件:")
                    Spacer()
                    Button(outputFile.isEmpty ? "选择位置" : "已选择") {
                        showingOutputPicker = true
                    }
                    .buttonStyle(.bordered)
                }
                
                if !inputFile.isEmpty {
                    Text("输入路径: \(inputFile)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                if !outputFile.isEmpty {
                    Text("输出路径: \(outputFile)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                HStack {
                    Text("滤镜:")
                    Spacer()
                    TextField("输入滤镜参数", text: $filterParameters)
                        .textFieldStyle(.roundedBorder)
                }
                
                HStack {
                    Text("编码器:")
                    Spacer()
                    Picker("编码器", selection: $selectedEncoder) {
                        Text("H.264").tag("H.264")
                        Text("H.265").tag("H.265")
                        Text("VP9").tag("VP9")
                    }
                    .pickerStyle(.menu)
                }
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(10)
        }
    }
    
    // MARK: - 辅助方法
    
    // 获取完整的输出文件路径
    private func getFullOutputPath() -> String {
        if outputFile.isEmpty || outputFileName.isEmpty {
            return "未选择输出路径"
        }
        return "\(outputFile)/\(outputFileName)"
    }
    
    // 计算输出文件名
    private func calculateOutputFileName() {
        guard !inputFile.isEmpty && !outputFile.isEmpty else {
            outputFileName = ""
            outputFullPath = ""
            isOutputFileNameManuallySet = false
            return
        }
        
        // 如果用户已经手动设置了文件名，只更新扩展名部分
        if isOutputFileNameManuallySet {
            let currentName = outputFileName
            if let dotIndex = currentName.lastIndex(of: ".") {
                let nameWithoutExt = String(currentName[..<dotIndex])
                outputFileName = "\(nameWithoutExt).\(selectedExtension)"
                print("🔄 [DEBUG] 保留用户文件名，只更新扩展名: \(outputFileName)")
            }
            outputFullPath = "\(outputFile)/\(outputFileName)"
            return
        }
        
        let inputDir = URL(fileURLWithPath: inputFile).deletingLastPathComponent()
        let outputDir = URL(fileURLWithPath: outputFile)
        
        if inputDir.path == outputDir.path {
            // 同一目录，添加"_已转换"后缀
            let nameWithoutExt = URL(fileURLWithPath: inputFile).deletingPathExtension().lastPathComponent
            outputFileName = "\(nameWithoutExt)_已转换.\(selectedExtension)"
        } else {
            // 不同目录，保持原文件名
            let inputFileName = URL(fileURLWithPath: inputFile).lastPathComponent
            let nameWithoutExt = URL(fileURLWithPath: inputFileName).deletingPathExtension().lastPathComponent
            outputFileName = "\(nameWithoutExt).\(selectedExtension)"
        }
        
        outputFullPath = "\(outputFile)/\(outputFileName)"
        print("🔄 [DEBUG] 自动计算输出文件名: \(outputFileName)")
        print("🔄 [DEBUG] 输出完整路径: \(outputFullPath)")
        print("🔄 [DEBUG] 输入目录: \(inputDir.path)")
        print("🔄 [DEBUG] 输出目录: \(outputDir.path)")
        print("🔄 [DEBUG] 是否同一目录: \(inputDir.path == outputDir.path)")
    }
    
    // 使用原生 NSOpenPanel 选择文件
    private func openFileSelector() {
        print("🔄 [DEBUG] 使用 NSOpenPanel 打开文件选择器")
        
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedContentTypes = [.movie, .video, .audio, .data]
        
        panel.begin { response in
            DispatchQueue.main.async {
                if response == .OK, let url = panel.url {
                    print("✅ [DEBUG] NSOpenPanel 文件选择成功: \(url.path)")
                    self.inputFile = url.path
                    self.inputFileName = url.lastPathComponent
                    print("🔄 [DEBUG] inputFile 已更新为: \(url.path)")
                    print("🔄 [DEBUG] inputFileName 已更新为: \(url.lastPathComponent)")
                    // 选择输入文件后立即计算输出文件名
                    self.calculateOutputFileName()
                } else {
                    print("❌ [DEBUG] NSOpenPanel 文件选择被取消")
                }
            }
        }
    }
    
    private func updateFFmpegCommand() {
        var command = "ffmpeg -i \"\(inputFile)\""
        
        // 添加帧率参数
        if selectedFrameRate != "source" {
            command += " -r \(selectedFrameRate)"
        }
        
        // 添加视频参数
        if includeVideo {
            command += " -c:v \(selectedVideoEncoder)"
            
            // 添加预设（如果支持）
            let presets = FFmpegConfig.getPresets(for: selectedVideoCodec)
            if !presets.isEmpty && presets.contains(selectedPreset) {
                if selectedVideoCodec == "prores" || selectedVideoCodec == "dnxhr" {
                    command += " -profile:v \(selectedPreset)"
                } else {
                    command += " -preset \(selectedPreset)"
                }
            }
            
            // 添加调优（如果支持）
            let tunes = FFmpegConfig.getTunes(for: selectedVideoCodec)
            if !tunes.isEmpty && tunes.contains(selectedTune) {
                command += " -tune \(selectedTune)"
            }
            
            // 添加码率控制
            switch selectedRateControl {
            case "crf":
                let crfValue = selectedVideoCodec == "h265" ? "28" : "23"
                command += " -crf \(crfValue)"
            case "cbr":
                command += " -b:v 2000k -maxrate 2000k -bufsize 4000k"
            case "vbr":
                command += " -b:v 2000k"
            case "qp":
                command += " -qp 23"
            default:
                break
            }
        } else {
            command += " -vn" // 禁用视频
        }
        
        // 添加音频参数
        if includeAudio {
            command += " -c:a \(selectedAudioEncoder)"
            
            // 添加码率（如果支持）
            let bitrates = FFmpegConfig.getBitrates(for: selectedAudioCodec)
            if !bitrates.isEmpty {
                command += " -b:a \(audioBitrate)k"
            }
        } else {
            command += " -an" // 禁用音频
        }
        
        // 添加输出文件
        if !outputFile.isEmpty && !outputFileName.isEmpty {
            let outputPath = "\(outputFile)/\(outputFileName)"
            command += " \"\(outputPath)\""
        }
        
        ffmpegCommand = command
    }
    
    private func updateCodecForExtension() {
        // 更新视频编码器
        if includeVideo {
            let supportedVideoCodecs = FFmpegConfig.getSupportedVideoCodecs(for: selectedExtension)
            if !supportedVideoCodecs.contains(selectedVideoCodec) {
                selectedVideoCodec = supportedVideoCodecs.first ?? "h264"
            }
        }
        
        // 更新音频编码器
        if includeAudio {
            let supportedAudioCodecs = FFmpegConfig.getSupportedAudioCodecs(for: selectedExtension)
            if !supportedAudioCodecs.contains(selectedAudioCodec) {
                selectedAudioCodec = supportedAudioCodecs.first ?? "aac"
            }
        }
        
        updateEncoderForCodec()
        updateAudioEncoderForCodec()
    }
    
    private func updateEncoderForCodec() {
        let encoders = FFmpegConfig.getEncoders(for: selectedVideoCodec)
        if !encoders.contains(selectedVideoEncoder) {
            selectedVideoEncoder = encoders.first ?? "libx264"
        }
        
        // 更新预设
        let presets = FFmpegConfig.getPresets(for: selectedVideoCodec)
        if !presets.contains(selectedPreset) {
            selectedPreset = presets.first ?? "medium"
        }
        
        // 更新调优
        let tunes = FFmpegConfig.getTunes(for: selectedVideoCodec)
        if !tunes.contains(selectedTune) {
            selectedTune = tunes.first ?? ""
        }
        
        // 更新码率控制
        let rateControls = FFmpegConfig.getRateControls(for: selectedVideoCodec)
        if !rateControls.contains(selectedRateControl) {
            selectedRateControl = rateControls.first ?? "crf"
        }
        
        updateFFmpegCommand()
    }
    
    private func updateAudioEncoderForCodec() {
        let encoders = FFmpegConfig.getAudioEncoders(for: selectedAudioCodec)
        if !encoders.contains(selectedAudioEncoder) {
            selectedAudioEncoder = encoders.first ?? "aac"
        }
        
        // 更新码率
        let bitrates = FFmpegConfig.getBitrates(for: selectedAudioCodec)
        if !bitrates.isEmpty && !bitrates.contains(audioBitrate) {
            audioBitrate = bitrates.contains(128) ? 128 : bitrates.first ?? 128
        }
        
        updateFFmpegCommand()
    }
    
    private func addTask() {
        let parameters = buildFFmpegParameters()
        
        // 自动生成任务名称
        let inputFileName = URL(fileURLWithPath: inputFile).lastPathComponent
        let outputName = self.outputFileName.isEmpty ? "output.\(selectedExtension)" : self.outputFileName
        let taskName = "\(inputFileName) → \(outputName)"
        
        taskManager.addTask(
            name: taskName,
            inputFile: inputFile,
            outputFile: outputFile,
            parameters: parameters
        )
        
        // Reset form
        inputFile = ""
        outputFile = ""
        filterParameters = ""
        self.inputFileName = ""
        self.outputFileName = ""
        self.outputFullPath = ""
        self.isOutputFileNameManuallySet = false
    }
    
    private func buildFFmpegParameters() -> String {
        var parameters = ""
        
        // Add encoder parameters
        switch selectedEncoder {
        case "H.264":
            parameters += "-c:v libx264 -preset medium -crf 23 "
        case "H.265":
            parameters += "-c:v libx265 -preset medium -crf 28 "
        case "VP9":
            parameters += "-c:v libvpx-vp9 -crf 30 -b:v 0 "
        default:
            parameters += "-c:v libx264 -preset medium -crf 23 "
        }
        
        // Add filter parameters if in advanced mode
        if !isSimpleMode && !filterParameters.isEmpty {
            parameters += "-vf \(filterParameters) "
        }
        
        return parameters.trimmingCharacters(in: .whitespaces)
    }
}

#Preview {
    AddTaskView(taskManager: FFmpegTaskManager())
}
