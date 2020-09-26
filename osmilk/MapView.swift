//
//  MapView.swift
//  osmilk
//
//  Created by Frederik Heuser on 15.08.20.
//  Copyright © 2020 Frederik Heuser. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    private var mapView = MKMapView(frame: .zero)
    private var poi = MKPointAnnotation()
    func makeUIView(context: Context) -> MKMapView {
           mapView.delegate = context.coordinator
           return mapView
    }
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    func setPoi(title: String, coordinate: CLLocationCoordinate2D)
    {
        
        poi.title = title
        poi.subtitle = "(opened in maps)"
        poi.coordinate = coordinate
        mapView.addAnnotation(poi)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }

    func makeCoordinator() -> mapViewCoordinator {
        mapViewCoordinator(self)
    }
    
    func openInMaps() {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: poi.coordinate, addressDictionary:nil))
        mapItem.name = poi.title
        mapItem.openInMaps(launchOptions: nil)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

class mapViewCoordinator: NSObject, MKMapViewDelegate {
    var parent: MapView

    init(_ parent: MapView) {
        self.parent = parent
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        print(mapView.centerCoordinate)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Tapped - calling openInMaps() now")
        parent.openInMaps()
    }
    
}
