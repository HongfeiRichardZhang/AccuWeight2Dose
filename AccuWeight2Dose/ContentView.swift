//
//  ContentView.swift
//  FinalVersionofAccuWeight2Dose
//
//  Created by Richard on 2/6/25.
//

import SwiftUI
import Combine
import ARKit
import MetalKit

struct ContentView: View {
    @State private var weight: String = ""
    @State private var height: String = ""
    @State private var selectedWeightUnit: String = "kg"
    @State private var selectedHeightUnit: String = "cm"
    @State private var selectedBodyType: BodyType = .normal
    @State private var showMedications = false
    @State private var showARMeasurement = false
    @State private var showLiDARScanner = false
    
    private let dosageData = DosageData.dosageMap
    
    @State private var weightError: String = ""
    @State private var heightError: String = ""
    
    @State private var initialWeightInput: String = ""
    @State private var initialHeightInput: String = ""
    
    @State private var originalWeight: Double = 0.0
    @State private var originalHeight: Double = 0.0
    @State private var originalWeightUnit: String = "kg"
    @State private var originalHeightUnit: String = "cm"
    
    let weightUnits = ["kg", "lb"]
    let heightUnits = ["cm", "in"]
    
    // Unit conversion constants
    private let kgToLb: Double = 2.20462
    private let lbToKg: Double = 0.453592
    private let cmToIn: Double = 0.393701
    private let inToCm: Double = 2.54
    
    // Verification scope
    private let validWeightRangeKg = 3.0...200.0
    private let validHeightRangeCm = 41.4...149.1
    
    // Height and weight corresponding data
    private let heightWeightData: [(heightMin: Double, heightMax: Double, weight: Int, color: Color)] = [
        (41.4, 47.2, 3, .gray),
        (47.2, 53.3, 4, .gray),
        (53.3, 58.8, 5, .gray),
        (58.8, 63.7, 6, .pink),
        (63.7, 68.3, 7, .pink),
        (68.3, 72.6, 8, .red),
        (72.6, 76.6, 9, .red),
        (76.6, 80.4, 10, .purple),
        (80.4, 84.1, 11, .purple),
        (84.1, 87.5, 12, .yellow),
        (87.5, 90.9, 13, .yellow),
        (90.9, 94.0, 14, .yellow),
        (94.0, 97.1, 15, .white),
        (97.1, 100.1, 16, .white),
        (100.1, 103.0, 17, .white),
        (103.0, 105.8, 18, .white),
        (105.8, 108.6, 19, .blue),
        (108.6, 111.2, 20, .blue),
        (111.2, 113.8, 21, .blue),
        (113.8, 116.4, 22, .blue),
        (116.4, 118.9, 23, .blue),
        (118.9, 121.2, 24, .orange),
        (121.2, 123.6, 25, .orange),
        (123.6, 126.0, 26, .orange),
        (126.0, 128.3, 27, .orange),
        (128.3, 130.5, 28, .orange),
        (130.5, 132.7, 29, .orange),
        (132.7, 134.8, 30, .green),
        (134.8, 137.0, 31, .green),
        (137.0, 139.0, 32, .green),
        (139.0, 141.1, 33, .green),
        (141.1, 143.2, 34, .green),
        (143.2, 145.1, 35, .green),
        (145.1, 147.2, 36, .green),
        (147.2, 149.1, 37, .green)
    ]
    
    // 根据身高计算体重范围
    private func calculateWeightRange(height: Double) -> (Int, String, Color)? {
        for (index, range) in heightWeightData.enumerated() {
            if height >= range.heightMin && height < range.heightMax {
                let baseWeight = range.weight
                let adjustedWeight = Int(Double(baseWeight) * selectedBodyType.weightMultiplier)
                let heightRange = String(format: "%.1f-%.1f cm", range.heightMin, range.heightMax)
                return (adjustedWeight, heightRange, getColorForWeight(Double(adjustedWeight)))
            }
        }
        return nil
    }
    
