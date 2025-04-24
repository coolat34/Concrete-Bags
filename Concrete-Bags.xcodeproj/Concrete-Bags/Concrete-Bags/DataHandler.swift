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
    
    

    // MARK: - Pad A=LengthA B+Width C=Height D=Diameter E=Diametersmall F=Note G=Shape I=DiameterLarge J=LengthB K=ratioSelected
    static func shapeFigs(A: Double, B: Double, C: Double, D: Double, E: Double, F: String, G: String, I: Double, J: Double, K: String) ->
    (Area: Double,
     Volume: Double,
     BagsCement20kg: Double,
     BagsCement25kg: Double,
     BagsCement30kg: Double,
     BagsSand20kg: Double,
     BagsSand25kg: Double,
     BagsSand30kg: Double,
     BagsAggregate20kg: Double,
     BagsAggregate25kg: Double,
     BagsAggregate30kg: Double
    )
    {
        var Area = 0.0; var Volume = 0.0; var BagsCement20kg = 0.0; var BagsCement25kg = 0.0; var BagsCement30kg = 0.0; var BagsSand20kg = 0.0; var BagsSand25kg = 0.0; var BagsSand30kg = 0.0; var BagsAggregate20kg = 0.0; var BagsAggregate25kg = 0.0; var BagsAggregate30kg = 0.0
        
        
        if G == "C" {  // Concrete Slab
            Area = A * B
            Volume =  A * B * C }
        
        else if G == "O" {  // Open Round
            Area =   .pi * (pow(0.5 * I,2) - pow(0.5 * E,2))
            let outerVol: Double = .pi * C * (pow(0.5 * I, 2))
            let innerVol: Double = .pi * C * (pow(0.5 * E, 2))
            Volume = outerVol - innerVol }
        
        else if G == "S" {  // Segment
            let semi: Double = 0.5 * (A + B + J)  // semi is the semi perimeter
            let deter: Double = semi * (semi - A) * (semi - B) * (semi - J)
            Area =   sqrt(max(deter,0))  /// prevents negative numbers
            Volume = Area * C  }
        
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
        var Cem = 0.0
        var Sand = 0.0
        var Agg = 0.0
        if K == "Basic" {
            Cem = 1.0 ; Sand = 3.0 ; Agg = 6.0
        } else
        if K == "Medium" {
            Cem = 1.0 ; Sand = 2.0 ; Agg = 4.0
           } else
        if K == "Strong" {
               Cem = 1.0 ; Sand = 1.5 ; Agg = 3.0
           }
        let totmix: Double = Double(Cem + Sand + Agg)
        BagsCement20kg = round(Double(Int(res * Cem/(totmix) * 2225 / 20)))
        BagsCement25kg = round(Double(Int(res * Cem/(totmix) * 2225 / 25)))
        BagsCement30kg = round(Double(Int(res * Cem/(totmix) * 2225 / 30)))
        BagsSand20kg = round(Double(Int(res * Sand/(totmix) * 2225 / 20)))
        BagsSand25kg = round(Double(Int(res * Sand/(totmix) * 2225 / 25)))
        BagsSand30kg = round(Double(Int(res * Sand/(totmix) * 2225 / 30)))
        BagsAggregate20kg = round(Double(Int(res * Agg/(totmix) * 2225 / 20)))
        BagsAggregate25kg = round(Double(Int(res * Agg/(totmix) * 2225 / 25)))
        BagsAggregate30kg = round(Double(Int(res * Agg/(totmix) * 2225 / 30)))
        
        return (Area, Volume,
                BagsCement20kg,
                BagsCement25kg,
                BagsCement30kg,
                BagsSand20kg,
                BagsSand25kg,
                BagsSand30kg,
                BagsAggregate20kg,
                BagsAggregate25kg,
                BagsAggregate30kg)
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





