//
//  ContentView.swift
//  osmilk
//
//  Created by Frederik Heuser on 14.08.20.
//  Copyright © 2020 Frederik Heuser. All rights reserved.
//



import SwiftUI
import WhirlyGlobeMaplyComponent

struct ContentView: View {
    @State public var showingDetails = false
    var body: some View {
        VStack {


            OsmView(showingDetails: $showingDetails, osmapview: OsmViewControllerRepresentable(osmController: OSMViewController(showingDetails: $showingDetails)))
            
//            MapView()
                .frame(height:600)
                .edgesIgnoringSafeArea(.top)
            
//            CircleImage()
//                .offset(y: -130)
//                .padding(.bottom,-130)
            VStack {
                Text("osmilk")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                HStack {
                    Text("Best app you've ever seen")
                        .font(.subheadline)
                    Spacer()
                    Text("Milkaway")
                        .font(.subheadline)
                }
            .padding()
                
            Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





