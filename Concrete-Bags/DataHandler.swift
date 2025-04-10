//
//  ContentView.swift
//  HandyHints
//
//  Created by Chris Milne on 01/04/2025.
//
/*
 106 x 20kg bag = 0.01 cubic metre
 84  x 25kg bag = 0.01 cubic metre
 70  x 30kg bag = 0.01 cubic metre
 1kg = 2.204623 lb

 */

import SwiftUI

class DataHandler: ObservableObject {
    
    

    // MARK: - Pad A=Length B+Width C=Height D=Diameter E=Diametersmall F=Note G=Shape I=DiameterLarge
    static func shapeFigs(A: Double, B: Double, C: Double, D: Double, E: Double, F: String, G: String, I: Double) ->  (Area: Double, Volume: Double, Bags20kg: Double, Bags25kg: Double, Bags30kg: Double) {
        var Area = 0.0; var Volume = 0.0; var Bags20kg = 0.0; var Bags25kg = 0.0; var Bags30kg = 0.0

        if G == "C" {  // Concrete Slab
            Area = A * B
            Volume =  A * B * C }
      
        else if G == "O" {  // Open Round
            Area =   .pi * (pow(0.5 * I,2) - pow(0.5 * E,2))
            let outerVol: Double = .pi * C * (pow(0.5 * I, 2))
            let innerVol: Double = .pi * C * (pow(0.5 * E, 2))
            Volume = outerVol - innerVol }
        
        else if G == "S" {  // Segment
            let AngleX = acos((pow(A, 2) + pow(C, 2) - pow(B, 2)) / (2 * A * C)) * 180 / .pi
            Area =   0.5 * A * C * sin(AngleX * .pi / 180)      // Half the shortest side * the next longest
            Volume = Area * B  }// Half the Base * Length * Height
        
        else if G == "H" {  // Half Round
        Area =   0.5 * (.pi * (pow(0.5 * D,2)))       // Half pi * radius squared
        Volume = 0.5 * (.pi * C * (pow(0.5 * D, 2))) } // Half pi * Radius squared * Height
        
        else if G == "E" { // Elliptical Round
            let radSmall: Double = 0.5 * E
            let radLarge: Double  = 0.5 * I
            Area = .pi * (pow(radLarge,2) - pow(radSmall,2) )
            Volume = .pi * C * (pow(radLarge,2) - pow(radSmall,2) )
        }
        
        else if G == "R" {  // Round
            Area =   .pi * (pow(0.5 * D,2))       // pi * radius squared
            Volume = .pi * C * (pow(0.5 * D, 2)) } // pi * Radius squared * Height

        let res: Double = convertToCubicMetres(X:Volume, Y:F)  /// Bag caclulation
       Bags20kg = Double(Int(100 * res))
       Bags25kg = Double(Int(80 * res))
       Bags30kg = Double(Int(60 * res))
        return (Area, Volume, Bags20kg, Bags25kg, Bags30kg)
    }

    static func convertToCubicMetres(X: Double, Y: String) -> Double { // X=Volume, Y=Note
        var res = 0.0
        if Y == "mm" {  res = X / 1000000000
        } else
         if Y == "cm" { res = X / 1000000
        } else
        if Y == "in" { res = X / 61023.7
        } else
        if Y == "ft" { res = X / 35.315
        } else {
            res = X }
        return res
    }

    static func PreInputformat(_ text: String) -> AttributedString {
        var val = AttributedString("  \(text)")
        val.font = .largeTitle
        val.foregroundColor = .black
        val.backgroundColor = .yellow
        return val
    }
    
    static func PreInputformatOpenCylinder(_ text: String) -> AttributedString {
        var val = AttributedString("  \(text)")
        val.font = .title3
        val.foregroundColor = .black
        val.backgroundColor = .yellow
        return val
    }
    
    static func AreaDecformat(_ Area: Double, _ note: String) -> AttributedString {
        var val = AttributedString("\(String(format: "%.2f",(Area))) sq.\(note)")
        val.font = .largeTitle
        val.foregroundColor = .black
        val.backgroundColor = .orange
        return val
    }

    static func VolDecformat(_ Volume: Double, _ note: String) -> AttributedString {
        var val = AttributedString("\(String(format: "%.2f",(Volume))) cu.\(note)")
        val.font = .largeTitle
        val.foregroundColor = .black
        val.backgroundColor = .orange
        return val
    }
    
    
}





