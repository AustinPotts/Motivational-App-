//
//  BundleDecoding.swift
//  MotivateMe
//
//  Created by Austin Potts on 12/7/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation


extension Bundle {
    func decode<T: Decodable>( _ type: T.Type, from file: String ) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
        fatalError("Failed to locate file \(file)")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("failed to load \(file) in app bundle.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file)")
        }
        return loaded
    }
}
