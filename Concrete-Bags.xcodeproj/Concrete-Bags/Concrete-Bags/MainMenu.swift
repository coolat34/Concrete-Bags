//
//  ContentView.swift
//  Concrete-Bags
//
//  Created by Chris Milne on 01/04/2025.
//
import SwiftUI
import Foundation

// Put all the related data and logic in a single ViewModel. Use @Published in conjunction with ObservableObject and @StateObject
class ShapeDetailViewModel: ObservableObject {
    @Published var Len: Double = 0.0
    @Published var LenB: Double = 0.0
    @Published var Width: Double = 0.0
    @Published var Height: Double = 0.0
    @Published var Diameter: Double = 0.0
    @Published var Diametersmall: Double = 0.0
    @Published var DiameterLarge: Double = 0.0
    @Published var Area: Double = 0.0
    @Published var Volume: Double = 0.0
    @Published var BagsCement20kg: Double = 0.0
    @Published var BagsCement25kg: Double = 0.0
    @Published var BagsCement30kg: Double = 0.0
    @Published var BagsSand20kg: Double = 0.0
    @Published var BagsSand25kg: Double = 0.0
    @Published var BagsSand30kg: Double = 0.0
    @Published var BagsAggregate20kg: Double = 0.0
    @Published var BagsAggregate25kg: Double = 0.0
    @Published var BagsAggregate30kg: Double = 0.0
    @Published var measureSelected: String = "MTR"
    @Published var note: String = "mtr"
    @Published var ratioSelected: String = "Basic"
    @Published var ratioMix: [String] = ["Basic", "Medium", "Strong"]
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    let measurements: [String] = ["MM", "CM", "MTR", "Inches", "Feet"]
    let notationAbr: [String] = ["mm", "cm", "mtr", "in", "ft"]

 //MARK: Update Measurements
    // Update the notationAbr & Bags if the Measurement changes
        func updateMeasurement(_ newMeasurement: String, shapeAbr: String, ratioSelected: String) {
            if let Mindex = measurements.firstIndex(of: newMeasurement) {
                note = notationAbr[Mindex]
                
            }
         reCalcBags(shapeAbr: shapeAbr) // ReCalc Bags
            }
    
// Calculate all values when a variable is entered or changed
    func updateValuesShape(shapeAbr: String) -> Bool {
        // Reset error
        showError = false
        errorMessage = ""
        
        // Basic checks for all shapes
        let allValues = [Len, LenB, Width, Height, Diameter, Diametersmall, DiameterLarge]
        if allValues.contains(where: { $0 < 0 }) {
            showError = true
            errorMessage = "Dimensions must be positive"
            return false
        }
        // Check that small diameters are less than large diameters for OpenRound and Elliptical round
        
        if shapeAbr == "O" || shapeAbr == "E" {
            if DiameterLarge < Diametersmall {
                showError = true
                errorMessage = "Small Diameter must be less than Large Diameter"
                return false
            }
        }
        
        // Checks for Segment (triangle)
        if shapeAbr == "S" && Len > 0 && Width > 0 && LenB > 0 {
            if !isValidTriangle(Len, Width, LenB) {
                showError = true
                errorMessage = "Sides do not form a valid triangle."
                return false
            }
        }
        
        // Check any 2 sides of triangle must be greater than the third side
        func isValidTriangle(_ a: Double, _ b: Double, _ c: Double) -> Bool {
            return a + b > c && a + c > b && b + c > a
        }
// All checks passed
        reCalcBags(shapeAbr: shapeAbr)
        return true }

    func reCalcBags(shapeAbr: String) {
            let valResult = DataHandler.shapeFigs(
                A: Len, B: Width, C: Height,
                D: Diameter, E: Diametersmall,
                F: note, G: shapeAbr, I: DiameterLarge, J: LenB, K: ratioSelected
            )
            
            Area = valResult.Area
            Volume = valResult.Volume
            BagsCement20kg = valResult.BagsCement20kg
            BagsCement25kg = valResult.BagsCement25kg
            BagsCement30kg = valResult.BagsCement30kg
            BagsSand20kg = valResult.BagsSand20kg
            BagsSand25kg = valResult.BagsSand25kg
            BagsSand30kg = valResult.BagsSand30kg
            BagsAggregate20kg = valResult.BagsAggregate20kg
            BagsAggregate25kg = valResult.BagsAggregate25kg
            BagsAggregate30kg = valResult.BagsAggregate30kg
        }

// Reset all input variables
    func resetValues() {
        Len = 0.0
        LenB = 0.0
        Width = 0.0
        Height = 0.0
        Diameter = 0.0
        Diametersmall = 0.0
        DiameterLarge = 0.0
    }

} // Struct

