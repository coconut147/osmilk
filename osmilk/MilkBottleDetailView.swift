//
//  MilkBottleDetailView.swift
//  osmilk
//
//  Created by Frederik Heuser on 17.08.20.
//  Copyright © 2020 Frederik Heuser. All rights reserved.
//

import SwiftUI


struct MilkBottleDetailView: View {
    internal init(bottle: MilkBottle) {
        self.bottle = bottle
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    private var bottle = MilkBottle()
    
    var body: some View {
        
        
        VStack {
            Text(self.bottle.getTitle())
            Text(self.bottle.getEmojitizedVending())
            Text(self.bottle.identifier)
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Button(action: { self.presentationMode.wrappedValue.dismiss()
                
            }) {
            Text("Dismiss")
            }
        }
        
    }
}

struct MilkBottleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MilkBottleDetailView(bottle: MilkBottle())
    }
}
