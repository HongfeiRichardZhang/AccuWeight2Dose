//
//  ContentView.swift
//  FinalVersionofAccuWeight2Dose
//
//  Created by Richard on 2/6/25.
//

import SwiftUI

struct ContentView: View {
    @State private var weight: String = ""
    @State private var height: String = ""
    @State private var selectedWeightUnit: String = "kg"
    @State private var selectedHeightUnit: String = "cm"
    @State private var showMedications = false
    @State private var showARMeasurement = false
    
    // 存储最初的输入字符串
    @State private var initialWeightInput: String = ""
    @State private var initialHeightInput: String = ""
    
    // 存储原始输入值和单位
    @State private var originalWeight: Double = 0.0
    @State private var originalHeight: Double = 0.0
    @State private var originalWeightUnit: String = "kg"
    @State private var originalHeightUnit: String = "cm"
    
    let weightUnits = ["kg", "lb"]
    let heightUnits = ["cm", "in"]
    
    // 单位转换常量
    private let kgToLb: Double = 2.20462
    private let lbToKg: Double = 0.453592
    private let cmToIn: Double = 0.393701
    private let inToCm: Double = 2.54
    
    // 身高体重对应数据
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
    
    // 计算预测体重和范围
    private func calculateWeightRange(height: Double) -> (weight: Int, range: String, color: Color)? {
        guard let data = heightWeightData.first(where: { $0.heightMin <= height && height <= $0.heightMax }) else {
            return nil
        }
        return (data.weight, String(format: "%.1f-%.1f cm", data.heightMin, data.heightMax), data.color)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("AccuWeight2Dose")
                        .font(.system(size: 32, weight: .bold))
                        .padding(.top, 10)
                        .padding(.bottom, 25)
                    
                    VStack(alignment: .leading, spacing: 25) {
                        Text("Body Data")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.bottom, 5)
                        
                        VStack(alignment: .leading, spacing: 25) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Weight (recommended):")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 17))
                                
                                HStack(spacing: 12) {
                                    TextField("Enter weight", text: $weight)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .keyboardType(.decimalPad)
                                        .frame(maxWidth: .infinity)
                                        .font(.system(size: 17))
                                        .onChange(of: weight) { newValue in
                                            if let value = Double(newValue) {
                                                if initialWeightInput.isEmpty {
                                                    initialWeightInput = newValue
                                                }
                                                originalWeight = value
                                                originalWeightUnit = selectedWeightUnit
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
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Height:")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 17))
                                
                                HStack(spacing: 12) {
                                    TextField("Enter height", text: $height)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .keyboardType(.decimalPad)
                                        .frame(maxWidth: .infinity)
                                        .font(.system(size: 17))
                                        .onChange(of: height) { newValue in
                                            if let value = Double(newValue) {
                                                if initialHeightInput.isEmpty {
                                                    initialHeightInput = newValue
                                                }
                                                originalHeight = value
                                                originalHeightUnit = selectedHeightUnit
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
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                                .frame(maxWidth: .infinity, minHeight: 90)
                            
                            if let heightValue = Double(height) {
                                let cmHeight = selectedHeightUnit == "in" ? heightValue * inToCm : heightValue
                                if let (predictedWeight, heightRange, textColor) = calculateWeightRange(height: cmHeight) {
                                    VStack(spacing: 8) {
                                        Text("\(predictedWeight) kg")
                                            .font(.system(size: 32, weight: .bold))
                                            .foregroundColor(textColor)
                                        Text("Height range: \(heightRange)")
                                            .font(.system(size: 15))
                                            .foregroundColor(.gray)
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
                                    .frame(maxWidth: .infinity, minHeight: 90)
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
                                .frame(maxWidth: .infinity, minHeight: 90)
                            }
                        }
                    }
                    .padding(20)
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(radius: 1)
                    .padding(.horizontal)
                    
                    Spacer(minLength: 50)
                    
                    Button(action: {
                        showMedications = true
                    }) {
                        Text("Go to Medication")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background((!weight.isEmpty || !height.isEmpty) ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .font(.system(size: 17, weight: .semibold))
                    }
                    .disabled(weight.isEmpty && height.isEmpty)
                    .padding(.horizontal)
                    .padding(.bottom, 30)
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
                let (currentWeight, weightColor) = getCurrentWeight()
                let heightValue = Double(height) ?? 0.0
                MedicationsView(height: heightValue, weight: currentWeight, weightColor: weightColor)
            }
            .fullScreenCover(isPresented: $showARMeasurement) {
                ARMeasurementView(height: $height)
            }
        }
    }
    
    // 获取当前使用的体重值和颜色
    private func getCurrentWeight() -> (String, Color) {
        if !weight.isEmpty {
            // 如果输入了体重，直接使用输入的体重
            let weightValue = selectedWeightUnit == "kg" ? weight : String(format: "%.1f", (Double(weight) ?? 0) * lbToKg)
            return (weightValue, .black)  // 使用黑色表示用户输入的体重
        } else if !height.isEmpty, let heightValue = Double(height) {
            // 如果只输入了身高，使用预测的体重
            let cmHeight = selectedHeightUnit == "in" ? heightValue * inToCm : heightValue
            if let (predictedWeight, _, textColor) = calculateWeightRange(height: cmHeight) {
                return (String(predictedWeight), textColor)
            }
        }
        return ("0", .black)  // 默认返回值
    }
    
    // 重量单位转换函数
    private func convertWeight(to newUnit: String) {
        guard originalWeight != 0 else { return }
        
        if originalWeightUnit == "kg" && newUnit == "lb" {
            weight = String(format: "%.1f", originalWeight * kgToLb)
        } else if originalWeightUnit == "lb" && newUnit == "kg" {
            weight = String(format: "%.1f", originalWeight * lbToKg)
        }
    }
    
    // 身高单位转换函数
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
