//
//  OSMViewController.swift
//  osmilk
//
//  Created by Frederik Heuser on 15.08.20.
//  Copyright © 2020 Frederik Heuser. All rights reserved.
//
import UIKit
import SwiftUI

struct OsmViewControllerRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) ->MaplyViewController {
        return OSMViewController()
    }
    
    func updateUIViewController(_ uiViewController: MaplyViewController, context: Context) {
        
    }
    
}

struct OsmView: View {
    @State private var isPresented = false
    
    var body: some View {
            OsmViewControllerRepresentable()
        
    }
}

class OSMViewController : MaplyViewController {
    private var theViewC: MaplyBaseViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create an empty globe and add it to the view
        theViewC = MaplyViewController(mapType: .typeFlat)
        self.view.addSubview(theViewC!.view)
        theViewC!.view.frame = self.view.bounds
        addChild(theViewC!)
    }
    
}

struct OSMViewController_Previews: PreviewProvider {
    static var previews: some View {
        OsmView()
    }
}
