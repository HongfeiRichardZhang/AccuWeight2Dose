import SwiftUI

struct MedicationCategory: Identifiable {
    let id = UUID()
    let name: String
    let items: [MedicationItem]
}

struct MedicationItem: Identifiable {
    let id = UUID()
    let name: String
    let dosageKey: String
}

struct MedicationsView: View {
    @Environment(\.dismiss) private var dismiss
    let height: Double
    let weight: String
    let weightColor: Color
    let bodyType: BodyType
    @State private var searchText = ""
    @State private var expandedSections: Set<String> = []
    
    private let categories = [
        MedicationCategory(name: "Airway Equipment", items: [
            MedicationItem(name: "Miller Blade", dosageKey: "Miller_Blade"),
            MedicationItem(name: "Mac Blade", dosageKey: "Mac_Blade"),
            MedicationItem(name: "Airtraq", dosageKey: "Airtraq"),
            MedicationItem(name: "VividTrac", dosageKey: "VividTrac"),
            MedicationItem(name: "Endotracheal Tube Cuffed", dosageKey: "Endotracheal_Tube_Cuffed"),
            MedicationItem(name: "LMA", dosageKey: "LMA"),
            MedicationItem(name: "King Tube", dosageKey: "KingTube"),
            MedicationItem(name: "iGel", dosageKey: "iGel")
        ]),
        MedicationCategory(name: "Airway Emergency", items: [
            MedicationItem(name: "Etomidate IV/IO", dosageKey: "Etomidate_IV_IO"),
            MedicationItem(name: "Ketamine IV/IO", dosageKey: "Ketamine_IV_IO"),
            MedicationItem(name: "Succinylcholine IV/IO", dosageKey: "Succinylcholine_IV_IO"),
            MedicationItem(name: "Rocuronium IV/IO", dosageKey: "Rocuronium_IV_IO"),
            MedicationItem(name: "Fentanyl IV/IO", dosageKey: "Fentanyl_IV_IO"),
            MedicationItem(name: "Midazolam IV/IO", dosageKey: "Midazolam_IV_IO"),
            MedicationItem(name: "Lorazepam IV/IO", dosageKey: "Lorazepam_IV_IO")
        ]),
        MedicationCategory(name: "Cardiac Arrest", items: [
            MedicationItem(name: "First Shock", dosageKey: "shock_1st"),
            MedicationItem(name: "Second Shock", dosageKey: "shock_2nd"),
            MedicationItem(name: "Third Shock", dosageKey: "shock_3rd"),
            MedicationItem(name: "Epinephrine 1mg/10mL IV", dosageKey: "Epinephrine_1mg_10mL_IV"),
            MedicationItem(name: "Atropine IV/IO/ETT", dosageKey: "Atropine_IV_IO_ETT"),
            MedicationItem(name: "Magnesium Sulfate IV", dosageKey: "Magnesium_sulfate_IV"),
            MedicationItem(name: "Epinephrine 1mg/1mL ETT", dosageKey: "Epinephrine_1mg_1mL_ETT"),
            MedicationItem(name: "Amiodarone IV", dosageKey: "Amiodarone_IV"),
            MedicationItem(name: "Lidocaine IV", dosageKey: "Lidocaine_IV")
        ]),
        MedicationCategory(name: "Pressors", items: [
            MedicationItem(name: "Epinephrine/Norepinephrine Initial", dosageKey: "Epinephrine_Norepinephrine_gtt_IV_init_dos"),
            MedicationItem(name: "Epinephrine/Norepinephrine Max", dosageKey: "Epinephrine_Norepinephrine_gtt_IV_max_dos")
        ]),
        MedicationCategory(name: "Anaphylaxis", items: [
            MedicationItem(name: "Epinephrine 1mg/1mL IM", dosageKey: "Epinephrine_1mg_1mL_IM"),
            MedicationItem(name: "Diphenhydramine IV/IM", dosageKey: "Diphenhydramine_IV_IM"),
            MedicationItem(name: "Famotidine IV", dosageKey: "Famotidine_IV"),
            MedicationItem(name: "Methylprednisolone IV", dosageKey: "Methylprednisolone_IV")
        ]),
        MedicationCategory(name: "Pain", items: [
            MedicationItem(name: "Fentanyl IN", dosageKey: "Fentanyl_IN"),
            MedicationItem(name: "Fentanyl IV", dosageKey: "Fentanyl_IV"),
            MedicationItem(name: "Ketorolac IV", dosageKey: "Ketorolac_IV"),
            MedicationItem(name: "Tylenol PO", dosageKey: "Tylenol_PO"),
            MedicationItem(name: "Ibuprofen PO", dosageKey: "Ibuprofen_PO")
        ]),
        MedicationCategory(name: "Seizure", items: [
            MedicationItem(name: "Midazolam IN", dosageKey: "Midazolam_IN"),
            MedicationItem(name: "Midazolam IV", dosageKey: "Midazolam_IV"),
            MedicationItem(name: "Lorazepam IV", dosageKey: "Lorazepam_IV"),
            MedicationItem(name: "D10 IV", dosageKey: "D10_IV")
        ])
    ]
    
