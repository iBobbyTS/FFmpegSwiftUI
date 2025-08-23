import SwiftUI

struct TaskPresetsView: View {
    var body: some View {
        NavigationSplitView {
            // 左侧栏
            VStack(alignment: .leading, spacing: 20) {
                Text("预设管理")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("预设类型")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "video")
                            Text("视频转码")
                        }
                        .padding(.vertical, 4)
                        
                        HStack {
                            Image(systemName: "audio")
                            Text("音频转换")
                        }
                        .padding(.vertical, 4)
                        
                        HStack {
                            Image(systemName: "camera")
                            Text("截图预设")
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                Spacer()
            }
            .padding()
            .frame(minWidth: 300, maxWidth: 400)
        } detail: {
            // 右侧主内容
            VStack {
                Spacer()
                
                VStack(spacing: 20) {
                    Image(systemName: "list.bullet.rectangle")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("任务预设")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    
                    Text("此功能正在开发中...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .navigationTitle("任务预设")
        }
    }
}

#Preview {
    TaskPresetsView()
}
