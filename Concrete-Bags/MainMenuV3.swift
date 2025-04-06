//
//  ContentView.swift
//  Concrete-Bags
//
//  Created by Chris Milne on 01/04/2025.
//
/*
import Foundation
import SwiftUI

struct MainMenuV3: View {
    var shapeSmalls: [String] = ["ConcreteSlab", "Round", "Segment", "Open Cylinder"]
    @State private var listView = false
    @State private var resetView = false

    var body: some View {
        
        NavigationStack {
            List {
            ForEach(shapeSmalls, id: \.self) { shapeSmall in
                NavigationLink(destination: shapeSmallDetail(shapeSmall: shapeSmall, shapeSelected: "C")) {
                    shapeSmallRow(shapeSmall: shapeSmall) }

                           } /// ForEach
                       } /// List
                       .navigationTitle("Concrete Calculator")
                       .listStyle(.grouped)
                   } /// NavStack
               } /// Body
           } /// Struct

struct shapeSmallRow: View {

    var shapeSmall: String
    
    var body: some View {
        HStack {
            
            Image(shapeSmall)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 70)
            Text(shapeSmall)
                .frame(width: 120, height: 70)
            
        }
        
    }
}
/// struct shapeSmallRow

struct shapeSmallDetail: View {
    @Environment(\.dismiss) var dismiss
    var shapeSmall: String
    var shapeSelected: String
    @State var Len: Double = 0.0
    @State var Width: Double = 0.0
    @State var Height: Double = 0.0
    @State var Diameter: Double = 0.0
    @State var DiameterIn: Double = 0.0
    @State var Area: Double = 0.0
    @State var Volume: Double = 0.0
    @State var Bags20kg: Double = 0.0
    @State var Bags25kg: Double = 0.0
    @State var Bags30kg: Double = 0.0
    
    @State private var listView = false
    @State private var resetView = false
    var measurements: [String] = [
        "Millimetres",
        "Centimetres",
        "Metres",
        "Inches",
        "Feet",
    ]
    var notation: [String] = ["mm", "cm", "m", "in", "ft"]
    @State private var selectedMeasurement: String = "Millimetres"
    @State var note: String = "mm"
    @State var myNote: Int = 0
    @State var messageString = ""
    
    func updateValuesShape(shapeSelected: String) {
        let valResult = DataHandler.shapeFigs(
            A: Len,
            B: Width,
            C: Height,
            D: Diameter,
            E: DiameterIn,
            F: note,
            G: shapeSelected
        )
        Area = valResult.Area
        Volume = valResult.Volume
        Bags20kg = valResult.Bags20kg
        Bags25kg = valResult.Bags25kg
        Bags30kg = valResult.Bags30kg
    }
 
    var body: some View {
        ZStack {
            Color(red: 0.85, green: 0.95, blue: 0.99)
                .edgesIgnoringSafeArea(.all)  // Cover the entire screen
            //MARK: Heading
            VStack {
                Text("Calculate Area, Volume and Bags")
                    .font(.title2)
 
                HStack {
                    Text(shapeSmall).font(.title3)
                    Image(shapeSmall)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                } // HStack
                .font(.title)
                
                //MARK: Select Measurement
                HStack {
                    Button {
                    } label: {
                        
                        Picker("Measurement", selection: $selectedMeasurement) {
                            ForEach(measurements, id: \.self) {
                                Text($0)
                                    .font(.system(size: 18, weight: .bold))
                                    .edgesIgnoringSafeArea(.all)
                                
                            }/// ForEach
                        }/// Picker
                        .pickerStyle(.segmented)
// Use onChange of for Picker
                        .onChange(of: selectedMeasurement) {
                            if let index = measurements.firstIndex(
                                of: selectedMeasurement
                            ) {
                                myNote = index
                                note = notation[myNote]  // Store notation
                            }
                        }
                    }/// Label
                }/// HStack
                .padding(20)
                //MARK: Concrete Slab
                // MARK: Length input
                if shapeSmall == "ConcreteSlab" {
                    HStack(spacing: 5) {
                        Text(DataHandler.PreInputformat("Length"))
                            .frame(minWidth: 100, alignment: .leading)
                        TextField("", value: $Len, format: .number)
                            .onChange(of: Len) {
                                updateValuesShape(shapeSelected: "C") }
                            .font(.largeTitle)
                            .foregroundColor(.black)
                            .background(.orange)
                            .frame(minWidth: 70, alignment: .leading)
                        Text(DataHandler.PreInputformat(note))
                            .frame(minWidth: 100, alignment: .leading)
                    }/// HStack
                    .frame(height: 50)
                    
                    // MARK: Width input
                    GeometryReader { geometry in
                        HStack(spacing: 5) {
                            Text(DataHandler.PreInputformat("Width "))
                                .frame(minWidth: 100, alignment: .leading)
                            TextField("", value: $Width, format: .number)
                                .onChange(of: Width) { updateValuesShape(shapeSelected: "C") }
                                .font(.largeTitle)
                                .foregroundColor(.black)
                                .frame(minWidth: 50, alignment: .leading)
                                .background(.orange)
                            Text(DataHandler.PreInputformat(note))
                                .frame(minWidth: 100, alignment: .leading)
                        }/// HStack
                    }/// Geometry Reader
                    .frame(height: 50)
                    
                    // MARK: Height input
                    GeometryReader { geometry in
                        HStack(spacing: 5) {
                            Text(DataHandler.PreInputformat("Height"))
                                .frame(minWidth: 100, alignment: .leading)
                            TextField("", value: $Height, format: .number)
                                .onChange(of: Height) { updateValuesShape(shapeSelected: "C") }
                                .font(.largeTitle)
                                .foregroundColor(.black)
                                .frame(minWidth: 70, alignment: .leading)
                                .background(.orange)
                            Text(DataHandler.PreInputformat(note))
                                .frame(minWidth: 100, alignment: .leading)
                        }/// HStack
                    }/// Geometry Reader
                    .frame(height: 50)
                } /// IF PAD
                
                //MARK: ROUND
                if shapeSmall == "Round" {
                    HStack(spacing: 5) {
                        Text(DataHandler.PreInputformat("Diameter"))
                            .frame(minWidth: 150, alignment: .leading)
                        TextField("", value: $Diameter, format: .number)
                            .onChange(of: Diameter) { updateValuesShape(shapeSelected: "R") }
                            .font(.largeTitle)
                            .foregroundColor(.black)
                            .background(.orange)
                            .frame(minWidth: 70, alignment: .leading)
                        Text(DataHandler.PreInputformat(note))
                            .frame(minWidth: 100, alignment: .leading)
                    }/// HStack
                    .frame(height: 50)
                    
                    // MARK: Width input
                    GeometryReader { geometry in
                        HStack(spacing: 5) {
                            Text(DataHandler.PreInputformat("Height "))
                                .frame(minWidth: 150, alignment: .leading)
                            TextField("", value: $Height, format: .number)
                                .onChange(of: Height) { updateValuesShape(shapeSelected: "R") }
                                .font(.largeTitle)
                                .foregroundColor(.black)
                                .frame(minWidth: 60, alignment: .leading)
                                .background(.orange)
                            Text(DataHandler.PreInputformat(note))
                                .frame(minWidth: 100, alignment: .leading)
                        }/// HStack
                    }/// Geometry Reader
                    .frame(height: 50)
                } /// IF Round
                
                //MARK: Segment
                // MARK: Length input
                if shapeSmall == "Segment" {
                    HStack(spacing: 5) {
                        Text(DataHandler.PreInputformat("Length"))
                            .frame(minWidth: 100, alignment: .leading)
                        TextField("", value: $Len, format: .number)
                            .onChange(of: Len) { updateValuesShape(shapeSelected: "S") }
                            .font(.largeTitle)
                            .foregroundColor(.black)
                            .background(.orange)
                            .frame(minWidth: 70, alignment: .leading)
                        Text(DataHandler.PreInputformat(note))
                            .frame(minWidth: 100, alignment: .leading)
                    }/// HStack
                    .frame(height: 50)
                    
                    // MARK: Width input
                    GeometryReader { geometry in
                        HStack(spacing: 5) {
                            Text(DataHandler.PreInputformat("Width "))
                                .frame(minWidth: 100, alignment: .leading)
                            TextField("", value: $Width, format: .number)
                                .onChange(of: Width) { updateValuesShape(shapeSelected: "S") }
                                .font(.largeTitle)
                                .foregroundColor(.black)
                                .frame(minWidth: 50, alignment: .leading)
                                .background(.orange)
                            Text(DataHandler.PreInputformat(note))
                                .frame(minWidth: 100, alignment: .leading)
                        }/// HStack
                    }/// Geometry Reader
                    .frame(height: 50)
                    
                    // MARK: Height input
                    GeometryReader { geometry in
                        HStack(spacing: 5) {
                            Text(DataHandler.PreInputformat("Height"))
                                .frame(minWidth: 100, alignment: .leading)
                            TextField("", value: $Height, format: .number)
                                .onChange(of: Height) { updateValuesShape(shapeSelected: "S") }
                                .font(.largeTitle)
                                .foregroundColor(.black)
                                .frame(minWidth: 70, alignment: .leading)
                                .background(.orange)
                            Text(DataHandler.PreInputformat(note))
                                .frame(minWidth: 100, alignment: .leading)
                        }/// HStack
                    }/// Geometry Reader
                    .frame(height: 50)
                }  /// IF Segment
                
                //MARK: Open Cylinder
                if shapeSmall == "Open Cylinder" {
                    HStack(spacing: 5) {
                        Text(DataHandler.PreInputformatOpenCylinder("Outer Diameter"))
                            .frame(minWidth: 150, alignment: .leading)
                        TextField("", value: $Diameter, format: .number)
                            .onChange(of: Diameter) { updateValuesShape(shapeSelected: "O") }
                            .font(.largeTitle)
                            .foregroundColor(.black)
                            .background(.orange)
                            .frame(minWidth: 70, alignment: .leading)
                        Text(DataHandler.PreInputformat(note))
                            .frame(minWidth: 100, alignment: .leading)
                    }/// HStack
                    .frame(height: 50)
                    
                    HStack(spacing: 5) {
                        Text(DataHandler.PreInputformatOpenCylinder("Inner Diameter"))
                            .frame(minWidth: 150, alignment: .leading)
                        TextField("", value: $DiameterIn, format: .number)
                            .onChange(of: DiameterIn) { updateValuesShape(shapeSelected: "O") }
                            .font(.largeTitle)
                            .foregroundColor(.black)
                            .background(.orange)
                            .frame(minWidth: 70, alignment: .leading)
                        Text(DataHandler.PreInputformat(note))
                            .frame(minWidth: 100, alignment: .leading)
                    }/// HStack
                    .frame(height: 50)
                    
                    // MARK: Height input
                    GeometryReader { geometry in
                        HStack(spacing: 5) {
                            Text(DataHandler.PreInputformatOpenCylinder("Height "))
                                .frame(minWidth: 150, alignment: .leading)
                            TextField("", value: $Height, format: .number)
                                .onChange(of: Height) { updateValuesShape(shapeSelected: "O") }
                                .font(.largeTitle)
                                .foregroundColor(.black)
                                .frame(minWidth: 60, alignment: .leading)
                                .background(.orange)
                            Text(DataHandler.PreInputformat(note))
                                .frame(minWidth: 100, alignment: .leading)
                        }/// HStack
                    }/// Geometry Reader
                    .frame(height: 50)
                } /// IF Open Cylinder
                
// MARK: Area output
                
                HStack(spacing: 5) {
                    Text(DataHandler.PreInputformat("Area   "))
                        .frame(minWidth: 100, alignment: .leading)
                    if note != "ft" {
                        Text(DataHandler.AreaDecformat(Area, note))
                            .frame(minWidth: 235, alignment: .leading)
                    } else {
                        let ftin = DataHandler.AreafeetToInches(
                            A: Len,
                            B: Width
                        )
                        Text(
                            DataHandler
                                .AreaImpformat(ftin.IntFeet, ftin.IntInches)
                        )
                        .frame(minWidth: 250, alignment: .leading)
                    }
                }/// HStack
                .frame(height: 50)
                
// MARK: Volume output
                HStack(spacing: 5) {
                    Text(DataHandler.PreInputformat("Volume"))
                        .frame(minWidth: 100, alignment: .leading)
                    
                    if note != "ft" {
                        Text(DataHandler.VolDecformat(Volume, note))
                            .frame(minWidth: 250, alignment: .leading)
                    } else {
                        let ftin = DataHandler.VolfeetToInches(
                            A: Len,
                            B: Width,
                            C: Height
                        )
                        
                        Text(
                            DataHandler
                                .VolImpformat(ftin.IntFeet, ftin.IntInches)
                        )
                        .frame(minWidth: 250, alignment: .leading)
                    }
                }/// HStack
                .frame(height: 50)
                
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
                HStack(spacing: 5) {
                    Text("Bags").frame(width: 100)
                    Text("\(String(format: "%.0f",Bags20kg))").frame(width: 100)
                    Text("\(String(format: "%.0f",Bags25kg))").frame(width: 100)
                    Text("\(String(format: "%.0f",Bags30kg))").frame(width: 100)
                }/// HStack
                .frame(height: 50)
                .font(.largeTitle)
                .foregroundColor(.black)
                .background(.orange)
            }/// VStack
        }
        /// ZStack
        
        Spacer()
        Spacer()
        Spacer()
        Button(action: {
            Len = 0.0
            Width = 0.0
            Height = 0.0
            Diameter = 0.0
            DiameterIn = 0.0
        }) {
            Label("Reset all values", systemImage: "eraser")
                .font(.system(size: 24, weight: .bold))
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        
        Button(action: {
            dismiss()
        }) {
            Label("Return", systemImage: "arrowshape.backward.circle.fill")
                .font(.system(size: 24, weight: .bold))
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .navigationBarBackButtonHidden(true)
    }/// Body
    
}
/// Struct

#Preview {
    MainMenuV3()
}

*/
