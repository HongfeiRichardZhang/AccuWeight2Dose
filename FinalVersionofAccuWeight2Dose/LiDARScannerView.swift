import SwiftUI
import Combine
import ARKit
import MetalKit
import RealityKit

/// A SwiftUI wrapper that presents the LiDAR scanning experience and notifies 
/// the parent view of the measured weight (in kilograms).
struct LiDARScannerView: View {
    /// Callback invoked when the scanner finishes and returns a weight value.
    var onWeightMeasured: (Double) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var cancellable: AnyCancellable?

    var body: some View {
        LiDARScanView(onWeightMeasured: onWeightMeasured, dismiss: dismiss)
            .ignoresSafeArea()
            .onAppear {
                // Listen for the notification that carries the measured weight
                cancellable = NotificationCenter.default
                    .publisher(for: .lidarWeightMeasured)
                    .compactMap { $0.object as? Double }
                    .sink { weight in
                        onWeightMeasured(weight)
                    }
            }
            .onDisappear {
                cancellable?.cancel()
            }
    }
}

// MARK: - LiDAR Scanning Implementation

/// The main view for LiDAR scanning functionality
private struct LiDARScanView: View {
    var onWeightMeasured: (Double) -> Void
    var dismiss: DismissAction
    @State private var coordinator = LiDARCoordinator()
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            // AR view
            ARViewContainer(coordinator: coordinator)
                .ignoresSafeArea()
            
            // UI overlay
            VStack {
                Spacer()
                
                HStack {
                    // 取消按钮移到左下角
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .padding()
                            .shadow(radius: 2)
                    }
                    .padding(.leading, 20)
                    .padding(.bottom, 30)
                    
                    Spacer()
                    
                    Button(action: {
                        // 生成一个模拟的重量值
                        let simulatedWeight = Double.random(in: 3.0...100.0) * 0.5
                        
                        // 发送通知
                        NotificationCenter.default.post(
                            name: .lidarWeightMeasured,
                            object: simulatedWeight
                        )
                        
                        // 显示成功提示
                        alertMessage = "扫描完成: \(String(format: "%.2f", simulatedWeight))kg"
                        showingAlert = true
                        
                        // 延迟关闭，给用户时间看到提示
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            onWeightMeasured(simulatedWeight)
                            dismiss()
                        }
                    }) {
                        Image(systemName: "square.and.arrow.down")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .padding()
                            .background(Circle().fill(Color.blue))
                            .shadow(radius: 3)
                    }
                    .padding(.trailing, 30)
                    .padding(.bottom, 30)
                }
                
                Text("Move device to scan patient")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                    .padding(.bottom, 20)
            }
            
            // 显示提示信息
            if showingAlert {
                VStack {
                    Text(alertMessage)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.3))
            }
        }
    }
}

/// ARView container to display the camera and mesh
struct ARViewContainer: UIViewRepresentable {
    let coordinator: LiDARCoordinator
    
    func makeUIView(context: Context) -> ARSCNView {
        return coordinator.scnView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        // Nothing to update
    }
}

/// Coordinator for the LiDAR scanning functionality
class LiDARCoordinator: NSObject, ARSCNViewDelegate {
    // 使用 ARSCNView 代替 ARView，以便更好地控制网格显示
    let scnView = ARSCNView()
    let session = ARSession()
    
    override init() {
        super.init()
        setupARView()
    }
    
    private func setupARView() {
        // 设置 AR 会话和代理
        scnView.session = session
        scnView.delegate = self
        
        // 确保设备支持 LiDAR
        guard ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) else {
            print("此设备不支持 LiDAR")
            return
        }
        
        // 配置 AR 会话
        let configuration = ARWorldTrackingConfiguration()
        
        // 启用网格重建
        configuration.sceneReconstruction = .mesh
        
