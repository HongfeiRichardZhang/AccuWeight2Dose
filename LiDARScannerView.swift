import SwiftUI
import Combine

// A SwiftUI wrapper that presents the LiDAR scanning experience from the
// `lidar-scanning-app-main` project and notifies the parent view of the
// measured weight (in kilograms).
//
// The scanning view itself is the `ContentView` that already exists inside the
// `LiDARScanningApp` target.  We simply embed that view and listen for the
// custom `lidarWeightMeasured` notification that is posted by
// `Coordinator.saveCurrentScan()` when the user taps *Save* in the scanner.
//
// Usage:
// ````swift
// LiDARScannerView { kg in
//     weight = String(format: "%.2f", kg)
//     selectedWeightUnit = "kg"
// }
// ````
struct LiDARScannerView: View {
    /// Callback invoked when the scanner finishes and returns a weight value.
    var onWeightMeasured: (Double) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var cancellable: AnyCancellable?

    var body: some View {
        // NOTE: `LiDARScanningApp.ContentView` is the main entry point of the
        // scanner project.  Because both projects live in the same workspace
        // the Swift compiler will be able to find the symbol.  If you renamed
        // the scanner's ContentView make sure the symbol below matches.
        LiDARScanningRootView()
            .ignoresSafeArea() // Run full-screen just like the AR view
            .onAppear {
                // Listen for the notification that carries the measured weight
                // so we can forward it to the host app and then dismiss.
                cancellable = NotificationCenter.default
                    .publisher(for: .lidarWeightMeasured)
                    .compactMap { $0.object as? Double }
                    .sink { weight in
                        onWeightMeasured(weight)
                        dismiss()
                    }
            }
            .onDisappear {
                cancellable?.cancel()
            }
    }
}

// MARK: - Helper Root View

/// A thin wrapper around the scanner's root view so we do not clash with the
/// `ContentView` that already exists in *AccuWeight2Dose*.
private struct LiDARScanningRootView: View {
    var body: some View {
        // This comes from the *LiDARScanningApp* target.
        ContentView()
    }
}

// MARK: - Notification Name Helper

extension Notification.Name {
    /// Posted by the LiDAR scanner once the user saves a scan and the
    /// calculated mass (in kg) is available.
    static let lidarWeightMeasured = Notification.Name("lidarWeightMeasured")
}
