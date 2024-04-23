//
//  LocalFileManager.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 3/2/24.
//

import Foundation
import SwiftUI

final class LocalFileManager {
    
    static let shared = LocalFileManager()
    private init() { }
    
    func saveImage(image: UIImage, imageName: String, folderName:String) {
        createFolderIfNeeded(folderName: folderName)
        guard let data = image.jpegData(compressionQuality: 1.0),
              let url = getImageUrl(imageName: imageName, folderName: folderName) else { return }
        do {
            try data.write(to: url)
        } catch {
            print("Error saving image \(imageName), error: \(error)")
        }
    }
    
    func deleteImage(imageName: String, folderName: String) {
        guard let imageUrl = getImageUrl(imageName: imageName, folderName: folderName),
              FileManager.default.fileExists(atPath: imageUrl.path) else {
            print("Error getting image URL")
            return
        }
        do {
            try FileManager.default.removeItem(at: imageUrl)
        } catch let error {
            print("Error deleting image: \(imageName), error: \(error)")
        }
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard let url = getImageUrl(imageName: imageName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createFolderIfNeeded(folderName: String) {
        guard let folderUrl = getFolderUrl(folderName: folderName) else { return }
        if !FileManager.default.fileExists(atPath: folderUrl.path) {
            do {
                try FileManager.default.createDirectory(at: folderUrl, withIntermediateDirectories: true)
            } catch {
                print("Error creating folder with path: \(folderUrl.path) in File Manager")
            }
        }
    }
    
    private func getFolderUrl(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        return url.appending(path: folderName)
    }
    
    private func getImageUrl(imageName: String, folderName: String) -> URL? {
        guard let folderUrl = getFolderUrl(folderName: folderName) else { return nil }
        return folderUrl.appending(path: imageName + ".jpeg")
    }
}
