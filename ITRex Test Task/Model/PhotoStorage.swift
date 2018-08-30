//
//  PhotoStorage.swift
//  ITRex Test Task
//
//  Created by Maxim Shirko on 30.08.2018.
//  Copyright © 2018 com.MaximShirko. All rights reserved.
//

import UIKit

class PhotoStorage: NSObject {
    
    static func storePhotos(photos: [MyPhoto]) {
        let documents = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileName = "photos.data"
        let fileURL = documents.appendingPathComponent(fileName)
        do {
            let data = try PropertyListEncoder().encode(photos)
            try? data.write(to : fileURL , options : .noFileProtection)
        } catch {
            print("Save Failed")
        }
    }
    
    static func loadPhotos() -> [MyPhoto]? {
        let documents = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileName = "photos.data"
        let fileURL = documents.appendingPathComponent(fileName)
        do {
            let data = try Data(contentsOf: fileURL)
            return try PropertyListDecoder().decode([MyPhoto].self, from: data)
        } catch {
            print(error)
            return [MyPhoto]()
        }
    }
    
}
