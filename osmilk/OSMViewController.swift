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

class OSMViewController : MaplyViewController, MaplyViewControllerDelegate {
    private var theViewC: MaplyBaseViewController?
    
    func maplyViewController(_ viewC: MaplyViewController, didTapAt coord: MaplyCoordinate) {
        let subtitle = NSString(format: "(%.2fN, %.2fE)", coord.y*57.296,coord.x*57.296) as String
        addAnnotationWithTitle(title: "Tap!", subtitle: subtitle, loc: coord)
    }
    
    // Unified method to handle the selection
    private func handleSelection(selectedObject: NSObject) {
        if let selectedObject = selectedObject as? MaplyVectorObject {
            let loc = selectedObject.centroid()
            if loc.x != kMaplyNullCoordinate.x {
                let title = "Selected:"
                let subtitle = selectedObject.userObject as! String
                addAnnotationWithTitle(title: title, subtitle: subtitle, loc: loc)
            }
        }
        else if let selectedObject = selectedObject as? MaplyScreenMarker {
            let title = "Selected:"
            let subtitle = "Screen Marker"
            addAnnotationWithTitle(title: title, subtitle: subtitle, loc: selectedObject.loc)
        }
    }
      
    // This is the version for a map
    func maplyViewController(_ viewC: MaplyViewController, didSelect selectedObj: NSObject) {
        handleSelection(selectedObject: selectedObj)
    }
    
    private func addMilk() {
        let capitals = [
            MaplyCoordinateMakeWithDegrees(-122.4192,37.7793),
            MaplyCoordinateMakeWithDegrees(-77.036667, 38.895111),
            MaplyCoordinateMakeWithDegrees(120.966667, 14.583333),
            MaplyCoordinateMakeWithDegrees(55.75, 37.616667),
            MaplyCoordinateMakeWithDegrees(-0.1275, 51.507222),
            MaplyCoordinateMakeWithDegrees(-66.916667, 10.5),
            MaplyCoordinateMakeWithDegrees(139.6917, 35.689506),
            MaplyCoordinateMakeWithDegrees(166.666667, -77.85),
            MaplyCoordinateMakeWithDegrees(-58.383333, -34.6),
            MaplyCoordinateMakeWithDegrees(-74.075833, 4.598056),
            MaplyCoordinateMakeWithDegrees(-79.516667, 8.983333),
            MaplyCoordinateMakeWithDegrees(-5.7043173, 40.9634332)
        ]

        let icon = UIImage(named: "Milk.png")

        let markers = capitals.map { cap -> MaplyScreenMarker in
            let marker = MaplyScreenMarker()
            marker.image = icon
            marker.loc = cap
            marker.size = CGSize(width: 40,height: 40)
            return marker
        }

        theViewC?.addScreenMarkers(markers, desc: nil)
    }
    
    private func addAnnotationWithTitle(title: String, subtitle: String, loc:MaplyCoordinate) {
        theViewC?.clearAnnotations()

        let a = MaplyAnnotation()
        a.title = title
        a.subTitle = subtitle

        theViewC?.addAnnotation(a, forPoint: loc, offset: CGPoint.zero)
    }
    
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

        
        // add the capability to use the local tiles or remote tiles
        let useLocalTiles = false

        // we'll need this layer in a second
        let layer: MaplyQuadImageTilesLayer

        if useLocalTiles {
            guard let tileSource = MaplyMBTileSource(mbTiles: "geography-class_medres") else {
                // can't load local tile set
            }
            layer = MaplyQuadImageTilesLayer(tileSource: tileSource)!
        }
        else {
            // Because this is a remote tile set, we'll want a cache directory
            let baseCacheDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
            let tilesCacheDir = "\(baseCacheDir)/stamentiles/"
            let maxZoom = Int32(18)

            // Stamen Terrain Tiles, courtesy of Stamen Design under the Creative Commons Attribution License.
            // Data by OpenStreetMap under the Open Data Commons Open Database License.
            guard let tileSource = MaplyRemoteTileSource(
                    baseURL: "http://tile.stamen.com/terrain/",
                    ext: "png",
                    minZoom: 0,
                    maxZoom: maxZoom) else {
                // can't create remote tile source
                return
            }
            tileSource.cacheDir = tilesCacheDir
            layer = MaplyQuadImageTilesLayer(tileSource: tileSource)!
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
          
        addMilk()
        
        if let mapViewC = mapViewC {
            mapViewC.delegate = self
        }

    }
    
}

struct OSMViewController_Previews: PreviewProvider {
    static var previews: some View {
        OsmView()
    }
}
