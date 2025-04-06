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
    
    

    // MARK: - Pad A=Length B+Width C=Height D=Diameter E=DiameterIn F=Note G=Shape
    static func shapeFigs(A: Double, B: Double, C: Double, D: Double, E: Double, F: String, G: String) ->  (Area: Double, Volume: Double, Bags20kg: Double, Bags25kg: Double, Bags30kg: Double) {
        var Area = 0.0; var Volume = 0.0; var Bags20kg = 0.0; var Bags25kg = 0.0; var Bags30kg = 0.0

        if G == "C" {
            Area = A * B
            Volume =  A * B * C }
        else if G == "R" {
            Area =   .pi * (pow(0.5 * D,2))       // pi * radius squared
            Volume = .pi * C * (pow(0.5 * D, 2)) } // pi * Radius squared * Height
        
        else if G == "S" {
            let AngleX = acos((pow(A, 2) + pow(C, 2) - pow(B, 2)) / (2 * A * C)) * 180 / .pi
            Area =   0.5 * A * C * sin(AngleX * .pi / 180)      // Half the shortest side * the next longest
            Volume = Area * B  }// Half the Base * Length * Height
       
        else if G == "O" {
            Area =   .pi * (pow(0.5 * D,2))
            let outerVol: Double = .pi * C * (pow(0.5 * D, 2))
            let innerVol: Double = .pi * C * (pow(0.5 * E, 2))
            Volume = outerVol - innerVol }

        let res: Double = convertToCubicMetres(X:Volume, Y:F)
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
        if Y == "ft" {
            let feet = Double(Int(X))  // Extract whole feet
            let inches = (X - feet) * 10  // Convert decimal part to inches
            let totalInches = (feet * 12) + inches
            res = totalInches / 424  // Convert to cubic meters
        } else {
            res = X }
        return res
    }
    
    static func VolfeetToInches(A: Double, B: Double, C: Double) -> (IntFeet: Double, IntInches: Double) {
        var IntFeet: Double = 0.0; var IntInches: Double = 0.0
        let AInches = Double(Int(A) * 12) + (10 * (A - Double(Int(A))))
        let BInches = Double(Int(B) * 12) + (10 * (B - Double(Int(B))))
        let CInches = Double(Int(C) * 12) + (10 * (C - Double(Int(C))))
        let TotInches = AInches * BInches * CInches
        IntFeet = Double(Int(TotInches / pow(12,3)))
        IntInches = Double(TotInches - (IntFeet * pow(12,3))) / 144
        return (IntFeet, IntInches)
    }
 
 // A=Length B=Width
    static func AreafeetToInches(A: Double, B: Double) -> (IntFeet: Double, IntInches: Double) {
        var IntFeet: Double = 0.0; var IntInches: Double = 0.0
        let AInches = Double(Int(A) * 12) + (10 * (A - Double(Int(A))))
        let BInches = Double(Int(B) * 12) + (10 * (B - Double(Int(B))))
        let TotInches = AInches * BInches
        IntFeet = Double(TotInches / 144)
        let remainder = Double(TotInches.remainder(dividingBy: 144))
        IntInches = Double(remainder / 144 * 12)
        return (IntFeet, IntInches)
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
/*
    static func AreaImpformat(_ IntFeet: Double, _ IntInches: Double) -> AttributedString {
        var val = AttributedString("sq.\(String(format: "%.0f", IntFeet)) ft \(String(format: "%.1f", IntInches)) in")
        val.font = .largeTitle
       val.foregroundColor = .black
        val.backgroundColor = .orange
        return val
    }
*/
    static func VolImpformat(_ IntFeet: Double, _ IntInches: Double) -> AttributedString {
        var val = AttributedString("cu.\(String(format: "%.0f", IntFeet)) ft \(String(format: "%.1f", IntInches)) in")
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





