//
//  BottomSheet.swift
//  TrackUs
//
//  Created by 석기권 on 2024/02/04.
//

import SwiftUI


// CustomBottomSheet
fileprivate enum BottomSheetConstants {
    static let radius: CGFloat = 27
    static let indicatorHeight: CGFloat = 4
    static let indicatorWidth: CGFloat = 32
    static let snapRatio: CGFloat = 0.25
    static let minHeightRatio: CGFloat = 0.3
}

struct BottomSheet<Content: View>: View {
    @Binding var isOpen: Bool
    @GestureState private var translation: CGFloat = 0
    let onChanged: ((DragGesture.Value) -> ())?
    let onEnded: ((DragGesture.Value) -> ())?
    
    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content
    
    init(isOpen: Binding<Bool>, maxHeight: CGFloat, minHeight: CGFloat, @ViewBuilder content: () -> Content, onChanged : @escaping (DragGesture.Value) -> (), onEnded : @escaping (DragGesture.Value) -> ()) {
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.content = content()
        self._isOpen = isOpen
        self.onChanged = onChanged
        self.onEnded = onEnded
    }
    
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }
    
    private var indicator: some View {
        RoundedRectangle(cornerRadius: BottomSheetConstants.radius)
            .fill(.indicator)
            .frame(
                width: BottomSheetConstants.indicatorWidth,
                height: BottomSheetConstants.indicatorHeight
            )
            .padding(12)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.indicator
                self.content
            }
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(.white)
            .clipShape(
                .rect (
                    topLeadingRadius: 12,
                    topTrailingRadius: 12
                )
            )
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(min(self.offset + self.translation, self.maxHeight - self.minHeight), 0))
            .animation(.interactiveSpring(), value: translation)
            .gesture(
                DragGesture().updating(self.$translation) { value, state, transaction in
                    state = value.translation.height
                }
                    .onChanged({ value in
                        if let onChanged = onChanged {
                            onChanged(value)
                        }
                    })
                
                    .onEnded { value in
                        guard let onEnded = onEnded else { return }
                        let snapDistance = self.maxHeight * BottomSheetConstants.snapRatio
                        guard abs(value.translation.height) > snapDistance else {
                            onEnded(value)
                            return
                        }
                        withAnimation(.interactiveSpring) {
                            self.isOpen = value.translation.height < 0
                        }
                        onEnded(value)
                    }
            )
        }
    }
}
