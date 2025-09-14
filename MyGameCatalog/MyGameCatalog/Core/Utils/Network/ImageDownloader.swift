//
//  ImageDownloader.swift
//  MyGameCatalog
//
//  Created by Yudi Marta on 03/03/25.
//

import Foundation
import UIKit

class ImageDownloader {
  func downloadImage(url: URL) async throws -> UIImage {
    async let imageData: Data = try Data(contentsOf: url)
    return UIImage(data: try await imageData)!
  }
}
