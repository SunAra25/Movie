//
//  FileStorage.swift
//  Moolog
//
//  Created by 여성은 on 10/12/24.
//

import UIKit

import Kingfisher

class FileStorage {
    @MainActor
    static func saveImageToDocument(image: String, filename: String) {
        var imageView = UIImageView()
        if let imageURL = URL(string: image) {
            imageView.kf.setImage(with: imageURL)
        }
        
        guard let documentDirectory = FileManager.default
            .urls(
                for: .documentDirectory,
                in: .userDomainMask).first else { return }
        print("documentDirectory:", documentDirectory)
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        print("fileURL:", fileURL)
       
        guard let data = imageView.image?.jpegData(compressionQuality: 0.5) else {
            return
        }
        
        do {
            try data.write(to: fileURL)
        } catch {
            print("file save error", error)
        }
    }
    
    static func loadImageToDocument(filename: String) -> UIImage? {
        
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return nil }
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        if #available(iOS 16.0, *) {
            if FileManager.default.fileExists(atPath: fileURL.path()) {
                return UIImage(contentsOfFile: fileURL.path())
            } else {
                return UIImage(systemName: "star.fill")
            }
        } else {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                return UIImage(contentsOfFile: fileURL.path)
            } else {
                return UIImage(systemName: "star.fill")
            }
        }
    }
    
    static func removeImageFromDocument(filename: String) {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        if #available(iOS 16.0, *) {
            if FileManager.default.fileExists(atPath: fileURL.path()) {
                do {
                    try FileManager.default.removeItem(atPath: fileURL.path())
                } catch {
                    print("file remove error", error)
                }
            } else {
                print("file no exist")
            }
        } else {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    try FileManager.default.removeItem(atPath: fileURL.path)
                } catch {
                    print("file remove error", error)
                }
            } else {
                print("file no exist")
            }
        }
    }
}
