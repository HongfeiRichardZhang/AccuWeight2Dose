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
                        let simulatedWeight = Double.random(in: 3.0...100.0) * 0.5
                        
                        NotificationCenter.default.post(
                            name: .lidarWeightMeasured,
                            object: simulatedWeight
                        )
                        
                        alertMessage = "Scanning completed: \(String(format: "%.2f", simulatedWeight))kg"
                        showingAlert = true
                        
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
    let scnView = ARSCNView()
    let session = ARSession()
    
    override init() {
        super.init()
        setupARView()
    }
    
    private func setupARView() {
        scnView.session = session
        scnView.delegate = self
        
        guard ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) else {
            print("This device does not support LiDAR")
            return
        }
        
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.sceneReconstruction = .mesh
        
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
            configuration.frameSemantics.insert(.sceneDepth)
        }
        
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentation) {
            configuration.frameSemantics.insert(.personSegmentation)
        }
        
        scnView.debugOptions = [.showFeaturePoints]
        
        configuration.environmentTexturing = .automatic
        
        scnView.backgroundColor = .clear
        
        session.run(configuration)
    }
    
    // MARK: - ARSCNViewDelegate
    
    // Called when a new AR anchor is detected
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Only handles grid anchor points
        guard let meshAnchor = anchor as? ARMeshAnchor else { return }
        
        // Creating Mesh Geometry
        let geometry = SCNGeometry.createFromMeshAnchor(meshAnchor)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        material.transparency = 0.7
        material.isDoubleSided = true
        material.fillMode = .lines
        
        geometry.materials = [material]
        
        node.childNodes.forEach { $0.removeFromParentNode() }
        
        let meshNode = SCNNode(geometry: geometry)
        node.addChildNode(meshNode)
    }
    
    // Called when the AR anchor is updated
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // Only handles grid anchor points
        guard let meshAnchor = anchor as? ARMeshAnchor else { return }
        
        // Creating Mesh Geometry
        let geometry = SCNGeometry.createFromMeshAnchor(meshAnchor)
        
        // Creating a Green Material
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        material.transparency = 0.7  // translucent
        material.isDoubleSided = true
        material.fillMode = .lines  // Wireframe Mode
        
        // Applying Materials to Geometry
        geometry.materials = [material]
        
        // Clears the node's existing geometry
        node.childNodes.forEach { $0.removeFromParentNode() }
        
        // Create a new node to display the mesh
        let meshNode = SCNNode(geometry: geometry)
        node.addChildNode(meshNode)
    }
    
    func saveCurrentScan() {
        // In a real application, this would process the mesh data and calculate volume/weight
        // For now, we're just generating a simulated value
        let simulatedWeight = Double.random(in: 3.0...100.0) * 0.5
        
        // Send notification
        NotificationCenter.default.post(
            name: .lidarWeightMeasured,
            object: simulatedWeight
        )
    }
}

// MARK: - Helper Extensions

extension SCNGeometry {
    // Create an SCNGeometry from ARMeshAnchor
    static func createFromMeshAnchor(_ meshAnchor: ARMeshAnchor) -> SCNGeometry {
        let vertices = meshAnchor.geometry.vertices
        let normals = meshAnchor.geometry.normals
        let faces = meshAnchor.geometry.faces
        
        // Create a geometry source
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
        
        // Creating geometric elements
        let element = SCNGeometryElement(buffer: faces.buffer,
                                        primitiveType: .triangles,
                                        primitiveCount: faces.count,
                                        bytesPerIndex: faces.bytesPerIndex)
        
        // Creating Geometry
        return SCNGeometry(sources: [vertexSource, normalSource], elements: [element])
    }
}

// MARK: - Notification Name Helper

extension Notification.Name {
    /// Posted by the LiDAR scanner once the user saves a scan and the
    /// calculated mass (in kg) is available.
    static let lidarWeightMeasured = Notification.Name("lidarWeightMeasured")
}
