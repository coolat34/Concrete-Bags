//
//  CustomButton.swift
//  Buttons and TabItems
//
//  Created by Chris Milne on 24/09/2023.
//

import SwiftUI

struct CustomButton: View {
    let label: String
    let width: Int
    let isDisabled: Bool

    init(label: String, width: Int = 300, isDisabled: Bool = false) {
      self.label = label
      self.width = width
      self.isDisabled = isDisabled
    }

    var body: some View {
      Text("\(label)").fontWeight(.bold)
        .foregroundColor(Color.white)
        .frame(width: CGFloat(width), height: 48, alignment: .center)
        .background(isDisabled ? Color.yellow : Color.teal)
        .cornerRadius(16, antialiased: true)
        .padding()
        .animation(.easeInOut, value: isDisabled)
    }
  }

  struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
      CustomButton(label: "This is the label", isDisabled: true)
    }
  }
