import UIKit
import SceneKit
import ARKit

class ARMeasurementViewController: UIViewController, ARSCNViewDelegate {
    
    // MARK: - Properties
    private let sceneView: ARSCNView = {
        let view = ARSCNView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Done", for: .normal)
        button.backgroundColor = UIColor(red: 37/255, green: 99/255, blue: 235/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tap to set start point"
        label.textAlignment = .center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        label.textColor = .white
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.numberOfLines = 0
        return label
    }()
    
    private var markers = [SCNNode]()
    private var distanceNode: SCNNode?
    private var line = SCNNode()
    private var currentMeasurement: Float = 0.0
    var onMeasurementComplete: ((Float) -> Void)?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAR()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.addSubview(sceneView)
        view.addSubview(doneButton)
        view.addSubview(instructionLabel)
        
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            instructionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            instructionLabel.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -20),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            doneButton.widthAnchor.constraint(equalToConstant: 100),
            doneButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    private func setupAR() {
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: sceneView)
        
        // If we already have a measurement, clear it and start over
        if markers.count >= 2 {
            for marker in markers {
                marker.removeFromParentNode()
            }
            markers = []
            line.removeFromParentNode()
            distanceNode?.removeFromParentNode()
            instructionLabel.text = "Tap to set start point"
            return
        }
        
        let results = sceneView.hitTest(location, types: .featurePoint)
        if let result = results.first {
            addMarker(at: result)
            
            if markers.count == 1 {
                instructionLabel.text = "Tap to set end point"
            } else if markers.count == 2 {
                calculate()
                instructionLabel.text = "Tap anywhere to measure again"
            }
        }
    }
    
    // MARK: - Measurement Functions
    private func createTriangleMarker() -> SCNNode {
        let height: Float = 0.03
        let base: Float = 0.02
        
        // Create vertices for a downward-pointing triangle
        let vertices: [SCNVector3] = [
            SCNVector3(0, 0, 0),            // Bottom point (tip)
            SCNVector3(-base/2, height, 0),  // Top Left
            SCNVector3(base/2, height, 0),   // Top Right
        ]
        
        let indices: [Int32] = [0, 1, 2]
        
        let source = SCNGeometrySource(vertices: vertices)
        let element = SCNGeometryElement(indices: indices, primitiveType: .triangles)
        
        let geometry = SCNGeometry(sources: [source], elements: [element])
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.blue
        material.isDoubleSided = true
        geometry.materials = [material]
        
        let node = SCNNode(geometry: geometry)
        
        // Create a container node
        let containerNode = SCNNode()
        containerNode.addChildNode(node)
        
        return containerNode
    }
    
    private func addMarker(at location: ARHitTestResult) {
        let markerNode = createTriangleMarker()
        
        // Position the marker exactly at the point
        markerNode.position = SCNVector3(
            x: location.worldTransform.columns.3.x,
            y: location.worldTransform.columns.3.y,
            z: location.worldTransform.columns.3.z
        )
        
        // Make the triangle look at the camera
        let lookAtConstraint = SCNBillboardConstraint()
        lookAtConstraint.freeAxes = .Y  // Only rotate around Y axis
        markerNode.constraints = [lookAtConstraint]
        
        sceneView.scene.rootNode.addChildNode(markerNode)
        markers.append(markerNode)
    }
    
    private func calculate() {
        let firstPoint = markers[0]
        let secondPoint = markers[1]
        let distance = sqrt(
            pow((secondPoint.position.x - firstPoint.position.x), 2) +
            pow((secondPoint.position.y - firstPoint.position.y), 2) +
            pow((secondPoint.position.z - firstPoint.position.z), 2)
        )
        
        currentMeasurement = round(abs(distance * 100) * 10) / 10
        
        // Calculate midpoint for label position
        let midPoint = SCNVector3(
            (firstPoint.position.x + secondPoint.position.x) / 2,
            (firstPoint.position.y + secondPoint.position.y) / 2 + 0.02,
            (firstPoint.position.z + secondPoint.position.z) / 2
        )
        
        // Create and add distance label
        let labelNode = createDistanceLabel(distance: currentMeasurement, position: midPoint)
        sceneView.scene.rootNode.addChildNode(labelNode)
        
        addLines(firstPoint, secondPoint)
        doneButton.isHidden = false
    }
    
    private func getColorForHeight(_ height: Float) -> UIColor {
        let heightRanges = DosageData.heightWeightRanges
        
        for range in heightRanges {
            if height >= Float(range.heightMin) && height <= Float(range.heightMax) {
                switch range.color {
                case "grey": return .gray
                case "pink": return .systemPink
                case "red": return .red
                case "purple": return .purple
                case "yellow": return .yellow
                case "white": return .white
                case "blue": return .blue
                case "orange": return .orange
                case "green": return .green
                default: return .black
                }
            }
        }
        return .black
    }
    
    private func createDistanceLabel(distance: Float, position: SCNVector3) -> SCNNode {
        // Remove existing distance node
        distanceNode?.removeFromParentNode()
        
        // Get text color based on height range
        let textColor = getColorForHeight(distance)
        
        // Create background plane - make it wider to accommodate both units
        let backgroundGeometry = SCNPlane(width: 0.15, height: 0.04)
        let backgroundMaterial = SCNMaterial()
        // Use dark background for white text, light background for other colors
        backgroundMaterial.diffuse.contents = textColor == .white ? 
            UIColor.black.withAlphaComponent(0.8) : 
            UIColor.white.withAlphaComponent(0.8)
        backgroundGeometry.materials = [backgroundMaterial]
        let backgroundNode = SCNNode(geometry: backgroundGeometry)
        
        // Create text with both units
        let inchesValue = distance / 2.54
        let text = SCNText(string: String(format: "%.1f cm | %.1f in", distance, inchesValue), extrusionDepth: 1)
        text.font = UIFont.systemFont(ofSize: 8)
        text.firstMaterial?.diffuse.contents = textColor
        
        let textNode = SCNNode(geometry: text)
        textNode.scale = SCNVector3(0.002, 0.002, 0.002)
        
        // Center text in background
        let (min, max) = text.boundingBox
        let textWidth = CGFloat(max.x - min.x)
        textNode.position = SCNVector3(-Float(textWidth) * 0.001, -0.01, 0.001)
        
        // Create container node
        let containerNode = SCNNode()
        containerNode.addChildNode(backgroundNode)
        containerNode.addChildNode(textNode)
        containerNode.position = position
        
        // Add billboard constraint to always face camera
        let billboardConstraint = SCNBillboardConstraint()
        containerNode.constraints = [billboardConstraint]
        
        // Store reference to container node
        distanceNode = containerNode
        
        return containerNode
    }
    
    private func addLines(_ firstPoint: SCNNode, _ secondPoint: SCNNode) {
        line.removeFromParentNode()
        
        let vertices: [SCNVector3] = [
            SCNVector3(firstPoint.position.x, firstPoint.position.y, firstPoint.position.z),
            SCNVector3(secondPoint.position.x, secondPoint.position.y, secondPoint.position.z)
        ]
        
        let linesGeometry = SCNGeometry(
            sources: [SCNGeometrySource(vertices: vertices)],
            elements: [SCNGeometryElement(indices: [Int32]([0, 1]), primitiveType: .line)]
        )
        
        line = SCNNode(geometry: linesGeometry)
        sceneView.scene.rootNode.addChildNode(line)
    }
    
    // MARK: - Actions
    @objc private func doneButtonTapped() {
        onMeasurementComplete?(currentMeasurement)
        dismiss(animated: true)
    }
}
