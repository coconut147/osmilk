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
        detailImage.loadImage(bottle: bottle)
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    private var bottle = MilkBottle()
    private var detailImage = ImageView()
    var body: some View {
        
        
        VStack {
            Spacer()
            
            Text(self.bottle.getTitle())
                .font(.largeTitle)
                .fontWeight(.bold)
                
            Text(self.bottle.getEmojitizedVending())
                .font(.largeTitle)
                .fixedSize()
                
                
            Text(self.bottle.identifier)
                .font(.footnote)
                .foregroundColor(Color.gray)
            
            Text(self.bottle.description)
            
            Text("Opening Hours: " + self.bottle.openingHours)

            detailImage
                .frame(width: 400, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .clipped()
            
            
            Button(action: {
                guard let url = URL(string: bottle.website) else { return }
                UIApplication.shared.open(url)
            }) {
                Text(bottle.website)
            }
            
            Spacer()
            Button(action: { self.presentationMode.wrappedValue.dismiss()
                
                
                
            }) {
            Text("Dismiss")
            }
        }
        
    }
    

    
}

struct MilkBottleDetailView_Previews: PreviewProvider {
    
    static let milkBottles = [
        "Sample": MilkBottle(identifier: "1234", coordinate: MaplyCoordinate(x: 49, y: 15), name: "Milchhof Schlumpfbär", description: "One of the best sample Vending machines you have ever seen", owner: "Freddy Inc.", vending: "cheese;milk;meat;sausage;fruit", website: "www.freddy.beer", imageURL: "https://upload.wikimedia.org/wikipedia/commons/0/06/Frischmilchautomat_Tannheim_Gesamtansicht.jpg", openingHours: "9 to five")
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