// Loop through all the available shapes in the Assets folder
struct MainMenu: View {
    @State var isShapeList = false

    let xcelFig: String = "Concrete figs"
    var body: some View {

            NavigationStack {
                ZStack {  // Cover the entire screen
                    Color(red: 0.85, green: 0.95, blue: 0.99)
                        .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Calculate concrete volume and mix for common shapes. Choose measurements, select strength, and get bag estimates instantly.")
                        .foregroundColor(Color(.black))
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .padding()
                
                
                    Image(xcelFig)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 200)
                        .padding()
               
                    NavigationLink(destination: ShapeOptions()
                        .navigationBarBackButtonHidden(true)
                    ) {
                        Label("Continue", systemImage: "arrowshape.right.circle.fill")
                            .font(.system(size: 18, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                    .buttonStyle(.borderedProminent)
                    
                } // VStack
                .navigationTitle("Concrete Calculator")
                .navigationBarTitleDisplayMode(.inline)
                .foregroundColor(Color(.black))
                } // ZStack
            } // NavStack

    } // Body
} /// struct

    struct ShapeOptions: View {
        @State private var listView = false
        @State private var resetView = false
    var shapeSmalls: [String] = ["ConcreteSlab", "Round", "Segment", "Open Round", "Half Round", "Elliptical Round"]
        @Environment(\.dismiss) var dismiss
        var body: some View {
            Text("Tap a shape to enter your measurements")
                .fontWidth(.compressed)
                .fontWeight(.bold)
            List {
                ForEach(shapeSmalls, id: \.self) { shapeSmall in
                    
    NavigationLink(destination: shapeSmallDetail(shapeSmall:
                    shapeSmall, shapeAbr:
                    String(shapeSmall.prefix(1)))
        .navigationBarBackButtonHidden(true))
                    {
                   shapeSmallRow(shapeSmall:
               shapeSmall, shapeAbr:String(shapeSmall.prefix(1))
                   )
                    }
                } /// ForEach
            } /// List
            .navigationTitle("Choose Shape")
           .listStyle(.grouped)
            
            Button(action: { dismiss() }) {
                Label("Return", systemImage: "arrowshape.backward.circle.fill")
                    .font(.system(size: 24, weight: .bold))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            } /// Body
    } /// Struct


// Display an image of the shapes to be selected.
struct shapeSmallRow: View {
    var shapeSmall: String
    var shapeAbr: String

    var body: some View {

        HStack {
            Image(shapeSmall)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 45)
            Text(shapeSmall)
                .frame(width: 120, height: 45)
        }
        .contentShape(Rectangle())  // Ensures the row is fully tappable
        
    }
} /// struct shapeSmallRow

// Shape has been selected. Now Take input of the variables
struct shapeSmallDetail: View {
    @Environment(\.dismiss) var dismiss
    let shapeSmall: String
    let shapeAbr: String // Contains 1st char of each shape

