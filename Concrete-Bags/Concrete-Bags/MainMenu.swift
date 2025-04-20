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
    @Published var measureSelected: String = "Metres"
    @Published var note: String = "m"
    @Published var ratioSelected: String = "Basic"
    @Published var ratioMix: [String] = ["Basic", "Medium", "Strong"]
  
 //   let ratioAbr: [String] = ["1:3:6", "1:2:4", "1:1.5:3"]
    
    let measurements: [String] = ["Millimetres", "Centimetres", "Metres", "Inches", "Feet"]
    let notationAbr: [String] = ["mm", "cm", "m", "in", "ft"]

    
  
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
 
 //MARK: Update Measurements
    // Update the notationAbr & Bags if the Measurement changes
        func updateMeasurement(_ newMeasurement: String, shapeAbr: String, ratioSelected: String) {
            if let Mindex = measurements.firstIndex(of: newMeasurement) {
                note = notationAbr[Mindex]
            }
                updateValuesShape(shapeAbr: shapeAbr) // ReCalc Bags
            }
    
// Calculate all values when a variable is entered or changed
    func updateValuesShape(shapeAbr: String) {
        // Reset error
        showError = false
        errorMessage = ""
        
 // Basic checks for all shapes
        let allValues = [Len, LenB, Width, Height, Diameter, Diametersmall, DiameterLarge]
        if allValues.contains(where: { $0 < 0 }) {
           showError = true
           errorMessage = "Dimensions must be positive"
            return
        }
 // Check that small diameters are less than large diameters for OpenRound and Elliptical round
        
        if shapeAbr == "O" || shapeAbr == "E" {
            if DiameterLarge < Diametersmall {
               showError = true
                errorMessage = "Small Diameter must be less than Large Diameter"
                return
            }
        }
        
  // Checks for Segment (triangle)
        if shapeAbr == "S" {
            if !isValidTriangle(Len, Width, LenB) {
                showError = true
                errorMessage = "Sides do not form a valid triangle."
                return
            }
        }
        
// Check any 2 sides of triangle must be greater than the third side
           func isValidTriangle(_ a: Double, _ b: Double, _ c: Double) -> Bool {
               return a + b > c && a + c > b && b + c > a
           }

// All checks passed
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
                    Text("See the chart below.\nThe example is for 1 cubic metre\nbased on 3 levels of density per cubic metre. \nEnter  MEASUREMENTS first then\nSTRENGTH (Basic, Medium, Strong)\n")
                        .font(.headline)
                    //       .padding()
                
                
                    Image(xcelFig)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 400)
                        .padding()
               
                    NavigationLink(destination: ShapeOptions()
                        .navigationBarBackButtonHidden(true)
                    ) {
                        CustomButton(label:"Continue",width: 250)
                            .font(.system(size: 24, weight: .bold))
                            .frame(maxWidth: .infinity)
                    }
                    //             .buttonStyle(.borderedProminent)
                    
                    
                } // VStack
                .navigationTitle("Concrete Calculator")
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
                .frame(width: 80, height: 70)
            Text(shapeSmall)
                .frame(width: 120, height: 70)
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


