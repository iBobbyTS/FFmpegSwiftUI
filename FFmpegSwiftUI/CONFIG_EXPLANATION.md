# FFmpeg配置系统说明

## 🎯 **已解决的问题**

1. **修复了Picker选择问题**：解决了 `"mp4" is invalid and does not have an associated tag` 的错误
2. **创建了结构化配置文件**：所有编码选项都集中管理在 `FFmpegConfig.swift` 中
3. **实现了智能关联**：扩展名、编码器、预设等选项会根据选择自动更新

## 📁 **配置文件结构 (FFmpegConfig.swift)**

### **1. 扩展名配置**
```swift
// 视频扩展名
static let videoExtensions = ["mp4", "mov", "mkv", "webm", "m4v", "avi", "mxf"]

// 音频扩展名  
static let audioExtensions = ["m4a", "mp3", "aac", "wav", "aiff", "flac", "ogg", "ape", "wv", "ac3", "dts"]
```

### **2. 视频编码器配置**
每个视频编码器包含：
- `displayName`: 显示名称（如 "H.264/AVC"）
- `encoders`: 可用的编码器实现（如 ["libx264", "h264_videotoolbox"]）
- `supportedExtensions`: 支持的文件格式
- `presets`: 预设选项（速度/质量平衡）
- `tunes`: 调优选项（针对特定内容类型）
- `rateControls`: 码率控制方式（crf、cbr、vbr等）

支持的编码器：
- **H.264/AVC**: 最兼容的视频编码
- **H.265/HEVC**: 更高效的压缩
- **VP9**: Google开发的开源编码
- **AV1**: 下一代开源编码
- **Apple ProRes**: 专业视频制作
- **DNxHR**: Avid专业格式

### **3. 音频编码器配置**
每个音频编码器包含：
- `displayName`: 显示名称
- `encoders`: 可用的编码器实现
- `supportedExtensions`: 支持的文件格式
- `bitrates`: 可用的码率选项

支持的编码器：
- **AAC**: 高质量有损压缩
- **MP3**: 通用有损格式
- **FLAC**: 无损压缩
- **PCM**: 未压缩音频

### **4. 帧率选项**
支持常见的视频帧率：
- 原始帧率（保持输入文件帧率）
- 23.976, 24, 25（电影标准）
- 29.97, 30（电视标准）
- 50, 59.94, 60（高帧率）

## 🔄 **智能关联系统**

### **自动更新机制**
1. **扩展名变化时**：
   - 自动筛选支持该扩展名的编码器
   - 如果当前编码器不支持，自动切换到支持的第一个

2. **编码器变化时**：
   - 更新可用的编码器实现
   - 更新预设、调优、码率控制选项
   - 确保所有选择都是有效的

3. **视频/音频切换时**：
   - 自动切换到相应的扩展名列表
   - 重新计算支持的编码器

### **辅助方法**
```swift
// 根据扩展名获取支持的编码器
FFmpegConfig.getSupportedVideoCodecs(for: "mp4")

// 根据编码器获取可用选项
FFmpegConfig.getEncoders(for: "h264")
FFmpegConfig.getPresets(for: "h264") 
FFmpegConfig.getTunes(for: "h264")
FFmpegConfig.getRateControls(for: "h264")
```

## 🛠 **FFmpeg命令生成**

现在可以生成更准确的FFmpeg命令：

### **示例输出**
```bash
# H.264编码示例
ffmpeg -i "input.mov" -r 30 -c:v libx264 -preset medium -tune film -crf 23 -c:a aac -b:a 128k "output.mp4"

# H.265编码示例  
ffmpeg -i "input.mov" -c:v libx265 -preset medium -tune grain -crf 28 -c:a aac -b:a 128k "output.mp4"

# 仅音频示例
ffmpeg -i "input.wav" -vn -c:a libmp3lame -b:a 192k "output.mp3"
```

### **智能参数选择**
- **CRF值**: H.264默认23，H.265默认28
- **预设处理**: ProRes和DNxHR使用profile，其他使用preset
- **调优**: 只在编码器支持时添加
- **码率**: 根据音频编码器自动选择合适的码率

## 🎨 **用户体验改进**

1. **无效选择预防**: Picker不会显示不支持的选项
2. **自动纠正**: 选择不兼容的组合时自动调整到兼容选项
3. **实时命令预览**: 所有选项变化都会实时更新FFmpeg命令
4. **智能默认值**: 根据文件类型选择最佳默认编码器

## 📈 **扩展性**

配置系统设计为易于扩展：
- 添加新编码器只需在配置字典中添加条目
- 新的文件格式支持只需更新扩展名列表
- 编码器特定的选项可以独立配置

这个配置系统为FFmpeg图形化界面提供了强大而灵活的基础，确保用户选择的所有参数组合都是有效的。