    var filteredCategories: [MedicationCategory] {
        if searchText.isEmpty {
            return categories
        }
        
        return categories.map { category in
            let filteredItems = category.items.filter { item in
                item.name.lowercased().contains(searchText.lowercased())
            }
            return MedicationCategory(name: category.name, items: filteredItems)
        }.filter { !$0.items.isEmpty }
    }
    
    var filteredItems: [MedicationItem] {
        if searchText.isEmpty {
            return []
        }
        return categories.flatMap { $0.items }.filter { item in
            item.name.lowercased().contains(searchText.lowercased())
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Weight Display
            VStack(spacing: 4) {
                HStack {
                    Text("Weight:")
                        .foregroundColor(.black)
                        .font(.system(size: 17))
                    Text("\(weight) kg")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(weightColor)
                        )
                }
                
                if bodyType != .normal {
                    Text("(\(bodyType.rawValue) body type)")
                        .font(.system(size: 13))
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            
            // Search Bar
            TextField("Search medications...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.white)
            
            // Medication List
            ScrollView {
                VStack(spacing: 0) {
                    if searchText.isEmpty {
                        // Show categories when not searching
                        ForEach(filteredCategories) { category in
                            VStack(spacing: 0) {
                                // Category Header
                                Button(action: {
                                    if expandedSections.contains(category.name) {
                                        expandedSections.remove(category.name)
                                    } else {
                                        expandedSections.insert(category.name)
                                    }
                                }) {
                                    HStack {
                                        Text(category.name)
                                            .foregroundColor(.blue)
                                            .font(.headline)
                                        Spacer()
                                        Image(systemName: expandedSections.contains(category.name) ? "chevron.down" : "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .background(Color.white)
                                }
                                
                                // Category Items
                                if expandedSections.contains(category.name) {
                                    VStack(spacing: 0) {
                                        ForEach(category.items) { item in
                                            medicationItemView(item)
                                        }
                                    }
                                }
                                Divider()
                            }
                        }
                    } else {
                        // Show only filtered items when searching
                        ForEach(filteredItems) { item in
                            medicationItemView(item)
                        }
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Medications")
    }
    
    struct DosageDetailView: View {
        let medicationName: String
        let weight: String
        let weightColor: Color
        let height: Double
        let dosageKey: String
        
        var body: some View {
            let weightValue = Double(weight) ?? 0
            let dosageDetails = DosageData.getDosageDetails(weightValue, itemName: dosageKey)
            
            VStack(alignment: .leading, spacing: 8) {
                // Weight display
                HStack {
                    Text("Wt:")
                        .font(.system(size: 16, weight: .medium))
                    Text("\(weight) Kg")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(weightColor)
                        )
                }
                .padding(.bottom, 4)
                
                // Medication name
                Text(medicationName)
                    .font(.system(size: 18, weight: .bold))
                    .padding(.bottom, 4)
                
                // Concentration (if available)
                if !dosageDetails.concentration.isEmpty {
                    HStack {
                        Text("Concentration:")
                            .font(.system(size: 16, weight: .medium))
                        Text(dosageDetails.concentration)
                            .font(.system(size: 16))
                    }
                    .padding(.bottom, 2)
                }
                
                // Dose
                if !dosageDetails.dose.isEmpty {
                    HStack {
                        Text("Dose:")
                            .font(.system(size: 16, weight: .medium))
                        Text(dosageDetails.dose)
                            .font(.system(size: 16))
                    }
                    .padding(.bottom, 2)
                }
                
                // Volume
                if !dosageDetails.volume.isEmpty {
                    HStack {
                        Text("Volume:")
                            .font(.system(size: 16, weight: .medium))
                        Text(dosageDetails.volume)
                            .font(.system(size: 16))
                    }
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
        }
    }
    
    @ViewBuilder
    private func medicationItemView(_ item: MedicationItem) -> some View {
        DosageDetailView(
            medicationName: item.name,
            weight: weight,
            weightColor: weightColor,
            height: height,
            dosageKey: item.dosageKey
        )
    }
}

struct MedicationsView_Previews: PreviewProvider {
    static var previews: some View {
        MedicationsView(height: 50.0, weight: "6", weightColor: .blue, bodyType: .normal)
    }
}
