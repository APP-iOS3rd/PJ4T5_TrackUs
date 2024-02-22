//
//  CustomTooltip.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/23.
//

import SwiftUI

private struct CustomTriangleShape: Shape {
  private var width: CGFloat
  private var height: CGFloat
  private var radius: CGFloat
  
  fileprivate init(
    width: CGFloat = 24,
    height: CGFloat = 24,
    radius: CGFloat = 1
  ) {
    self.width = width
    self.height = height
    self.radius = radius
  }
  
  fileprivate func path(in rect: CGRect) -> Path {
    var path = Path()
    
    path.move(to: CGPoint(x: rect.minX + width / 2 - radius, y: rect.minY))
    path.addQuadCurve(
      to: CGPoint(x: rect.minX + width / 2 + radius, y: rect.minY),
      control: CGPoint(x: rect.minX + width / 2, y: rect.minY + radius)
    )
    path.addLine(to: CGPoint(x: rect.minX + width, y: rect.minY + height))
    path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + height))
    
    path.closeSubpath()
    
    return path
  }
}

private struct CustomRectangleShape: View {
  private var text: String
  
  fileprivate init(text: String) {
    self.text = text
  }
  
  fileprivate var body: some View {
    VStack {
      Spacer()
      
      Text(text)
        .font(.title)
        .foregroundColor(.white)
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(
          RoundedRectangle(cornerRadius:20)
            .fill(.green)
        )
    }
  }
}

private struct TooltipShape: View {
  fileprivate var body: some View {
    ZStack {
      CustomTriangleShape()
        .fill(.green)
        .padding(.leading, 178)
      
      CustomRectangleShape(text: "Tooltip 입니다!")
    }
    .frame(width: 216, height: 45)
  }
}


struct CustomTooltip: View {
  @Binding var isDisplayTooltip: Bool
  
   var body: some View {
    HStack {
      Spacer()
      TooltipShape()
        .onTapGesture {
          isDisplayTooltip = false
        }
    }
  }
}


#Preview {
    CustomTooltip(isDisplayTooltip: .constant(true))
}
