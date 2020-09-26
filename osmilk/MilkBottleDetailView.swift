//
//  MilkBottleDetailView.swift
//  osmilk
//
//  Created by Frederik Heuser on 17.08.20.
//  Copyright © 2020 Frederik Heuser. All rights reserved.
//

import SwiftUI
import MapKit

struct MilkBottleDetailView: View {
    internal init(bottle: MilkBottle) {
        self.bottle = bottle
        detailImage.loadImage(bottle: bottle)
        detailMap.setPoi(title: bottle.getTitle(), coordinate: bottle.getCoordinate())
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    private var bottle = MilkBottle()
    private var detailImage = ImageView()
    private var detailMap = MapView()
    var body: some View {
        
        
        VStack {
            Spacer()
            Text(self.bottle.getTitle())
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                
            Text(self.bottle.getEmojitizedVending())
                .font(.largeTitle)
                
                
            Text("ID:" + self.bottle.identifier)
                .font(.footnote)
                .foregroundColor(Color.gray)
            
            Text(self.bottle.description)
                .padding(.horizontal, 5.0)
            
            Text("Opening Hours: " + self.bottle.openingHours)

            detailMap
                .frame(height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            Button(action: {
                guard let url = URL(string: bottle.website) else { return }
                UIApplication.shared.open(url)
            }) {
                Text(bottle.website)
            }
            
            
            
            detailImage
                .frame(width: 400, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .clipped()
            
            Button(action: { self.presentationMode.wrappedValue.dismiss()
                
                
                
            }) {
            Text("Close")
            }
            
        }
        
    }
    

    
}

struct MilkBottleDetailView_Previews: PreviewProvider {
    
    static let milkBottles = [
        "Sample": MilkBottle(identifier: "1234", coordinate: MaplyCoordinate(x: 0.1, y: 0.1), name: "Milchhof Schlumpfbär", description: "One of the best sample Vending machines you have ever seen.\nVending milk, butter, and apples. This is such a good vending machine, you have to see it.", owner: "Freddy Inc.", vending: "cheese;milk;meat;sausage;fruit", website: "www.freddy.beer", imageURL: "https://upload.wikimedia.org/wikipedia/commons/0/06/Frischmilchautomat_Tannheim_Gesamtansicht.jpg", openingHours: "9 to five")
    ]
    
    static var previews: some View {
        MilkBottleDetailView(bottle: milkBottles["Sample"] ?? MilkBottle())
    }
}




struct ImageView: UIViewRepresentable {
    private var imageView = UIImageView()
    func updateUIView(_ uiView: UIImageView, context: Context) {

    }
    

    public func loadImage(bottle: MilkBottle) {
        if bottle.imageURL != "" {
            let url = URL(string: bottle.imageURL)
            if url != nil {
                downloadImage(from: url!)
            }
               
        }

    }
    

    func makeUIView(context: UIViewRepresentableContext<ImageView>) -> UIImageView {
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }


    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    private func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { [self] in
                self.imageView.image = UIImage(data: data)
                self.imageView.updateFocusIfNeeded()
            }
        }
    }
    
}