    private var isInputValid: Bool {
        if !weight.isEmpty {
            if let weightValue = Double(weight) {
                let weightInKg = selectedWeightUnit == "kg" ? weightValue : weightValue * lbToKg
                if weightInKg < validWeightRangeKg.lowerBound {
                    weightError = selectedWeightUnit == "kg" ? 
                        "Weight must be at least \(String(format: "%.1f", validWeightRangeKg.lowerBound)) kg" :
                        "Weight must be at least \(String(format: "%.1f", validWeightRangeKg.lowerBound * kgToLb)) lb"
                    return false
                }
                weightError = ""
                return true
            }
            return false
        }
        
        if !height.isEmpty {
            if let heightValue = Double(height) {
                let heightInCm = selectedHeightUnit == "in" ? heightValue * inToCm : heightValue
                if heightInCm < validHeightRangeCm.lowerBound || heightInCm > validHeightRangeCm.upperBound {
                    heightError = selectedHeightUnit == "cm" ?
                        "Height must be between \(String(format: "%.1f", validHeightRangeCm.lowerBound))-\(String(format: "%.1f", validHeightRangeCm.upperBound)) cm" :
                        "Height must be between \(String(format: "%.1f", validHeightRangeCm.lowerBound * cmToIn))-\(String(format: "%.1f", validHeightRangeCm.upperBound * cmToIn)) in"
                    return false
                }
                heightError = ""
                return true
            }
            return false
        }
        
        return false
    }
    
    var body: some View {
        NavigationStack {
            VStack {  
                VStack(spacing: 8) {
                    Text("@AccuWeight2Dose")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 10)

                    // Body Data Card
                    VStack(alignment: .leading, spacing: 15) {  
                        Text("Body Data")
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 2)  
                        
                        VStack(alignment: .leading, spacing: 15) {  
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Weight (recommended):")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 17))
                                
                                Text("(Range: 3 kg / 6.6 lb and above)")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 12))
                                
                                HStack {
                                    ZStack(alignment: .trailing) {
                                        TextField("Enter weight", text: $weight)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .keyboardType(.decimalPad)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 4)
                                                    .stroke(weightError.isEmpty ? Color.clear : Color.red, lineWidth: 1)
                                            )
                                            .onChange(of: weight) { newValue in
                                                if let value = Double(newValue) {
                                                    if initialWeightInput.isEmpty {
                                                        initialWeightInput = newValue
                                                    }
                                                    originalWeight = value
                                                    originalWeightUnit = selectedWeightUnit
                                                }
                                            }
                                        
                                        if !weight.isEmpty {
                                            Button(action: {
                                                weight = ""
                                                weightError = ""
                                                initialWeightInput = ""
                                                originalWeight = 0.0
                                                originalWeightUnit = selectedWeightUnit
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(.gray)
                                                    .padding(.trailing, 8)
                                            }
                                        }
                                    }
                                    
                                    Picker("Weight Unit", selection: $selectedWeightUnit) {
                                        ForEach(weightUnits, id: \.self) { unit in
                                            Text(unit).tag(unit)
                                        }
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                    .frame(width: 100)
                                    .onChange(of: selectedWeightUnit) { newUnit in
                                        if originalWeightUnit == newUnit {
                                            weight = initialWeightInput
                                        } else {
                                            convertWeight(to: newUnit)
                                        }
                                    }
                                }
                                
                                if !weightError.isEmpty {
                                    Text(weightError)
                                        .foregroundColor(.red)
                                        .font(.system(size: 12))
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Height:")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 17))
                                
                                Text("(Range: 41.4-149.1 cm or 16.3-58.8 in)")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 12))
                                
                                HStack {
                                    ZStack(alignment: .trailing) {
                                        TextField("Enter height", text: $height)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .keyboardType(.decimalPad)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 4)
                                                    .stroke(heightError.isEmpty ? Color.clear : Color.red, lineWidth: 1)
                                            )
                                            .onChange(of: height) { newValue in
                                                if let value = Double(newValue) {
                                                    if initialHeightInput.isEmpty {
                                                        initialHeightInput = newValue
                                                    }
                                                    originalHeight = value
                                                    originalHeightUnit = selectedHeightUnit
                                                }
                                            }
                                        
                                        if !height.isEmpty {
                                            Button(action: {
                                                height = ""
                                                heightError = ""
                                                initialHeightInput = ""
                                                originalHeight = 0.0
                                                originalHeightUnit = selectedHeightUnit
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(.gray)
                                                    .padding(.trailing, 8)
                                            }
                                        }
                                    }
                                    
                                    Picker("Height Unit", selection: $selectedHeightUnit) {
                                        ForEach(heightUnits, id: \.self) { unit in
                                            Text(unit).tag(unit)
                                        }
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                    .frame(width: 100)
                                    .onChange(of: selectedHeightUnit) { newUnit in
                                        if originalHeightUnit == newUnit {
                                            height = initialHeightInput
                                        } else {
                                            convertHeight(to: newUnit)
                                        }
                                    }
                                }
                                
                                if !heightError.isEmpty {
                                    Text(heightError)
                                        .foregroundColor(.red)
                                        .font(.system(size: 12))
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Body Type:")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 17))
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        ForEach([BodyType.slim, .lean, .normal, .chubby, .overweight], id: \.self) { bodyType in
                                            BodyTypeButton(bodyType: bodyType, isSelected: selectedBodyType == bodyType) {
                                                selectedBodyType = bodyType
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 4)
                                }
                            }
                        }
                        
