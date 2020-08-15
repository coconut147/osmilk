//
//  CircleImage.swift
//  osmilk
//
//  Created by Frederik Heuser on 15.08.20.
//  Copyright © 2020 Frederik Heuser. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image("IceCoffee")
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white))
            .shadow(radius: 10)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}
