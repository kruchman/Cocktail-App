//
//  ImagesService.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 3/2/24.
//

import Foundation
import SwiftUI
import Combine

final class ImagesServiceViewModel: ObservableObject {
    
    @Published var image: UIImage?
    let fileManager = LocalFileManager.shared
    let networkManager = NetworkManager.shared
    let cocktail: Cocktail?
    let ingridient: Ingridient?
    let customCocktail: CustomCocktail?
    let cocktailFolderName: String = "cocktail_images"
    let ingridientFolderName: String = "ingridient_images"
    let garnishFolderName: String = "garnish_images"
    let customCocktailsFolderName: String = "custom_cocktails_images"
    var cancellables = Set<AnyCancellable>()
    
    init(cocktail: Cocktail?, ingridient: Ingridient?, customCocktail: CustomCocktail?) {
        self.cocktail = cocktail
        self.ingridient = ingridient
        self.customCocktail = customCocktail
        getCocktailImage()
        getIngridientImage()
        getCustomCocktailImage()
    }
    
    func getCocktailImage() {
        guard let cocktail else { return }
        if let savedImage = fileManager.getImage(imageName: cocktail.id, folderName: cocktailFolderName) {
            image = savedImage
        } else {
            downloadImage(urlString: cocktail.imageUrlString ?? "", imageName: cocktail.id, folderName: cocktailFolderName)
        }
    }
    
    func getIngridientImage() {
        guard let ingridient else { return }
        if let savedImage = fileManager.getImage(imageName: ingridient.id, folderName: ingridientFolderName) {
            image = savedImage
        } else {
            downloadImage(urlString: ingridient.imageUrlString ?? "", imageName: ingridient.id, folderName: ingridientFolderName)
        }
    }
    
    func getCustomCocktailImage() {
        guard let customCocktail else { return }
        if let savedImage = fileManager.getImage(imageName: customCocktail.id, folderName: customCocktailsFolderName) {
            image = savedImage
        } else {
            return
        }
    }
    
    func saveCustomCocktailImage(image: UIImage, cocktailId: String) {
        self.fileManager.saveImage(image: image, imageName: cocktailId, folderName: customCocktailsFolderName)
    }
    
    func downloadImage(urlString: String, imageName: String, folderName: String) {
            guard let url = URL(string: urlString) else { return }
            networkManager.download(url: url)
                .tryMap { UIImage(data: $0)}
                .sink { _ in
                    print("Completion after downloading Imgae")
                } receiveValue: { [weak self] returnedImage in
                    guard let image = returnedImage, let self = self else {
                        return
                    }
                    self.image = image
                    self.fileManager.saveImage(image: image, imageName: imageName, folderName: folderName)
                }
                .store(in: &cancellables)
    }
    
}
