//
//  AccordionView.swift
//  SwiftUIAccordionViewSample
//
//  Created by Nico Prananta on 11.09.21.
//

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
  static var defaultValue = CGSize.zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    value = nextValue()
  }
}

struct SizePreferenceModifier: ViewModifier {
  func body(content: Content) -> some View {
    content.background(
      GeometryReader { geometry in
        Color.clear.preference(key: SizePreferenceKey.self, value: geometry.size)
      }
    )
  }
}

struct AccordionView<TitleView: View, SubtitleView: View>: View {
  let title: TitleView
  let subtitle: SubtitleView
  
  @State private var reveal = false
  @State private var subtitleSize = CGSize.zero
  
  init(@ViewBuilder title: () -> TitleView, @ViewBuilder subtitle: () -> SubtitleView) {
    self.title = title()
    self.subtitle = subtitle()
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      Color.clear.frame(height: 20)
      title
      Color.clear.overlay(
        subtitle
          .opacity(reveal ? 1 : 0)
          .animation(.easeInOut)
          .modifier(SizePreferenceModifier())
          .position(x: 0 + subtitleSize.width / 2, y: 0 + subtitleSize.height / 2)
      )
      .frame(height: reveal ? subtitleSize.height : 0)
      .clipped()
    }
    .frame(maxWidth: .infinity)
    .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5))
    .onPreferenceChange(SizePreferenceKey.self, perform: { value in
      subtitleSize = value
    })
    .contentShape(Rectangle())
    .onTapGesture(perform: {
      reveal.toggle()
    })
  }
}


struct AccordionViewSample: View {
  var body: some View {
    Text("Hello, world!")
      .padding()
  }
}


struct AccordionView_Previews: PreviewProvider {
    static var previews: some View {
      AccordionViewSample()
    }
}
