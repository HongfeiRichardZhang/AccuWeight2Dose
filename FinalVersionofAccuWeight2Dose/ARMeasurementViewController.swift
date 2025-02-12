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
        label.text = "Tap to set start point, then tap again to measure height"
        label.textAlignment = .center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        label.textColor = .white
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.numberOfLines = 0
        return label
    }()
    
    private var dots = [SCNNode]()
    private var distanceTextNode = SCNNode()
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
        if dots.count >= 2 {
            for dot in dots {
                dot.removeFromParentNode()
            }
            dots = []
            line.removeFromParentNode()
            distanceTextNode.removeFromParentNode()
        }
        
        if let touch = touches.first {
            let location = touch.location(in: sceneView)
            let results = sceneView.hitTest(location, types: .featurePoint)
            if let result = results.first {
                addDot(at: result)
            }
        }
    }
    
    // MARK: - Measurement Functions
    private func addDot(at location: ARHitTestResult) {
        let dot = SCNSphere(radius: 0.007)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        dot.materials = [material]
        let node = SCNNode(geometry: dot)
        
        node.position = SCNVector3(
            x: location.worldTransform.columns.3.x,
            y: location.worldTransform.columns.3.y,
            z: location.worldTransform.columns.3.z
        )
        
        sceneView.scene.rootNode.addChildNode(node)
        dots.append(node)
        
        if dots.count >= 2 {
            calculate()
        }
    }
    
    private func calculate() {
        let firstPoint = dots[0]
        let secondPoint = dots[1]
        let distance = sqrt(
            pow((secondPoint.position.x - firstPoint.position.x), 2) +
            pow((secondPoint.position.y - firstPoint.position.y), 2) +
            pow((secondPoint.position.z - firstPoint.position.z), 2)
        )
        
        currentMeasurement = round(abs(distance * 100) * 10) / 10
        printTextOnScreen(distance: String(format: "%.1f", currentMeasurement), position: secondPoint.position)
        addLines(firstPoint, secondPoint)
        
        instructionLabel.text = "Measurement complete! Tap to measure again or press Done to save"
        doneButton.isHidden = false
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
    
    private func printTextOnScreen(distance: String, position: SCNVector3) {
        distanceTextNode.removeFromParentNode()
        let distanceText = SCNText(string: "\(distance)cm", extrusionDepth: 1.0)
        distanceText.firstMaterial?.diffuse.contents = UIColor.blue
        distanceTextNode = SCNNode(geometry: distanceText)
        distanceTextNode.position = SCNVector3(position.x, position.y + 0.05, position.z)
        distanceTextNode.scale = SCNVector3(0.01, 0.01, 0.01)
        sceneView.scene.rootNode.addChildNode(distanceTextNode)
    }
    
    // MARK: - Actions
    @objc private func doneButtonTapped() {
        onMeasurementComplete?(currentMeasurement)
        dismiss(animated: true)
    }
}
