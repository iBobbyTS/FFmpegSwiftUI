import Foundation

struct FFmpegConfig {
    
    // MARK: - 扩展名配置
    static let videoExtensions = ["mp4", "mov", "mkv", "webm", "m4v", "avi", "mxf"]
    static let audioExtensions = ["m4a", "mp3", "aac", "wav", "aiff", "flac", "ogg", "ape", "wv", "ac3", "dts", "mov"]
    
    // MARK: - 视频编码器配置
    static let videoCodecs: [String: VideoCodecInfo] = [
        "h264": VideoCodecInfo(
            displayName: "H.264/AVC",
            encoders: ["libx264", "h264_videotoolbox"],
            supportedExtensions: ["mp4", "mov", "mkv", "m4v", "avi"]
        ),
        "h265": VideoCodecInfo(
            displayName: "H.265/HEVC",
            encoders: ["libx265", "hevc_videotoolbox"],
            supportedExtensions: ["mp4", "mov", "mkv", "m4v"]
        ),
        "vp9": VideoCodecInfo(
            displayName: "VP9",
            encoders: ["libvpx-vp9"],
            supportedExtensions: ["webm", "mkv"]
        ),
        "av1": VideoCodecInfo(
            displayName: "AV1",
            encoders: ["libaom-av1", "librav1e", "libsvtav1"],
            supportedExtensions: ["mp4", "mkv", "webm"]
        ),
        "prores": VideoCodecInfo(
            displayName: "Apple ProRes",
            encoders: ["prores_ks", "prores_videotoolbox"],
            supportedExtensions: ["mov", "mxf"]
        ),
        "dnxhr": VideoCodecInfo(
            displayName: "DNxHR",
            encoders: ["dnxhd"],
            supportedExtensions: ["mov", "mxf"]
        )
    ]
    
