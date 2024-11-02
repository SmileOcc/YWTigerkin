//
//  YWSessionDownFile.swift
//  YWTigerkin
//
//  Created by odd on 11/2/24.
//

import UIKit

class YWSessionDownFile: NSObject {

    static func downloadFile(from url: URL, toPath path: String) {
        let session = URLSession.shared

        let downloadTask = session.downloadTask(with: url) { location, _, error in
            if let error = error {
                print("Error downloading file: \(error)")
                return
            }

            guard let location = location else {
                print("Downloaded file location is nil")
                return
            }

            do {
                try FileManager.default.moveItem(at: location, to: URL(fileURLWithPath: path))
            } catch {
                print("Error moving file to final destination: \(error)")
            }
        }

        downloadTask.resume()
    }
}
