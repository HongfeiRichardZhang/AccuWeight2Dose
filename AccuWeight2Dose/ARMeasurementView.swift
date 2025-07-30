import SwiftUI

struct ARMeasurementView: UIViewControllerRepresentable {
    @Binding var height: String
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> ARMeasurementViewController {
        let viewController = ARMeasurementViewController()
        viewController.onMeasurementComplete = { measurement in
            height = String(format: "%.1f", measurement)
        }
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ARMeasurementViewController, context: Context) {}
}
