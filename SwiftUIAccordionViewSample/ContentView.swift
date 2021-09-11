//
//  ContentView.swift
//  SwiftUIAccordionViewSample
//
//  Created by Nico Prananta on 11.09.21.
//

import SwiftUI

struct RowView: View {
  @Environment(\.colorScheme) var colorScheme
  @State var title = ""
  @State var subtitle = ""
  
  var body: some View {
    AccordionView {
      Text(title)
        .font(.subheadline)
        .multilineTextAlignment(.leading)
        .fixedSize(horizontal: false, vertical: true)
    } subtitle: {
      Text(subtitle)
        .multilineTextAlignment(.leading)
        .fixedSize(horizontal: false, vertical: true)
        .font(.largeTitle)
    }
    .foregroundColor(colorScheme == .dark ? .white : .black)
  }
}

struct ContentView: View {
  @Environment(\.colorScheme) var colorScheme
  @State var data = Jokes()
  
  var body: some View {
    ZStack {
      Group {
        if colorScheme == .dark {
          Color(
            red:  51/255,
            green: 51/255,
            blue:  54/255)
        } else {
          Color.white
        }
      }
      .edgesIgnoringSafeArea(.all)
      .overlay(
        ScrollView {
          VStack {
            ForEach(data, id: \.id) { joke in
              RowView(title: joke.setup,
                      subtitle: joke.punchline)
            }
          }
          .padding()
          .animation(.spring())
        }
        
      )
    }
    .onAppear(perform: {
      do {
        self.data = try (URL(string: url)!).json(Jokes.self)
      } catch {
        print(error)
      }
    })
    
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
