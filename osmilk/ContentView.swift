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
                .edgesIgnoringSafeArea(.top)
            

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}





