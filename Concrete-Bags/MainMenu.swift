//
//  ContentView.swift
//  Concrete-Bags
//
//  Created by Chris Milne on 01/04/2025.
//
import SwiftUI

// Encapsulate all the related data and logic in a single ViewModel.
class ShapeDetailViewModel: ObservableObject {
    @Published var Len: Double = 0.0
    @Published var Width: Double = 0.0
    @Published var Height: Double = 0.0
    @Published var Diameter: Double = 0.0
    @Published var DiameterIn: Double = 0.0
    @Published var Area: Double = 0.0
    @Published var Volume: Double = 0.0
    @Published var Bags20kg: Double = 0.0
    @Published var Bags25kg: Double = 0.0
    @Published var Bags30kg: Double = 0.0
    @Published var selectedMeasurement: String = "Millimetres"
    @Published var note: String = "mm"

    let measurements: [String] = ["Millimetres", "Centimetres", "Metres", "Inches", "Feet"]
    let notation: [String] = ["mm", "cm", "m", "in", "ft"]
 
// Calculate all values when a variable is entered or changed
    func updateValuesShape(shapeSelected: String) {
// Calc area, Vol & Bags
        let valResult = DataHandler.shapeFigs(
            A: Len, B: Width, C: Height,
            D: Diameter, E: DiameterIn,
            F: note, G: shapeSelected
        )
        
        Area = valResult.Area
        Volume = valResult.Volume
        Bags20kg = valResult.Bags20kg
        Bags25kg = valResult.Bags25kg
        Bags30kg = valResult.Bags30kg
    }

// Update the notation if the Measurement changes
    func updateMeasurement(_ newMeasurement: String) {
        if let index = measurements.firstIndex(of: newMeasurement) {
            note = notation[index]
        }
    }
// Reset all input variables
    func resetValues() {
        Len = 0.0
        Width = 0.0
        Height = 0.0
        Diameter = 0.0
        DiameterIn = 0.0
    }
}

// Display diagrams of the shapes
struct MainMenu: View {
    var shapeSmalls: [String] = ["ConcreteSlab", "Round", "Segment", "Open Round"]
    @State private var listView = false
    @State private var resetView = false
    
    var body: some View {
        
        NavigationStack {
            List {
                ForEach(shapeSmalls, id: \.self) { shapeSmall in
                    NavigationLink(destination: shapeSmallDetail(shapeSmall: shapeSmall, shapeSelected: "C")) {
                        shapeSmallRow(shapeSmall: shapeSmall, shapeSelected: "C") }
                    
                } /// ForEach
            } /// List
            .navigationTitle("Concrete Calculator")
            .listStyle(.grouped)
            } /// NavStack
    } /// Body
} /// Struct

// Diaplay an image of the shape that has been picked
struct shapeSmallRow: View {
    var shapeSmall: String
    var shapeSelected: String
    var body: some View {
        HStack {
            Image(shapeSmall)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 70)
            Text(shapeSmall)
                .frame(width: 120, height: 70)
        }
        .contentShape(Rectangle())  // Ensures the row is fully tappable
    }
} /// struct shapeSmallRow

// Take input of the variables
struct shapeSmallDetail: View {
    @Environment(\.dismiss) var dismiss
    let shapeSmall: String
    let shapeSelected: String
 // Using @StateObject prevents unnecessary re-renders when multiple properties change.
    @StateObject private var VM = ShapeDetailViewModel()
    