                        Button(action: {
                            showARMeasurement = true
                        }) {
                            Text("AR Measure")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(12)
                                .font(.system(size: 17, weight: .medium))
                        }
                        .padding(.top, 5)
                        
                        Button(action: {
                            // Try opening the LiDAR app using the URL Scheme
                            if let url = URL(string: "lidarscanner://scan") {
                                UIApplication.shared.open(url, options: [:]) { success in
                                    if !success {
                                        
                                        showLiDARScanner = true
                                    }
                                }
                            } else {
                                showLiDARScanner = true
                            }
                        }) {
                            Text("LiDAR Measure")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(12)
                                .font(.system(size: 17, weight: .medium))
                        }
                        .padding(.top, 0)
                    }
                    .padding(20)
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(radius: 1)
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Weight Calculation Results")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.bottom, 5)
                            .padding(.top, -10)
                        
                        ZStack {
                            Rectangle()
                                .fill(Color(.systemGray6))
                                .frame(maxWidth: .infinity, minHeight: 110)
                            
                            if !weight.isEmpty, let weightValue = Double(weight) {
                                let textColor = getColorForWeight(weightValue)
                                VStack(spacing: 8) {
                                    Text("\(String(format: "%.0f", weightValue)) kg")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(textColor)
                                    Text("Measured via LiDAR")
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity, minHeight: 90)
                            } else if !height.isEmpty, let heightValue = Double(height) {
                                let cmHeight = selectedHeightUnit == "in" ? heightValue * inToCm : heightValue
                                if let (predictedWeight, heightRange, textColor) = calculateWeightRange(height: cmHeight) {
                                    let adjustedWeight = Double(predictedWeight)
                                    VStack(spacing: 8) {
                                        Text("\(String(format: "%.0f", adjustedWeight)) kg")
                                            .font(.system(size: 32, weight: .bold))
                                            .foregroundColor(textColor)
                                        Text("Height range: \(heightRange)")
                                            .font(.system(size: 15))
                                            .foregroundColor(.gray)
                                        Text(selectedBodyType != .normal ? "Adjusted for \(selectedBodyType.rawValue) body type" : " ")
                                            .font(.system(size: 13))
                                            .foregroundColor(.blue)
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 90)
                                } else {
                                    VStack(spacing: 6) {
                                        Text("Height out of valid range")
                                            .font(.system(size: 15))
                                            .foregroundColor(.gray)
                                        Text("Valid measurement range: 41.4-149.1 cm")
                                            .font(.system(size: 13))
                                            .foregroundColor(.gray)
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 110)
                                }
                            } else {
                                VStack(spacing: 6) {
                                    Text("Enter height to see estimated weight")
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray)
                                    Text("Valid measurement range: 41.4-149.1 cm")
                                        .font(.system(size: 13))
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity, minHeight: 110)
                            }
                        }
                    }
                    .padding(20)
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(radius: 1)
                    .padding(.horizontal)
                    
                    Button(action: {
                        showMedications = true
                    }) {
                        Text("Go to Medication")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(!isInputValid ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .font(.system(size: 17, weight: .semibold))
                    }
                    .disabled(!isInputValid)
                    .padding(.top, 0)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                             to: nil, from: nil, for: nil)
            }
            .ignoresSafeArea(.keyboard)
            .background(Color(.systemGroupedBackground))
            .navigationDestination(isPresented: $showMedications) {
                NavigationDestinationView()
            }
            .fullScreenCover(isPresented: $showARMeasurement) {
                ARMeasurementView(height: $height)
            }
            .fullScreenCover(isPresented: $showLiDARScanner) {
                LiDARScannerView { kg in
                    weight = String(format: "%.2f", kg)
                    selectedWeightUnit = "kg"
                }
            }
        }
    }
    
    @ViewBuilder
    private func NavigationDestinationView() -> some View {
        let (weightValue, weightColor) = getCurrentWeight()
        let heightValue = Double(height) ?? 0.0
        MedicationsView(height: heightValue,
                       weight: weightValue,
                       weightColor: weightColor,
                       bodyType: selectedBodyType)
    }
    
    // Get the current weight and color
    private func getCurrentWeight() -> (String, Color) {
        // If weight is entered, directly return the weight and corresponding color
        if !weight.isEmpty, let weightValue = Double(weight) {
            let weightInKg = selectedWeightUnit == "kg" ? weightValue : weightValue * lbToKg
            let color = getColorForWeight(weightInKg)
            return (String(format: "%.0f", weightInKg), color)
        }
        
        // If weight is not available but height is available, use height to calculate
        if !height.isEmpty, let heightValue = Double(height) {
            let heightInCm = selectedHeightUnit == "cm" ? heightValue : heightValue * inToCm
            if let (predictedWeight, _, color) = calculateWeightRange(height: heightInCm) {
                let adjustedWeight = Double(predictedWeight)
                return (String(format: "%.0f", adjustedWeight), color)
            }
        }
        
        return ("0", .gray)
    }
    
    // Get the corresponding color according to weight
    private func getColorForWeight(_ weightInKg: Double) -> Color {
        switch weightInKg {
        case 3...5:
            return .gray
        case 6...7:
            return .pink
        case 8...9:
            return .red
        case 10...11:
            return .purple
        case 12...14:
            return .yellow
        case 15...18:
            return .white
        case 19...23:
            return .blue
        case 24...29:
            return .orange
        case 30...36:
            return .green
        case 37...45:
            return .green
        case 46...55:
            return .blue
        case 56...65:
            return .orange
        case 66...:
            return .blue
        default:
            return .gray
        }
    }
    
    // Get the dosage data corresponding to body weight
    private func getDosageColor() -> String {
        guard let weightValue = Double(weight) else { return "" }
        let weightInKg = selectedWeightUnit == "kg" ? weightValue : weightValue * lbToKg
        
        switch weightInKg {
        case 37...45:
            return "greenDot"
        case 46...55:
            return "blueDot"
        case 56...65:
            return "orangeDot"
        case 66...:
            return "lightBlueDot"
        default:
            return ""
        }
    }
    
    // Weight unit conversion function
    private func convertWeight(to newUnit: String) {
        guard originalWeight != 0 else { return }
        
        if originalWeightUnit == "kg" && newUnit == "lb" {
            weight = String(format: "%.1f", originalWeight * kgToLb)
        } else if originalWeightUnit == "lb" && newUnit == "kg" {
            weight = String(format: "%.1f", originalWeight * lbToKg)
        }
    }
    
    // Height unit conversion function
    private func convertHeight(to newUnit: String) {
        guard originalHeight != 0 else { return }
        
        if originalHeightUnit == "cm" && newUnit == "in" {
            height = String(format: "%.1f", originalHeight * cmToIn)
        } else if originalHeightUnit == "in" && newUnit == "cm" {
            height = String(format: "%.1f", originalHeight * inToCm)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Extract the body button into a separate view component
struct BodyTypeButton: View {
    let bodyType: BodyType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
                
                Image(bodyType.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
            .onTapGesture(perform: action)
            
            Text(bodyType.rawValue)
                .font(.system(size: 12))
                .foregroundColor(isSelected ? .blue : .gray)
        }
    }
}
