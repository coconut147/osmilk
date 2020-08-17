//
//  OSMViewController.swift
//  osmilk
//
//  Created by Frederik Heuser on 15.08.20.
//  Copyright © 2020 Frederik Heuser. All rights reserved.
//
import UIKit
import MapKit
import SwiftUI
import SwiftOverpassAPI
import CoreLocation


struct OsmViewControllerRepresentable: UIViewControllerRepresentable {
    private var OsmController = OSMViewController()
    func makeUIViewController(context: Context) ->MaplyViewController {
        return OsmController
    }
    
    func updateUIViewController(_ uiViewController: MaplyViewController, context: Context) {
        
    }
    public func QueryVendingMachines() {
       OsmController.QueryVendingMachines()
    }
    
    
}

struct OsmView: View {
    @State private var isPresented = false
    private var OsmMapView = OsmViewControllerRepresentable()
    private var TextName = Text("Milchhäusla")
    private var TextVending = Text("🥛🥓🍗🍯🧀🥚🥔")
    private var TextID = Text("00420815")

    var body: some View {
        VStack {
            OsmMapView
            
            
            HStack {
                Spacer()
                Button(action:
                {
                    self.OsmMapView.QueryVendingMachines()
                }
                ) {
                        Text("Refresh  ")
                }
            }
            HStack {
                    Text("Name:")
                    TextName
                    Spacer()
                }
                HStack {
                    Text("Vending:")
                    TextVending
                    Spacer()
                }
                HStack {
                    Text("ID:")
                    TextID
                    Spacer()
            }
        }
    }
        
        
    
}

class OSMViewController : MaplyViewController, MaplyViewControllerDelegate {
    private var theViewC: MaplyBaseViewController?
    private var boundingBox = OPBoundingBox(
    minLatitude: 47,
    minLongitude: 5,
    maxLatitude: 47.00001,
    maxLongitude: 5.00001)
    
    
    func maplyViewController(_ viewC: MaplyViewController, didTapAt coord: MaplyCoordinate) {
            theViewC?.clearAnnotations()
    }
    
    func maplyViewController(_ viewC: MaplyViewController, didStopMoving corners: UnsafeMutablePointer<MaplyCoordinate>, userMotion: Bool) {
    
                
                
        boundingBox = OPBoundingBox(
         minLatitude: Double(corners[2].y * 180 / .pi),
         minLongitude: Double((corners[0].x * 180 / .pi)),
         maxLatitude: Double(corners[0].y * 180 / .pi),
         maxLongitude: Double((corners[1].x * 180 / .pi)))
            
        //An array of length 4 containing the corners of the view space (lower left, lower right, upper right, upper left). If any of those corners does not intersect the map (think zoomed out), its values are set to MAXFLOAT.

    }
    
    
    
    
    /*
     *  Handle a tap on a milkbottle
    */
    private func handleSelection(selectedObject: NSObject) {
        if let selectedObject = selectedObject as? MaplyScreenMarker {
            var selectedBottle = MilkBottle()
            for bottle in MilkBottles {
                if(bottle.identifier == selectedObject.uniqueID) {
                    selectedBottle = bottle
                    break;
                }
            }
            
            let title = selectedBottle.getTitle()

            let subtitle = selectedBottle.getEmojitizedVending()
            
            
            
            addAnnotationWithTitle(title: title, subtitle: subtitle, loc: selectedObject.loc)
            
            // Now Update detailview
            
            
        }
    }
      
    // This is the version for a map
    func maplyViewController(_ viewC: MaplyViewController, didSelect selectedObj: NSObject) {
        handleSelection(selectedObject: selectedObj)
    }

    
    private var overpassClient: OPClient? // The client for requesting/decoding Overpass data
    private var MilkBottles = [MilkBottle]()
    
    public func QueryVendingMachines() {
        
        MilkBottles.removeAll()
        do {
            let query = try OPQueryBuilder()
                .setTimeOut(180) //1
                .setElementTypes([.node]) //2
                .addTagFilter(key: "amenity", value: "vending_machine", exactMatch: false) //3
                .addTagFilter(key: "vending", value: "milk", exactMatch: false) //4
                .setBoundingBox(boundingBox) //6
                .setOutputType(.center) //7
                .buildQueryString() //8
                
            
            overpassClient = OPClient()
            //1
            overpassClient!.endpoint = .main//2
            debugPrint("Start Fetching with Overpass API")
            //3
            overpassClient?.fetchElements(query: query) { result in
                debugPrint("Finished Fetch")
                debugPrint(result)
                switch result {
                    case .failure(let error):
                        debugPrint("Error")
                        debugPrint(error.localizedDescription)
                    case .success(let elements):
                        debugPrint("Found " + String(elements.count) + " vending machines")

                        for element in elements {
                            var newMilkBottle = MilkBottle()
                            
                            debugPrint("Examining element " + String(element.value.id) )
                            
                            // Save Coordinates
                            switch element.value.geometry {
                            case .center(let coordinate):
                                let Lat = Float(coordinate.latitude)
                                let Lon = Float(coordinate.longitude)
                                newMilkBottle.coordinate = MaplyCoordinateMakeWithDegrees(Lon,Lat);
                            case .polyline(_):
                                break
                            case .polygon(_):
                                break
                            case .multiPolygon(_):
                                break
                            case .multiPolyline(_):
                                break
                            case .none:
                                break
                            }
                            
                            // ID
                            newMilkBottle.identifier = String(element.value.id);

                            // Now let's examine interesting tags
                            for tag in element.value.tags {
                                switch tag.key {
                                case "name":
                                    newMilkBottle.name = tag.value
                                case "operator":
                                    newMilkBottle.owner = tag.value
                                case "vending":
                                    newMilkBottle.vending = tag.value
                                case "website":
                                    newMilkBottle.website = tag.value
                                case "contact:website":
                                    if(newMilkBottle.website == "") {
                                        newMilkBottle.website = tag.value
                                    }
                                case "description":
                                    newMilkBottle.description = tag.value
                                case "opening_hours":
                                    newMilkBottle.openingHours = tag.value
                                default:
                                    debugPrint(tag.key + "=" + tag.value)
                                }
                            }
                            
                            
                            // Add to list
                            self.MilkBottles.append(newMilkBottle)

                            
                            
                        }
                    // Now let's add some milkbottles
                    let icon = UIImage(named: "Milk.png")

                        let markers = self.MilkBottles.map { Bottle -> MaplyScreenMarker in
                        let marker = MaplyScreenMarker()
                        marker.image = icon
                        marker.loc = Bottle.coordinate
                        marker.size = CGSize(width: 40,height: 40)
                        
                        marker.uniqueID = Bottle.identifier
                        
                        return marker
                    }

                        self.theViewC?.addScreenMarkers(markers, desc: nil)
                    
                    
                }
            }
            

        } catch {

            debugPrint(error.localizedDescription)
        }

        
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

        // we'll need this layer in a second
        let layer: MaplyQuadImageTilesLayer


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
        
        
    

        // start up over Madrid, center of the old-world
        if let globeViewC = globeViewC {
            globeViewC.height = 0.8
            globeViewC.animate(toPosition: MaplyCoordinateMakeWithDegrees(-3.6704803, 40.5023056), time: 1.0)
        }
        else if let mapViewC = mapViewC {
            mapViewC.height = 0.001
            mapViewC.animate(toPosition: MaplyCoordinateMakeWithDegrees(11.266090, 49.625349), time: 1.0)
        }
        // 49.625349, 11.266090
       
        
        QueryVendingMachines()
        
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