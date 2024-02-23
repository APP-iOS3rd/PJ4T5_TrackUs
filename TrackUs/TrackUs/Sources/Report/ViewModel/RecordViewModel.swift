//
//  RecordViewModel.swift
//  TrackUs
//
//  Created by 박선구 on 2/19/24.
//

import Foundation
import SwiftUI

class ImageViewModel: ObservableObject {
    @Published var image: UIImage?

    private var imageCache: NSCache<NSString, UIImage>?

    init(urlString: String?) {
        loadImage(urlString: urlString)
    }

    private func loadImage(urlString: String?) {
        guard let urlString = urlString else { return }

        if let imageFromCache = getImageFromCache(from: urlString) {
            self.image = imageFromCache
            return
        }

        loadImageFromURL(urlString: urlString)
    }

    private func loadImageFromURL(urlString: String) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print(error ?? "unknown error")
                return
            }

            guard let data = data else {
                print("No data found")
                return
            }

            DispatchQueue.main.async { [weak self] in
                guard let loadedImage = UIImage(data: data) else { return }
                self?.image = loadedImage
                self?.setImageCache(image: loadedImage, key: urlString)
            }
        }.resume()
    }

    private func setImageCache(image: UIImage, key: String) {
        imageCache?.setObject(image, forKey: key as NSString)
    }

    private func getImageFromCache(from key: String) -> UIImage? {
        return imageCache?.object(forKey: key as NSString) as? UIImage
    }
}

struct ImageView: View {
    @ObservedObject private var imageViewModel: ImageViewModel
    
    init(urlString: String?) {
        imageViewModel = ImageViewModel(urlString: urlString)
    }
    
    var body: some View {
        Image(uiImage: imageViewModel.image ?? UIImage())
            .resizable()
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(urlString: " ")
    }
}
//#Preview {
//    RecordViewModel()
//}
