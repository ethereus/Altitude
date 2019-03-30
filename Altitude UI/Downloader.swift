//
//  Downloader.swift
//  Altitude UI
//
//  Created by Conor B on 30/03/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

import Foundation
import AppKit

class Downloader {
    
    func Download(downloadURL: URL, downloadedName: String, button: NSButton) {
        
        DispatchQueue.main.async {
            button.isEnabled = false
        }
        
        let filePathURL: URL = FileManager.default.urls(for: .applicationDirectory, in: .localDomainMask).first as URL!
        
        let destinationFileUrl = filePathURL.appendingPathComponent(downloadedName)
        let fileURL = downloadURL
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        let request = URLRequest(url:fileURL)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Got Response
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    if(statusCode != 200) {
                        print("Failed to download. Status code: \(statusCode)")
                        button.title = "ERROR"
                        button.isEnabled = true
                        return;
                    } else {
                        print("Successfully downloaded. Status code: \(statusCode)")
                    }
                }
                
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                    
                    //Do a second check to make sure, there could be issues if it doesn't exist!
                    print("/Applications/\(downloadedName)")
                    print(FileManager.default.fileExists(atPath: "/Applications/\(downloadedName)"))
                    
                    if(FileManager.default.fileExists(atPath: "/Applications/\(downloadedName)")) {
                        //File exists! Woohoo! Send notification when created/downloaded?
                        DispatchQueue.main.async {
                            button.title = "OPEN"
                            button.isEnabled = true
                        }
                    } else {
                        DispatchQueue.main.async {
                            button.title = "ERROR"
                            button.isEnabled = true
                        }
                    }
                } catch (let writeError) {
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                    DispatchQueue.main.async {
                        button.title = "ERROR"
                        button.isEnabled = true
                    }
                }
                
            } else {
                print("Error took place while downloading a file. Error description: %@", error?.localizedDescription as Any);
                DispatchQueue.main.async {
                    button.title = "ERROR"
                    button.isEnabled = true
                }
            }
        }
        task.resume()
    }
}