    // MARK: - 视频编码器详细配置
    static let videoEncoders: [String: VideoEncoder] = [
        "libx264": VideoEncoder(
            displayName: "x264",
            presets: [
                EncoderOption(value: "ultrafast", displayName: "Ultrafast"),
                EncoderOption(value: "superfast", displayName: "Superfast"),
                EncoderOption(value: "veryfast", displayName: "Veryfast"),
                EncoderOption(value: "faster", displayName: "Faster"),
                EncoderOption(value: "fast", displayName: "Fast"),
                EncoderOption(value: "medium", displayName: "Medium"),
                EncoderOption(value: "slow", displayName: "Slow"),
                EncoderOption(value: "slower", displayName: "Slower"),
                EncoderOption(value: "veryslow", displayName: "Veryslow")
            ],
            tunes: [
                EncoderOption(value: "film", displayName: "Film"),
                EncoderOption(value: "animation", displayName: "Animation"),
                EncoderOption(value: "grain", displayName: "Grain"),
                EncoderOption(value: "stillimage", displayName: "Still Image"),
                EncoderOption(value: "fastdecode", displayName: "Fast Decode"),
                EncoderOption(value: "zerolatency", displayName: "Zero Latency"),
                EncoderOption(value: "psnr", displayName: "PSNR"),
                EncoderOption(value: "ssim", displayName: "SSIM")
            ],
            profiles: [
                EncoderOption(value: "baseline", displayName: "Baseline"),
                EncoderOption(value: "main", displayName: "Main"),
                EncoderOption(value: "high", displayName: "High"),
                EncoderOption(value: "high10", displayName: "High 10"),
                EncoderOption(value: "high422", displayName: "High 4:2:2"),
                EncoderOption(value: "high444", displayName: "High 4:4:4")
            ],
            rateControls: [
                EncoderOption(value: "crf", displayName: "CRF"),
                EncoderOption(value: "cbr", displayName: "CBR"),
                EncoderOption(value: "vbr", displayName: "VBR"),
                EncoderOption(value: "qp", displayName: "QP")
            ]
        ),
        "h264_videotoolbox": VideoEncoder(
            displayName: "H.264 (硬件加速)",
            presets: [
                EncoderOption(value: "fast", displayName: "Fast"),
                EncoderOption(value: "medium", displayName: "Medium"),
                EncoderOption(value: "slow", displayName: "Slow")
            ],
            tunes: [],
            profiles: [
                EncoderOption(value: "baseline", displayName: "Baseline"),
                EncoderOption(value: "main", displayName: "Main"),
                EncoderOption(value: "high", displayName: "High")
            ],
            rateControls: [
                EncoderOption(value: "cbr", displayName: "CBR"),
                EncoderOption(value: "vbr", displayName: "VBR")
            ]
        ),
        "libx265": VideoEncoder(
            displayName: "x265",
            presets: [
                EncoderOption(value: "ultrafast", displayName: "Ultrafast"),
                EncoderOption(value: "superfast", displayName: "Superfast"),
                EncoderOption(value: "veryfast", displayName: "Veryfast"),
                EncoderOption(value: "faster", displayName: "Faster"),
                EncoderOption(value: "fast", displayName: "Fast"),
                EncoderOption(value: "medium", displayName: "Medium"),
                EncoderOption(value: "slow", displayName: "Slow"),
                EncoderOption(value: "slower", displayName: "Slower"),
                EncoderOption(value: "veryslow", displayName: "Veryslow")
            ],
            tunes: [
                EncoderOption(value: "psnr", displayName: "PSNR"),
                EncoderOption(value: "ssim", displayName: "SSIM"),
                EncoderOption(value: "grain", displayName: "Grain"),
                EncoderOption(value: "zerolatency", displayName: "Zero Latency"),
                EncoderOption(value: "fastdecode", displayName: "Fast Decode")
            ],
            profiles: [
                EncoderOption(value: "main", displayName: "Main"),
                EncoderOption(value: "main10", displayName: "Main 10"),
                EncoderOption(value: "main422-10", displayName: "Main 4:2:2 10"),
                EncoderOption(value: "main444-10", displayName: "Main 4:4:4 10"),
                EncoderOption(value: "main444-16", displayName: "Main 4:4:4 16")
            ],
            rateControls: [
                EncoderOption(value: "crf", displayName: "CRF"),
                EncoderOption(value: "cbr", displayName: "CBR"),
                EncoderOption(value: "vbr", displayName: "VBR"),
                EncoderOption(value: "qp", displayName: "QP")
            ]
        ),
        "hevc_videotoolbox": VideoEncoder(
            displayName: "HEVC (硬件加速)",
            presets: [
                EncoderOption(value: "fast", displayName: "Fast"),
                EncoderOption(value: "medium", displayName: "Medium"),
                EncoderOption(value: "slow", displayName: "Slow")
            ],
            tunes: [],
            profiles: [
                EncoderOption(value: "main", displayName: "Main"),
                EncoderOption(value: "main10", displayName: "Main 10")
            ],
            rateControls: [
                EncoderOption(value: "cbr", displayName: "CBR"),
                EncoderOption(value: "vbr", displayName: "VBR")
            ]
        ),
        "libvpx-vp9": VideoEncoder(
            displayName: "libvpx-vp9",
            presets: [
                EncoderOption(value: "realtime", displayName: "Realtime"),
                EncoderOption(value: "good", displayName: "Good"),
                EncoderOption(value: "best", displayName: "Best")
            ],
            tunes: [],
            profiles: [],
            rateControls: [
                EncoderOption(value: "crf", displayName: "CRF"),
                EncoderOption(value: "cbr", displayName: "CBR"),
                EncoderOption(value: "vbr", displayName: "VBR")
            ]
        ),
        "libaom-av1": VideoEncoder(
            displayName: "AOMedia AV1",
            presets: [
                EncoderOption(value: "0", displayName: "Level 0"),
                EncoderOption(value: "1", displayName: "Level 1"),
                EncoderOption(value: "2", displayName: "Level 2"),
                EncoderOption(value: "3", displayName: "Level 3"),
                EncoderOption(value: "4", displayName: "Level 4"),
                EncoderOption(value: "5", displayName: "Level 5"),
                EncoderOption(value: "6", displayName: "Level 6"),
                EncoderOption(value: "7", displayName: "Level 7"),
                EncoderOption(value: "8", displayName: "Level 8"),
                EncoderOption(value: "9", displayName: "Level 9"),
                EncoderOption(value: "10", displayName: "Level 10"),
                EncoderOption(value: "11", displayName: "Level 11"),
                EncoderOption(value: "12", displayName: "Level 12")
            ],
            tunes: [],
            profiles: [],
            rateControls: [
                EncoderOption(value: "crf", displayName: "CRF"),
                EncoderOption(value: "cbr", displayName: "CBR"),
                EncoderOption(value: "vbr", displayName: "VBR")
            ]
        ),
        "librav1e": VideoEncoder(
            displayName: "Rav1e",
            presets: [
                EncoderOption(value: "0", displayName: "Level 0"),
                EncoderOption(value: "1", displayName: "Level 1"),
                EncoderOption(value: "2", displayName: "Level 2"),
                EncoderOption(value: "3", displayName: "Level 3"),
                EncoderOption(value: "4", displayName: "Level 4"),
                EncoderOption(value: "5", displayName: "Level 5"),
                EncoderOption(value: "6", displayName: "Level 6"),
                EncoderOption(value: "7", displayName: "Level 7"),
                EncoderOption(value: "8", displayName: "Level 8"),
                EncoderOption(value: "9", displayName: "Level 9"),
                EncoderOption(value: "10", displayName: "Level 10")
            ],
            tunes: [],
            profiles: [],
            rateControls: [
                EncoderOption(value: "crf", displayName: "CRF"),
                EncoderOption(value: "cbr", displayName: "CBR"),
                EncoderOption(value: "vbr", displayName: "VBR")
            ]
        ),
        "libsvtav1": VideoEncoder(
            displayName: "SVT-AV1",
            presets: [
                EncoderOption(value: "0", displayName: "Level 0"),
                EncoderOption(value: "1", displayName: "Level 1"),
                EncoderOption(value: "2", displayName: "Level 2"),
                EncoderOption(value: "3", displayName: "Level 3"),
                EncoderOption(value: "4", displayName: "Level 4"),
                EncoderOption(value: "5", displayName: "Level 5"),
                EncoderOption(value: "6", displayName: "Level 6"),
                EncoderOption(value: "7", displayName: "Level 7"),
                EncoderOption(value: "8", displayName: "Level 8"),
                EncoderOption(value: "9", displayName: "Level 9"),
                EncoderOption(value: "10", displayName: "Level 10"),
                EncoderOption(value: "11", displayName: "Level 11"),
                EncoderOption(value: "12", displayName: "Level 12")
            ],
            tunes: [],
            profiles: [],
            rateControls: [
                EncoderOption(value: "crf", displayName: "CRF"),
                EncoderOption(value: "cbr", displayName: "CBR"),
                EncoderOption(value: "vbr", displayName: "VBR")
            ]
        ),
        "prores_ks": VideoEncoder(
            displayName: "ProRes (prores_ks（逆向工程）)",
            presets: [
                EncoderOption(value: "proxy", displayName: "Proxy"),
                EncoderOption(value: "lt", displayName: "LT"),
                EncoderOption(value: "standard", displayName: "Standard"),
                EncoderOption(value: "hq", displayName: "HQ"),
                EncoderOption(value: "4444", displayName: "4444"),
                EncoderOption(value: "4444xq", displayName: "4444XQ")
            ],
            tunes: [],
            profiles: [],
            rateControls: [
                EncoderOption(value: "profile", displayName: "Profile")
            ]
        ),
        "prores_videotoolbox": VideoEncoder(
            displayName: "ProRes (硬件加速)",
            presets: [
                EncoderOption(value: "proxy", displayName: "Proxy"),
                EncoderOption(value: "lt", displayName: "LT"),
                EncoderOption(value: "standard", displayName: "Standard"),
                EncoderOption(value: "hq", displayName: "HQ"),
                EncoderOption(value: "4444", displayName: "4444"),
                EncoderOption(value: "4444xq", displayName: "4444XQ")
            ],
            tunes: [],
            profiles: [],
            rateControls: [
                EncoderOption(value: "profile", displayName: "Profile")
            ]
        ),
        "dnxhd": VideoEncoder(
            displayName: "DNxHD (FFmpeg原生)",
            presets: [
                EncoderOption(value: "dnxhr_lb", displayName: "DNxHR LB"),
                EncoderOption(value: "dnxhr_sq", displayName: "DNxHR SQ"),
                EncoderOption(value: "dnxhr_hq", displayName: "DNxHR HQ"),
                EncoderOption(value: "dnxhr_hqx", displayName: "DNxHR HQX"),
                EncoderOption(value: "dnxhr_444", displayName: "DNxHR 444")
            ],
            tunes: [],
            profiles: [],
            rateControls: [
                EncoderOption(value: "profile", displayName: "Profile")
            ]
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
        "alac": AudioCodecInfo(
            displayName: "ALAC",
            encoders: ["alac", "alac_at"],
            supportedExtensions: ["m4a", "mov"],
            bitrates: [] // 无损编码，不需要码率设置
        ),
        "pcm": AudioCodecInfo(
            displayName: "PCM",
            encoders: ["pcm_s16le", "pcm_s16be", "pcm_s24le", "pcm_s24be", "pcm_s32le", "pcm_s32be", "pcm_f32le", "pcm_f32be", "pcm_f64le", "pcm_f64be"],
            supportedExtensions: ["wav", "aiff", "mov"],
            bitrates: [] // 无损编码，不需要码率设置
        )
    ]
    
    // MARK: - 音频编码器详细配置
    static let audioEncoders: [String: AudioEncoder] = [
        "aac": AudioEncoder(
            displayName: "AAC (FFmpeg原生)",
            bitrates: Array(stride(from: 32, through: 320, by: 32)),
            quality: [
                EncoderOption(value: "0", displayName: "最高质量"),
                EncoderOption(value: "1", displayName: "高质量"),
                EncoderOption(value: "2", displayName: "中等质量"),
                EncoderOption(value: "3", displayName: "低质量"),
                EncoderOption(value: "4", displayName: "最低质量"),
                EncoderOption(value: "5", displayName: "极低质量")
            ],
            profiles: [
                EncoderOption(value: "aac_low", displayName: "AAC-LC"),
                EncoderOption(value: "aac_he", displayName: "AAC-HE"),
                EncoderOption(value: "aac_he_v2", displayName: "AAC-HE v2")
            ]
        ),
        "aac_at": AudioEncoder(
            displayName: "AAC (硬件加速)",
            bitrates: Array(stride(from: 32, through: 320, by: 32)),
            quality: [
                EncoderOption(value: "0", displayName: "最高质量"),
                EncoderOption(value: "1", displayName: "高质量"),
                EncoderOption(value: "2", displayName: "中等质量"),
                EncoderOption(value: "3", displayName: "低质量"),
                EncoderOption(value: "4", displayName: "最低质量"),
                EncoderOption(value: "5", displayName: "极低质量")
            ],
            profiles: [
                EncoderOption(value: "aac_low", displayName: "AAC-LC"),
                EncoderOption(value: "aac_he", displayName: "AAC-HE"),
                EncoderOption(value: "aac_he_v2", displayName: "AAC-HE v2")
            ]
        ),
        "libmp3lame": AudioEncoder(
            displayName: "MP3 (Lame MP3)",
            bitrates: [32, 64, 96, 128, 160, 192, 224, 256, 320],
            quality: [
                EncoderOption(value: "0", displayName: "最高质量"),
                EncoderOption(value: "1", displayName: "高质量"),
                EncoderOption(value: "2", displayName: "中等质量"),
                EncoderOption(value: "3", displayName: "低质量"),
                EncoderOption(value: "4", displayName: "最低质量"),
                EncoderOption(value: "5", displayName: "极低质量"),
                EncoderOption(value: "6", displayName: "极低质量"),
                EncoderOption(value: "7", displayName: "极低质量"),
                EncoderOption(value: "8", displayName: "极低质量"),
                EncoderOption(value: "9", displayName: "极低质量")
            ],
            profiles: [
                EncoderOption(value: "cbr", displayName: "CBR"),
                EncoderOption(value: "vbr", displayName: "VBR"),
                EncoderOption(value: "abr", displayName: "ABR")
            ]
        ),
        "alac": AudioEncoder(
            displayName: "ALAC (FFmpeg原生)",
            bitrates: [],
            quality: nil,
            profiles: nil
        ),
        "alac_at": AudioEncoder(
            displayName: "ALAC (硬件加速)",
            bitrates: [],
            quality: nil,
            profiles: nil
        ),
        "flac": AudioEncoder(
            displayName: "FLAC (FFmpeg原生)",
            bitrates: [],
            quality: [
                EncoderOption(value: "0", displayName: "最高压缩"),
                EncoderOption(value: "1", displayName: "高压缩"),
                EncoderOption(value: "2", displayName: "中等压缩"),
                EncoderOption(value: "3", displayName: "低压缩"),
                EncoderOption(value: "4", displayName: "最低压缩"),
                EncoderOption(value: "5", displayName: "无压缩"),
                EncoderOption(value: "6", displayName: "无压缩"),
                EncoderOption(value: "7", displayName: "无压缩"),
                EncoderOption(value: "8", displayName: "无压缩")
            ],
            profiles: nil
        ),
        "pcm_s16le": AudioEncoder(
            displayName: "PCM 16-bit (Little Endian)",
            bitrates: [],
            quality: nil,
            profiles: nil
        ),
        "pcm_s16be": AudioEncoder(
            displayName: "PCM 16-bit (Big Endian)",
            bitrates: [],
            quality: nil,
            profiles: nil
        ),
        "pcm_s24le": AudioEncoder(
            displayName: "PCM 24-bit (Little Endian)",
            bitrates: [],
            quality: nil,
            profiles: nil
        ),
        "pcm_s24be": AudioEncoder(
            displayName: "PCM 24-bit (Big Endian)",
            bitrates: [],
            quality: nil,
            profiles: nil
        ),
        "pcm_f32le": AudioEncoder(
            displayName: "PCM 32-bit (Little Endian)",
            bitrates: [],
            quality: nil,
            profiles: nil
        ),
        "pcm_f32be": AudioEncoder(
            displayName: "PCM 32-bit (Big Endian)",
            bitrates: [],
            quality: nil,
            profiles: nil
        ),
        "pcm_s32le": AudioEncoder(
            displayName: "PCM 32-bit (Little Endian)",
            bitrates: [],
            quality: nil,
            profiles: nil
        ),
        "pcm_s32be": AudioEncoder(
            displayName: "PCM 32-bit (Big Endian)",
            bitrates: [],
            quality: nil,
            profiles: nil
        ),
        "pcm_f64le": AudioEncoder(
            displayName: "PCM 64-bit (Little Endian)",
            bitrates: [],
            quality: nil,
            profiles: nil
        ),
        "pcm_f64be": AudioEncoder(
            displayName: "PCM 64-bit (Big Endian)",
            bitrates: [],
            quality: nil,
            profiles: nil
        ),
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
    static func getPresets(for encoder: String) -> [String] {
        return videoEncoders[encoder]?.presets.map { $0.value } ?? []
    }
    
    /// 根据视频编码器获取可用的调优选项
    static func getTunes(for encoder: String) -> [String] {
        return videoEncoders[encoder]?.tunes.map { $0.value } ?? []
    }
    
    /// 根据视频编码器获取可用的Profile选项
    static func getProfiles(for encoder: String) -> [String] {
        return videoEncoders[encoder]?.profiles.map { $0.value } ?? []
    }
    
    /// 根据视频编码器获取可用的码率控制方式
    static func getRateControls(for encoder: String) -> [String] {
        return videoEncoders[encoder]?.rateControls.map { $0.value } ?? []
    }
    
    /// 根据音频编码器获取可用的编码器实现
    static func getAudioEncoders(for audioCodec: String) -> [String] {
        return audioCodecs[audioCodec]?.encoders ?? []
    }
    
    /// 根据音频编码器获取可用的码率选项
    static func getBitrates(for encoder: String) -> [Int] {
        return audioEncoders[encoder]?.bitrates ?? []
    }
    
    /// 根据音频编码器获取可用的质量选项
    static func getQualityOptions(for encoder: String) -> [String] {
        return audioEncoders[encoder]?.quality?.map { $0.value } ?? []
    }
    
    /// 根据音频编码器获取可用的Profile选项
    static func getAudioProfiles(for encoder: String) -> [String] {
        return audioEncoders[encoder]?.profiles?.map { $0.value } ?? []
    }
    
    // MARK: - 显示名称转换方法
    
    // 视频编码器显示名称
    static func getVideoEncoderDisplayName(_ encoder: String) -> String {
        return videoEncoders[encoder]?.displayName ?? encoder
    }
    
    // 音频编码器显示名称
    static func getAudioEncoderDisplayName(_ encoder: String) -> String {
        return audioEncoders[encoder]?.displayName ?? encoder
    }
    
    // 预设显示名称
    static func getPresetDisplayName(_ preset: String, for encoder: String) -> String {
        return videoEncoders[encoder]?.presets.first { $0.value == preset }?.displayName ?? preset
    }
    
    // 调优显示名称
    static func getTuneDisplayName(_ tune: String, for encoder: String) -> String {
        return videoEncoders[encoder]?.tunes.first { $0.value == tune }?.displayName ?? tune
    }
    
    // Profile显示名称
    static func getProfileDisplayName(_ profile: String, for encoder: String) -> String {
        return videoEncoders[encoder]?.profiles.first { $0.value == profile }?.displayName ?? profile
    }
    
    // 码率控制显示名称
    static func getRateControlDisplayName(_ rateControl: String, for encoder: String) -> String {
        return videoEncoders[encoder]?.rateControls.first { $0.value == rateControl }?.displayName ?? rateControl.uppercased()
    }
    
    // 音频质量选项显示名称
    static func getAudioQualityDisplayName(_ quality: String, for encoder: String) -> String {
        return audioEncoders[encoder]?.quality?.first { $0.value == quality }?.displayName ?? quality
    }
    
    // 音频Profile显示名称
    static func getAudioProfileDisplayName(_ profile: String, for encoder: String) -> String {
        return audioEncoders[encoder]?.profiles?.first { $0.value == profile }?.displayName ?? profile
    }
}

// MARK: - 数据结构

struct VideoCodecInfo {
    let displayName: String
    let encoders: [String]
    let supportedExtensions: [String]
}

struct VideoEncoder {
    let displayName: String
    let presets: [EncoderOption]
    let tunes: [EncoderOption]
    let profiles: [EncoderOption]
    let rateControls: [EncoderOption]
}

struct AudioEncoder {
    let displayName: String
    let bitrates: [Int]
    let quality: [EncoderOption]?
    let profiles: [EncoderOption]?
}

struct EncoderOption {
    let value: String
    let displayName: String
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