 // Using @StateObject prevents unnecessary re-renders when multiple properties change.
    @StateObject var VM = ShapeDetailViewModel()
    @FocusState private var focusedField: Bool // Used to dismiss the Decimal Keypad

var body: some View {
    ZStack {  // Cover the entire screen
        Color(red: 0.85, green: 0.95, blue: 0.99)
            .edgesIgnoringSafeArea(.all)
        
       VStack {
            VStack {
                Text(shapeSmall)
                    .font(.largeTitle)
        Text("Enter measurements (mm,cm,mtrs,inches,feet)")
                    .fontWidth(.compressed)
                  

                Image(shapeSmall)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 120)
            
            } // VStack

  //MARK: Select Measurement
            HStack {
                Button {
                } label: {
                        Picker("Measurement", selection: $VM.measureSelected) {
                            ForEach(VM.measurements, id: \.self) {
                                Text($0)
                                    .foregroundColor(.black)
                            }/// ForEach
                        }/// Picker
                        .pickerStyle(.segmented)
                        .frame(width: 300)
                    // Use onChange of for Picker
                    .onChange(of: VM.measureSelected) {
                        VM.updateMeasurement(VM.measureSelected, shapeAbr: shapeAbr, ratioSelected: VM.ratioSelected)
                        
                    } // onChange of
                } // Label
            }     // HStack

  //MARK: Measurement Input
            if "CS".contains(shapeAbr) {  // Slab or Segment
                InputField(label: "Length A", value: $VM.Len, unit: VM.note)
                    .focused($focusedField)
                    .onChange(of: VM.Len) {
                        if VM.Len < 0 { VM.Len = 0 }
                        updateAndDismissIfValid(shapeAbr) }
                
                InputField(label: "Width", value: $VM.Width, unit: VM.note)
                    .focused($focusedField)
                    .onChange(of: VM.Width) {
                        if VM.Width < 0 { VM.Width = 0 }
                        updateAndDismissIfValid(shapeAbr) }
            } // Concrete & Segment
            
            if "COSHER".contains(shapeAbr) {  // All Shapes
                InputField(label: "Height", value: $VM.Height, unit: VM.note)
                    .focused($focusedField)
                    .onChange(of: VM.Height) {
                        if VM.Height < 0 { VM.Height = 0 }
                        updateAndDismissIfValid(shapeAbr) }
            }
            
            if "S".contains(shapeAbr) {  // Segment
                InputField(label: "Length B", value: $VM.LenB, unit: VM.note)
                    .focused($focusedField)
                    .onChange(of: VM.LenB ) {
                        if VM.LenB < 0 { VM.LenB = 0 }
                        updateAndDismissIfValid(shapeAbr)}
            }
            
            if "RH".contains(shapeAbr) { // Round Half-Round
                InputField(label: "Diameter", value: $VM.Diameter, unit: VM.note)
                    .focused($focusedField)
                    .onChange(of: VM.Diameter) {
                        if VM.Diameter < 0 { VM.Diameter = 0 }
                        updateAndDismissIfValid(shapeAbr) }
            }
            
            
            if "OE".contains(shapeAbr) { // open Round & Elliptical Round
                InputField(label: " Large \n Diameter", value: $VM.DiameterLarge, unit: VM.note)
                    .focused($focusedField)
                    .onChange(of: VM.DiameterLarge) {
                        if VM.DiameterLarge < 0 { VM.DiameterLarge = 0 }
                        updateAndDismissIfValid(shapeAbr) }
                
                InputField(label: " Small \n Diameter", value: $VM.Diametersmall, unit: VM.note)
                    .focused($focusedField)
                    .onChange(of: VM.Diametersmall) {
                        if VM.Diametersmall < 0 { VM.Diametersmall = 0 }
                        updateAndDismissIfValid(shapeAbr) }
            } // IF OE
            Spacer()
// MARK: Area output
            OutputDecField(label: "Area", value: VM.Area, unit: "sq." + VM.note)
                .foregroundColor(.black)
            
            // MARK: Volume output
            OutputDecField(label: "Volume", value: VM.Volume, unit: "cu." + VM.note)
                .foregroundColor(.black)
        } /// VStack
        Spacer()
       .toolbar {
           ToolbarItemGroup(placement: .keyboard) {
               Spacer()
               Button("Done") {
                   focusedField = false
               }
           }
       }

// Display error messages after the last Vstack and before the last ZStack. Ensures that the  rendering takes precedence over the current display
        
        if VM.showError {
            VStack {
                Spacer()
                Text(VM.errorMessage)
                    .padding()
                    .background(Color.red.opacity(0.9))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.bottom, 40)
                    .transition(.move(edge: .bottom))
                    .onAppear {
                        // Hide after 3 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                VM.showError = false
                            }
                        }
                    }
            }
            .zIndex(1) // <<< reinforces that the error view should have a higher stack order, just in case other views have implicit or higher z-indexes.
        }
    } /// ZStack
                