        // 启用深度数据
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
            configuration.frameSemantics.insert(.sceneDepth)
        }
        
        // 启用人物分割（如果支持）
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentation) {
            configuration.frameSemantics.insert(.personSegmentation)
        }
        
        // 设置场景视图选项
        scnView.debugOptions = [.showFeaturePoints]
        
        // 设置环境纹理，保持物体可见性
        configuration.environmentTexturing = .automatic
        
        // 设置背景为透明，以便看到相机画面
        scnView.backgroundColor = .clear
        
        // 启动 AR 会话
        session.run(configuration)
    }
    
    // MARK: - ARSCNViewDelegate
    
    // 当检测到新的 AR 锚点时调用
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // 只处理网格锚点
        guard let meshAnchor = anchor as? ARMeshAnchor else { return }
        
        // 创建网格几何体
        let geometry = SCNGeometry.createFromMeshAnchor(meshAnchor)
        
        // 创建绿色材质
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        material.transparency = 0.7  // 半透明
        material.isDoubleSided = true
        material.fillMode = .lines  // 线框模式
        
        // 应用材质到几何体
        geometry.materials = [material]
        
        // 清除节点的现有几何体
        node.childNodes.forEach { $0.removeFromParentNode() }
        
        // 创建一个新节点来显示网格
        let meshNode = SCNNode(geometry: geometry)
        node.addChildNode(meshNode)
    }
    
    // 当更新 AR 锚点时调用
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // 只处理网格锚点
        guard let meshAnchor = anchor as? ARMeshAnchor else { return }
        
        // 创建网格几何体
        let geometry = SCNGeometry.createFromMeshAnchor(meshAnchor)
        
        // 创建绿色材质
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        material.transparency = 0.7  // 半透明
        material.isDoubleSided = true
        material.fillMode = .lines  // 线框模式
        
        // 应用材质到几何体
        geometry.materials = [material]
        
        // 清除节点的现有几何体
        node.childNodes.forEach { $0.removeFromParentNode() }
        
        // 创建一个新节点来显示网格
        let meshNode = SCNNode(geometry: geometry)
        node.addChildNode(meshNode)
    }
    
    func saveCurrentScan() {
        // 在实际应用中，这里会处理网格数据并计算体积/重量
        // 现在我们只是生成一个模拟值
        let simulatedWeight = Double.random(in: 3.0...100.0) * 0.5
        
        // 发送通知
        NotificationCenter.default.post(
            name: .lidarWeightMeasured,
            object: simulatedWeight
        )
    }
}

// MARK: - Helper Extensions

extension SCNGeometry {
    // 从 ARMeshAnchor 创建 SCNGeometry
    static func createFromMeshAnchor(_ meshAnchor: ARMeshAnchor) -> SCNGeometry {
        let vertices = meshAnchor.geometry.vertices
        let normals = meshAnchor.geometry.normals
        let faces = meshAnchor.geometry.faces
        
        // 创建几何体源
        let vertexSource = SCNGeometrySource(buffer: vertices.buffer,
                                            vertexFormat: vertices.format,
                                            semantic: .vertex,
                                            vertexCount: vertices.count,
                                            dataOffset: vertices.offset,
                                            dataStride: vertices.stride)
        
        let normalSource = SCNGeometrySource(buffer: normals.buffer,
                                            vertexFormat: normals.format,
                                            semantic: .normal,
                                            vertexCount: normals.count,
                                            dataOffset: normals.offset,
                                            dataStride: normals.stride)
        
        // 创建几何体元素
        let element = SCNGeometryElement(buffer: faces.buffer,
                                        primitiveType: .triangles,
                                        primitiveCount: faces.count,
                                        bytesPerIndex: faces.bytesPerIndex)
        
        // 创建几何体
        return SCNGeometry(sources: [vertexSource, normalSource], elements: [element])
    }
}

// MARK: - Notification Name Helper

extension Notification.Name {
    /// Posted by the LiDAR scanner once the user saves a scan and the
    /// calculated mass (in kg) is available.
    static let lidarWeightMeasured = Notification.Name("lidarWeightMeasured")
}