var body: some View {
    ZStack {  // Cover the entire screen
        Color(red: 0.85, green: 0.95, blue: 0.99)
            .edgesIgnoringSafeArea(.all)
        
        VStack {
            Text("Calculate Area, Volume and Bags")
                .font(.headline)
            
            HStack {
                Text(shapeSmall).font(.title3)
                Image(shapeSmall)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 150)
            } // HStack
            
            
            //MARK: Select Measurement
            HStack {
                Button {
                } label: {
                    
                    Picker("Measurement", selection: $VM.measureSelected) {
                        ForEach(VM.measurements, id: \.self) {
                            Text($0).font(.system(size: 18, weight: .bold))
                            // .edgesIgnoringSafeArea(.all)
                        }/// ForEach
                    }/// Picker
                    .pickerStyle(.segmented)
                    // Use onChange of for Picker
                    .onChange(of: VM.measureSelected) {
                        VM.updateMeasurement(VM.measureSelected, shapeAbr: shapeAbr, ratioSelected: VM.ratioSelected)
                        
                    } // onChange of
                } // Label
            }     // HStack
            .padding(20)

            //MARK: Measurement Input
            if "CS".contains(shapeAbr) {  // Slab or Segment
                InputField(label: "Length A", value: $VM.Len, unit: VM.note)
                    .onChange(of: VM.Len) {
                        if VM.Len < 0 { VM.Len = 0 }
                        VM.updateValuesShape(shapeAbr: shapeAbr) }
                
                InputField(label: "Width", value: $VM.Width, unit: VM.note)
                    .onChange(of: VM.Width) {
                        if VM.Width < 0 { VM.Width = 0 }
                        VM.updateValuesShape(shapeAbr: shapeAbr) }
            } // Concrete & Segment
            
            if "COSHER".contains(shapeAbr) {  // All Shapes
                InputField(label: "Height", value: $VM.Height, unit: VM.note)
                    .onChange(of: VM.Height) {
                        if VM.Height < 0 { VM.Height = 0 }
                        VM.updateValuesShape(shapeAbr: shapeAbr) }
            }
            
            if "S".contains(shapeAbr) {  // Segment
                InputField(label: "Length B", value: $VM.LenB, unit: VM.note)
                    .onChange(of: VM.LenB ) {
                        if VM.LenB < 0 { VM.LenB = 0 }
                        VM.updateValuesShape(shapeAbr: shapeAbr) }
            }
            
            if "RH".contains(shapeAbr) { // Round Half-Round
                InputField(label: "Diameter", value: $VM.Diameter, unit: VM.note)
                    .onChange(of: VM.Diameter) {
                        if VM.Diameter < 0 { VM.Diameter = 0 }
                        VM.updateValuesShape(shapeAbr: shapeAbr) }
            }
            
            
            if "OE".contains(shapeAbr) { // open Round & Elliptical Round
                InputField(label: " Large \n Diameter", value: $VM.DiameterLarge, unit: VM.note)
                    .onChange(of: VM.DiameterLarge) {
                        if VM.DiameterLarge < 0 { VM.DiameterLarge = 0 }
                        VM.updateValuesShape(shapeAbr: shapeAbr) }
                
                InputField(label: " Small \n Diameter", value: $VM.Diametersmall, unit: VM.note)
                    .onChange(of: VM.Diametersmall) {
                        if VM.Diametersmall < 0 { VM.Diametersmall = 0 }
                        VM.updateValuesShape(shapeAbr: shapeAbr) }
            }
            
            // MARK: Area output
            OutputDecField(label: "Area", value: VM.Area, unit: "sq." + VM.note)
            
            // MARK: Volume output
            OutputDecField(label: "Volume", value: VM.Volume, unit: "cu." + VM.note)
        } /// VStack

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
                
                
                Spacer()
// MARK: Buttons
    NavigationLink(destination: bagFigs(shapeSmall: shapeSmall, shapeAbr: shapeAbr, VM: VM)
        .navigationBarBackButtonHidden(true)
    ) {
        Label("Continue", systemImage: "arrowshape.right.circle.fill")
                .font(.system(size: 24, weight: .bold))
                .frame(maxWidth: .infinity)
    }
    .buttonStyle(.borderedProminent)
    
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
                            // .edgesIgnoringSafeArea(.all)
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
                
                Text("Bags")
                    .frame(width: 80).font(.title)
                Text("Cement").frame(width: 90).font(.title3)
                
                Text("Sand").frame(width: 80).font(.title3)
                
                Text("Aggregate").frame(width: 100).font(.title3)
            }/// HStack
            .frame(height: 50)
            .font(.largeTitle)
            .foregroundColor(.black)
            .background( Color(red: 0.85, green: 0.95, blue: 0.99))
            
            // MARK: Bags Value
            HStack (spacing: 5)  {
                Text("20kg").frame(width: 80).font(.title)
                Text("\(String(format: "%.0f", VM.BagsCement20kg))").frame(width: 100)

                Text("\(String(format: "%.0f", VM.BagsSand20kg))").frame(width: 100)

                Text("\(String(format: "%.0f", VM.BagsAggregate20kg))").frame(width: 100)

            }/// HStack
            .frame(height: 50)
            .font(.largeTitle)
            .foregroundColor(.black)
            .background( Color(red: 0.85, green: 0.95, blue: 0.99))
            
            HStack (spacing: 5)  {
                Text("25kg").frame(width: 80).font(.title)
                Text("\(String(format: "%.0f", VM.BagsCement25kg))").frame(width: 100)

                Text("\(String(format: "%.0f", VM.BagsSand25kg))").frame(width: 100)

                Text("\(String(format: "%.0f", VM.BagsAggregate25kg))").frame(width: 100)

            }/// HStack
            .frame(height: 50)
            .font(.largeTitle)
            .foregroundColor(.black)
            .background( Color(red: 0.85, green: 0.95, blue: 0.99))
            
            HStack (spacing: 5)  {
                Text("30kg").frame(width: 80).font(.title)
                Text("\(String(format: "%.0f", VM.BagsCement30kg))").frame(width: 100)

                Text("\(String(format: "%.0f", VM.BagsSand30kg))").frame(width: 100)

                Text("\(String(format: "%.0f", VM.BagsAggregate30kg))").frame(width: 100)

            } /// HStack
            .font(.largeTitle)
            .foregroundColor(.black)
            .background( Color(red: 0.85, green: 0.95, blue: 0.99))
            Spacer()
            
            
            Button(action: { dismiss() }) {
                Label("Return", systemImage: "arrowshape.backward.circle.fill")
                    .font(.system(size: 24, weight: .bold))
                    .frame(maxWidth: .infinity)
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
                        .frame(minWidth: 100, alignment: .trailing)
                        .font(.headline)
                    TextField("", value: $value, format: .number)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .background(.white)
                        .frame(minWidth: 70, alignment: .leading)
                        .keyboardType(.decimalPad)
                        
                    Text(unit)
                        .frame(minWidth: 100, alignment: .leading)
                        .font(.largeTitle)
                }
                .frame(height: 50)
                
            }
        }  // Struct
// Incorporate all Output  attributes in a struct
        struct OutputDecField: View {
            let label: String
            let value: Double
            let unit: String
            
            var body: some View {
                HStack {
                    Text(label)
                        .frame(minWidth: 100, alignment: .trailing)
                        .font(.headline)
                    Text("\(String(format: "%.2f", value)) \(unit)")
                        .frame(minWidth: 220, alignment: .leading)
                        .font(.largeTitle)
                        .background( Color(red: 0.85, green: 0.95, blue: 0.99))
                        .padding(50)
                }
                .frame(height: 50)
                
            }
        } // Struct

#Preview {
    MainMenu()
}