// MARK: Buttons
    VStack {
        NavigationLink(destination: bagFigs(shapeSmall: shapeSmall, shapeAbr: shapeAbr, VM: VM)
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Bag Configuration")
            .navigationBarTitleDisplayMode(.inline)
            .foregroundColor(Color(.black))
        ) {
            Label("See Cement, Sand & Aggregate sizes", systemImage: "arrowshape.right.circle.fill")
                .font(.system(size: 14, weight: .bold))
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        
        Button(action: { VM.resetValues() }) {
            Label("Reset all values", systemImage: "eraser")
                .font(.system(size: 18, weight: .bold))
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        
        Button(action: { dismiss() }) {
            Label("Return", systemImage: "arrowshape.backward.circle.fill")
                .font(.system(size: 18, weight: .bold))
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .navigationBarBackButtonHidden(true)
            Spacer()
    } // VStack
          
}/// Body
    // Function passes any input to be checked and dismisses the Keyboard if OK
    func updateAndDismissIfValid(_ shapeAbr: String) {
        if VM.updateValuesShape(shapeAbr: shapeAbr) {
            focusedField = false
        }
    }
    
        } /// Struct

struct bagFigs: View {
    var shapeSmall: String
    let shapeAbr: String // Contains 1st char of each shape
   @ObservedObject var VM = ShapeDetailViewModel()
    @Environment(\.dismiss) var dismiss
    var body: some View {

            VStack {
                Text(shapeSmall)
                    .font(.largeTitle)
                
                Image(shapeSmall)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 150)
                    
                
            } // VStack
            
            Spacer()
            
            //MARK: Select Mix
            HStack {
                Button {
                } label: {
                    
                    Picker("Mix", selection: $VM.ratioSelected) {
                        ForEach(VM.ratioMix, id: \.self) {
                            //                    Text($0).font(.title)
                            Text($0).font(.system(size: 22, weight: .bold))
                        }/// ForEach
                    }/// Picker
                    .pickerStyle(.segmented)
                    // Use onChange of for Picker
                    .onChange(of: VM.ratioSelected) {
                        VM.updateMeasurement(VM.measureSelected, shapeAbr: shapeAbr, ratioSelected: VM.ratioSelected)
                        
                    } // onChange of
                } // Label
            }     // HStack
            .padding(10)
            // MARK: Bags Description
            
            HStack(spacing: 5) {
                
                Text("Bags").frame(minWidth: 80)
                Text("Cement").frame(minWidth: 80)
                Text("Sand").frame(minWidth: 80)
                Text("Aggregate").frame(minWidth: 80)
           }/// HStack
            .font(.title3)
            .frame(height: 50)
           .foregroundColor(.black)
            .background( Color(red: 0.85, green: 0.95, blue: 0.99))
        
        // MARK: Bags Value
        OutputBagField(label: "20kg", valCem: VM.BagsCement20kg, valSand: VM.BagsSand20kg, valAgg: VM.BagsAggregate20kg)
        OutputBagField(label: "25kg", valCem: VM.BagsCement25kg, valSand: VM.BagsSand25kg, valAgg: VM.BagsAggregate25kg)
        OutputBagField(label: "30kg", valCem: VM.BagsCement30kg, valSand: VM.BagsSand30kg, valAgg: VM.BagsAggregate30kg)
        
 
            Button(action: { dismiss() }) {
                Label("Return", systemImage: "arrowshape.backward.circle.fill")
                    .font(.system(size: 18, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color(.white))
            }
            .buttonStyle(.borderedProminent)
            .navigationBarBackButtonHidden(true)
            
  
        .navigationTitle("Bag Configuration")

    } // Body
} /// struct

// Incorporate all Input attributes in a struct
        struct InputField: View {
            let label: String
            // Binding required because it's an input variable
            @Binding var value: Double
           
            let unit: String
            
            var body: some View {
                HStack {
                    Text(label)
                        .frame(minWidth: 150, alignment: .trailing)
                        .font(.title3)
                        .foregroundColor(.black)
                    TextField("", value: $value, format: .number)
         //               .focused($focusedField)
                        .font(.title)
                        .foregroundColor(.black)
                        .background(.white)
                        .frame(minWidth: 100, alignment: .leading)
                        .keyboardType(.decimalPad)
                        
                    Text(unit)
                        .frame(minWidth: 100, alignment: .leading)
                        .font(.title3)
                        .foregroundColor(.black)
                }
            }
        }  // Struct
// Incorporate all Output  attributes in a struct
        struct OutputDecField: View {
            let label: String
            let value: Double
            let unit: String
            
            var body: some View {
                VStack {
                    HStack {
                        Text(label)
                            .frame(minWidth: 150, alignment: .trailing)
                            .font(.title3)
                            .foregroundColor(.black)
                        Text("\(String(format: "%.2f", value)) \(unit)")
                            .frame(minWidth: 160, alignment: .leading)
                            .font(.title3)
                            .foregroundColor(.black)
                            .background( Color(red: 0.85, green: 0.95, blue: 0.99))
                            .padding(10)
                    } // HStack
                .frame(height: 40)
                } // VStack
            } // Body
        } // Struct

// Incorporate all Bag  attributes in a struct
        struct OutputBagField: View {
            let label: String
            let valCem: Double
            let valSand: Double
            let valAgg: Double
            
            var body: some View {
                VStack {
                    HStack {
                        Text(label)
                            .frame(minWidth: 80, alignment: .center)
                        Text("\(String(format: "%.0f", valCem))")
                            .frame(minWidth: 80, alignment: .center)
                        Text("\(String(format: "%.0f", valSand))")
                            .frame(minWidth: 80, alignment: .center)
                        Text("\(String(format: "%.0f", valAgg))")
                            .frame(minWidth: 80, alignment: .leading)
                        
                    } // HStack
                            .font(.title3)
                            .foregroundColor(.black)
                            .background( Color(red: 0.85, green: 0.95, blue: 0.99))
                          //  .padding(10)
                            .frame(height: 50)
                } // VStack
            } // Body
        } // Struct
#Preview {
    MainMenu()
}