    var body: some View {
        ZStack {
            Color(red: 0.85, green: 0.95, blue: 0.99)
                .edgesIgnoringSafeArea(.all)  // Cover the entire screen
//MARK: Heading
            VStack {
                Text("Calculate Area, Volume and Bags")
                    .font(.headline)
                
                HStack {
                    Text(shapeSmall).font(.title3)
                    Image(shapeSmall)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                } // HStack
 
                
//MARK: Select Measurement
                HStack {
                    Button {
                    } label: {
                        
                        Picker("Measurement", selection: $VM.selectedMeasurement) {
                            ForEach(VM.measurements, id: \.self) {
                                Text($0).font(.system(size: 18, weight: .bold))
                                //          .edgesIgnoringSafeArea(.all)
                            }/// ForEach
                        }/// Picker
                        .pickerStyle(.segmented)
                        // Use onChange of for Picker
            .onChange(of: VM.selectedMeasurement) {
 VM.updateMeasurement(VM.selectedMeasurement)
                            
                        } // onChange of
                    } // Label
                }     // HStack
                        .padding(20)
                        
//MARK: Concrete Slab
// MARK: Length input
                        if shapeSmall == "ConcreteSlab" {
                            InputField(label: "Length", value: $VM.Len, unit: VM.note)
                                .onChange(of: VM.Len) { VM.updateValuesShape(shapeSelected: "C") }
                            InputField(label: "Width", value: $VM.Width, unit: VM.note)
                                .onChange(of: VM.Width) { VM.updateValuesShape(shapeSelected: "C") }
                            InputField(label: "Height", value: $VM.Height, unit: VM.note)
                                .onChange(of: VM.Height) {
                                    VM.updateValuesShape(shapeSelected: "C") }
                        }
                        
//MARK: ROUND
                        if shapeSmall == "Round" {
                            InputField(label: "Diameter", value: $VM.Diameter, unit: VM.note)
                                .onChange(of: VM.Diameter) { VM.updateValuesShape(shapeSelected: "R") }
                            InputField(label: "Height", value: $VM.Height, unit: VM.note)
                                .onChange(of: VM.Height) { VM.updateValuesShape(shapeSelected: "R") }
                        }
//MARK: Segment
                        if shapeSmall == "Segment" {
                            InputField(label: "Length", value: $VM.Len, unit: VM.note)
                                .onChange(of: VM.Len) {
                                    VM.updateValuesShape(shapeSelected: "S") }
                            InputField(label: "Width", value: $VM.Width, unit: VM.note)
                                .onChange(of: VM.Width) { VM.updateValuesShape(shapeSelected: "S") }
                            InputField(label: "Height", value: $VM.Height, unit: VM.note)
                                .onChange(of: VM.Height) { VM.updateValuesShape(shapeSelected: "S") }
                        }
                
//MARK: Open ROUND
                        if shapeSmall == "Open Round" {
                            InputField(label: " Outer \n Diameter", value: $VM.Diameter, unit: VM.note)
                                .onChange(of: VM.Diameter) { VM.updateValuesShape(shapeSelected: "O") }
                            InputField(label: " Inner \n Diameter", value: $VM.DiameterIn, unit: VM.note)
                                .onChange(of: VM.DiameterIn) { VM.updateValuesShape(shapeSelected: "O") }
                            InputField(label: "Height", value: $VM.Height, unit: VM.note)
                                .onChange(of: VM.Height) { VM.updateValuesShape(shapeSelected: "O") }
                        }
                        
// MARK: Area output
                        
                        if VM.note == "ft" {
                            let ftin = DataHandler.AreafeetToInches(
                                A: VM.Len,
                                B: VM.Width
                            )
                            OutputImpField(label: "Area", ValueFt: ftin.IntFeet,  ValueInch: ftin.IntInches, unit: "in²")
                        } else {
                            OutputDecField(label: "Area", value: VM.Area, unit: VM.note) }
                        
// MARK: Volume output
                        if VM.note == "ft" {
                            let ftin = DataHandler.AreafeetToInches(
                                A: VM.Len,
                                B: VM.Width
                            )
                            OutputImpField(label: "Volume", ValueFt: ftin.IntFeet,  ValueInch: ftin.IntInches, unit: "in²")
                        } else {
                            OutputDecField(label: "Volume", value: VM.Area, unit: VM.note) }
                        
                        
// MARK: Bags Description
                        HStack(spacing: 5) {
                            Text("No of")
                                .frame(width: 100)
                            Text("20kg").frame(width: 100)
                            
                            Text("25kg").frame(width: 100)
                            
                            Text("30kg").frame(width: 100)
                        }/// HStack
                        .frame(height: 50)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .background(.yellow)
// MARK: Bags Value
                        HStack {
                            Text("Bags").frame(width: 100)
                            Text("\(String(format: "%.0f", VM.Bags20kg))").frame(width: 100)
                            Text("\(String(format: "%.0f", VM.Bags25kg))").frame(width: 100)
                            Text("\(String(format: "%.0f", VM.Bags30kg))").frame(width: 100)
                        }
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .background(.orange)
                    }/// VStack
                }
                /// ZStack
                
                Spacer()
                Spacer()
                Spacer()
                // Buttons
                Button(action: { VM.resetValues() }) {
                    Label("Reset all values", systemImage: "eraser")
                        .font(.system(size: 24, weight: .bold))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                
                Button(action: { dismiss() }) {
                    Label("Return", systemImage: "arrowshape.backward.circle.fill")
                        .font(.system(size: 24, weight: .bold))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .navigationBarBackButtonHidden(true)
            }/// Body
            
        } /// Struct
        
        struct InputField: View {
            let label: String
            // Binding required because it's an input variable
            @Binding var value: Double
            let unit: String
            
            var body: some View {
                HStack {
                    Text(label)
                        .frame(minWidth: 100, alignment: .centerLastTextBaseline)
                        .font(.headline)
                    TextField("", value: $value, format: .number)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .background(.orange)
                        .frame(minWidth: 70, alignment: .leading)
                    Text(unit)
                        .frame(minWidth: 100, alignment: .leading)
                        .font(.headline)
                }
                .frame(height: 50)
            }
        }  // Struct
        
        struct OutputDecField: View {
            let label: String
            let value: Double
            let unit: String
            
            var body: some View {
                HStack {
                    Text(label)
                        .frame(minWidth: 100, alignment: .leading)
                        .font(.headline)
                    Text("\(String(format: "%.2f", value)) \(unit)")
                        .frame(minWidth: 250, alignment: .leading)
                        .font(.largeTitle)
                        .background(.orange)
                }
                .frame(height: 50)
            }
        } // Struct
        
        struct OutputImpField: View {
            let label: String
            let ValueFt: Double
            let ValueInch: Double
            let unit: String
            
            var body: some View {
                HStack {
                    Text(label)
                        .frame(minWidth: 100, alignment: .leading)
                        .font(.headline)
                    Text("sq.\(String(format: "%.0f", ValueFt)) ft \(String(format: "%.1f", ValueInch)) in")
                        .frame(minWidth: 250, alignment: .leading)
                        .font(.largeTitle)
                        .background(.orange)
                }
                .frame(height: 50)
            }
        } // 1

#Preview {
    MainMenu()
}

