# FFmpegSwiftUI

一个基于SwiftUI的FFmpeg图形化软件，提供简单易用的视频转码界面。

## 功能特性

- 🎬 简单模式：支持单个输入文件、简单滤镜和单个输出文件
- ⚙️ 高级模式：支持复杂的FFmpeg参数配置
- 📋 任务管理：添加、启动、监控和删除转码任务
- 🔍 任务过滤：按进度状态筛选任务
- 📱 现代化UI：基于SwiftUI的直观界面

## 项目结构

```
FFmpegSwiftUI/
├── FFmpegSwiftUI/
│   ├── ContentView.swift          # 主标签页界面
│   ├── AddTaskView.swift          # 添加任务页面
│   ├── TaskPresetsView.swift      # 任务预设页面
│   ├── TaskListView.swift         # 任务列表页面
│   ├── FFmpegTaskManager.swift    # FFmpeg任务管理器
│   └── FFmpegSwiftUIApp.swift     # 应用入口
├── bin/                           # FFmpeg可执行文件目录
└── README.md                      # 项目说明
```

## 设置FFmpeg

### 方法1：使用项目内置的FFmpeg（推荐）

1. 下载FFmpeg可执行文件（适用于macOS）
2. 在项目根目录创建 `bin` 文件夹
3. 将ffmpeg可执行文件放入 `FFmpegSwiftUI/bin/` 目录
4. 在Xcode中右键点击项目，选择"Add Files to FFmpegSwiftUI"
5. 选择ffmpeg文件，确保"Add to target"中选中了FFmpegSwiftUI

### 方法2：使用系统安装的FFmpeg

如果系统中已安装FFmpeg，应用会自动检测并使用系统版本。

## 使用方法

1. **添加任务**：选择输入文件、输出位置，配置编码参数
2. **任务管理**：在任务列表中查看所有任务状态
3. **启动任务**：点击"开始任务"按钮启动转码
4. **监控进度**：实时查看转码进度和状态

## 系统要求

- macOS 12.0+
- Xcode 14.0+
- Swift 5.7+

## 开发状态

- ✅ 基础UI框架
- ✅ 任务管理功能
- ✅ FFmpeg集成
- 🔄 编码选项配置（开发中）
- 🔄 任务预设功能（开发中）
- 🔄 进度监控优化（开发中）

## 许可证

MIT License