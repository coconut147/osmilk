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
        
        let globeViewC = theViewC as? WhirlyGlobeViewController
        let mapViewC = theViewC as? MaplyViewController
        
        // we want a black background for a globe, a white background for a map.
        theViewC!.clearColor = (globeViewC != nil) ? UIColor.black : UIColor.white

        // and thirty fps if we can get it ­ change this to 3 if you find your app is struggling
        theViewC!.frameInterval = 2

        // set up the data source
        if let tileSource = MaplyMBTileSource(mbTiles: "geography-class_medres"),
               let layer = MaplyQuadImageTilesLayer(tileSource: tileSource) {
            layer.handleEdges = (globeViewC != nil)
            layer.coverPoles = (globeViewC != nil)
            layer.requireElev = false
            layer.waitLoad = false
            layer.drawPriority = 0
            layer.singleLevelLoading = false
            theViewC!.add(layer)
        }

        // start up over Madrid, center of the old-world
        if let globeViewC = globeViewC {
            globeViewC.height = 0.8
            globeViewC.animate(toPosition: MaplyCoordinateMakeWithDegrees(-3.6704803, 40.5023056), time: 1.0)
        }
        else if let mapViewC = mapViewC {
            mapViewC.height = 1.0
            mapViewC.animate(toPosition: MaplyCoordinateMakeWithDegrees(-3.6704803, 40.5023056), time: 1.0)
        }
          
        
    }
    
}

struct OSMViewController_Previews: PreviewProvider {
    static var previews: some View {
        OsmView()
    }
}
