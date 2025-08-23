import Foundation

struct FFmpegConfig {
    
    // MARK: - 扩展名配置
    static let videoExtensions = ["mp4", "mov", "mkv", "webm", "m4v", "avi", "mxf"]
    static let audioExtensions = ["m4a", "mp3", "aac", "wav", "aiff", "flac", "ogg", "ape", "wv", "ac3", "dts"]
    
    // MARK: - 视频编码器配置
    static let videoCodecs: [String: VideoCodecInfo] = [
        "h264": VideoCodecInfo(
            displayName: "H.264/AVC",
            encoders: ["libx264", "h264_videotoolbox"],
            supportedExtensions: ["mp4", "mov", "mkv", "m4v", "avi"],
            presets: ["ultrafast", "superfast", "veryfast", "faster", "fast", "medium", "slow", "slower", "veryslow"],
            tunes: ["film", "animation", "grain", "stillimage", "fastdecode", "zerolatency"],
            rateControls: ["crf", "cbr", "vbr", "qp"]
        ),
        "h265": VideoCodecInfo(
            displayName: "H.265/HEVC",
            encoders: ["libx265", "hevc_videotoolbox"],
            supportedExtensions: ["mp4", "mov", "mkv", "m4v"],
            presets: ["ultrafast", "superfast", "veryfast", "faster", "fast", "medium", "slow", "slower", "veryslow"],
            tunes: ["psnr", "ssim", "grain", "zerolatency", "fastdecode"],
            rateControls: ["crf", "cbr", "vbr", "qp"]
        ),
        "vp9": VideoCodecInfo(
            displayName: "VP9",
            encoders: ["libvpx-vp9"],
            supportedExtensions: ["webm", "mkv"],
            presets: ["realtime", "good", "best"],
            tunes: [],
            rateControls: ["crf", "cbr", "vbr"]
        ),
        "av1": VideoCodecInfo(
            displayName: "AV1",
            encoders: ["libaom-av1", "librav1e", "libsvtav1"],
            supportedExtensions: ["mp4", "mkv", "webm"],
            presets: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"],
            tunes: [],
            rateControls: ["crf", "cbr", "vbr"]
        ),
        "prores": VideoCodecInfo(
            displayName: "Apple ProRes",
            encoders: ["prores_ks"],
            supportedExtensions: ["mov", "mxf"],
            presets: ["proxy", "lt", "standard", "hq", "4444", "4444xq"],
            tunes: [],
            rateControls: ["profile"]
        ),
        "dnxhr": VideoCodecInfo(
            displayName: "DNxHR",
            encoders: ["dnxhd"],
            supportedExtensions: ["mov", "mxf"],
            presets: ["dnxhr_lb", "dnxhr_sq", "dnxhr_hq", "dnxhr_hqx", "dnxhr_444"],
            tunes: [],
            rateControls: ["profile"]
        )
    ]
    
    // MARK: - 音频编码器配置
    static let audioCodecs: [String: AudioCodecInfo] = [
        "aac": AudioCodecInfo(
            displayName: "AAC",
            encoders: ["aac", "aac_at"],
            supportedExtensions: ["mp4", "m4a", "mov", "mkv"],
            bitrates: Array(stride(from: 32, through: 320, by: 32))
        ),
        "mp3": AudioCodecInfo(
            displayName: "MP3",
            encoders: ["libmp3lame"],
            supportedExtensions: ["mp3"],
            bitrates: [32, 64, 96, 128, 160, 192, 224, 256, 320]
        ),
        "flac": AudioCodecInfo(
            displayName: "FLAC",
            encoders: ["flac"],
            supportedExtensions: ["flac", "mkv"],
            bitrates: [] // 无损编码，不需要码率设置
        ),
        "pcm": AudioCodecInfo(
            displayName: "PCM",
            encoders: ["pcm_s16le", "pcm_s24le", "pcm_s32le"],
            supportedExtensions: ["wav", "aiff"],
            bitrates: [] // 无损编码，不需要码率设置
        )
    ]
    
    // MARK: - 帧率选项
    static let frameRates = [
        FrameRateOption(value: "source", displayName: "原始帧率"),
        FrameRateOption(value: "23.976", displayName: "23.976"),
        FrameRateOption(value: "24", displayName: "24"),
        FrameRateOption(value: "25", displayName: "25"),
        FrameRateOption(value: "29.97", displayName: "29.97"),
        FrameRateOption(value: "30", displayName: "30"),
        FrameRateOption(value: "50", displayName: "50"),
        FrameRateOption(value: "59.94", displayName: "59.94"),
        FrameRateOption(value: "60", displayName: "60")
    ]
    
    // MARK: - 辅助方法
    
    /// 根据扩展名获取支持的视频编码器
    static func getSupportedVideoCodecs(for extension: String) -> [String] {
        return videoCodecs.compactMap { (key, info) in
            info.supportedExtensions.contains(`extension`) ? key : nil
        }
    }
    
    /// 根据扩展名获取支持的音频编码器
    static func getSupportedAudioCodecs(for extension: String) -> [String] {
        return audioCodecs.compactMap { (key, info) in
            info.supportedExtensions.contains(`extension`) ? key : nil
        }
    }
    
    /// 根据视频编码器获取可用的编码器实现
    static func getEncoders(for videoCodec: String) -> [String] {
        return videoCodecs[videoCodec]?.encoders ?? []
    }
    
    /// 根据视频编码器获取可用的预设
    static func getPresets(for videoCodec: String) -> [String] {
        return videoCodecs[videoCodec]?.presets ?? []
    }
    
    /// 根据视频编码器获取可用的调优选项
    static func getTunes(for videoCodec: String) -> [String] {
        return videoCodecs[videoCodec]?.tunes ?? []
    }
    
    /// 根据视频编码器获取可用的码率控制方式
    static func getRateControls(for videoCodec: String) -> [String] {
        return videoCodecs[videoCodec]?.rateControls ?? []
    }
    
    /// 根据音频编码器获取可用的编码器实现
    static func getAudioEncoders(for audioCodec: String) -> [String] {
        return audioCodecs[audioCodec]?.encoders ?? []
    }
    
    /// 根据音频编码器获取可用的码率选项
    static func getBitrates(for audioCodec: String) -> [Int] {
        return audioCodecs[audioCodec]?.bitrates ?? []
    }
}

// MARK: - 数据结构

struct VideoCodecInfo {
    let displayName: String
    let encoders: [String]
    let supportedExtensions: [String]
    let presets: [String]
    let tunes: [String]
    let rateControls: [String]
}

struct AudioCodecInfo {
    let displayName: String
    let encoders: [String]
    let supportedExtensions: [String]
    let bitrates: [Int]
}

struct FrameRateOption {
    let value: String
    let displayName: String
}
