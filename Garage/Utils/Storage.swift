//
//  Storage.swift
//  Garage
//
//  Created by Illia Romanenko on 16.07.23.
//

import Foundation

// https://medium.com/@sdrzn/swift-4-codable-lets-make-things-even-easier-c793b6cf29e1
public class Storage {
    
    fileprivate init() { }
    
    enum Directory {
        // Only documents and other data that is user-generated, or that cannot otherwise be recreated by your application, should be stored in the <Application_Home>/Documents directory and will be automatically backed up by iCloud.
        case documents
        
        // Data that can be downloaded again or regenerated should be stored in the <Application_Home>/Library/Caches directory. Examples of files you should put in the Caches directory include database cache files and downloadable content, such as that used by magazine, newspaper, and map applications.
        case caches
    }
    
    enum FileType: String {
        case backup = "backup.ggd"
    }
    
    /// Returns URL constructed from specified directory
    static fileprivate func getURL(for directory: Directory) -> URL {
        var searchPathDirectory: FileManager.SearchPathDirectory
        
        switch directory {
        case .documents:
            searchPathDirectory = .documentDirectory
        case .caches:
            searchPathDirectory = .cachesDirectory
        }
        
        if let url = FileManager.default.urls(for: searchPathDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Could not create URL for specified directory!")
        }
    }
    
    
    /// Store an encodable struct to the specified directory on disk
    ///
    /// - Parameters:
    ///   - object: the encodable struct to store
    ///   - directory: where to store the struct
    ///   - fileName: what to name the file where the struct data will be stored
    static func store<T: Encodable>(_ object: T, to directory: Directory, as fileName: FileType) {
        let url = getURL(for: directory).appendingPathComponent(fileName.rawValue, isDirectory: false)
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    /// Retrieve and convert a struct from a file on disk
    ///
    /// - Parameters:
    ///   - fileName: name of the file where struct data is stored
    ///   - directory: directory where struct data is stored
    ///   - type: struct type (i.e. Message.self)
    /// - Returns: decoded struct model(s) of data
    static func retrieve<T: Decodable>(_ fileName: FileType, from directory: Directory, as type: T.Type) -> T? {
        let url = getURL(for: directory).appendingPathComponent(fileName.rawValue, isDirectory: false)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            return nil
        }
        
        if let data = FileManager.default.contents(atPath: url.path) {
            let decoder = JSONDecoder()
            
            let model = try? decoder.decode(type, from: data)
            return model
        }
        return nil
    }
    
    static func retrieve<T: Decodable>(_ url: URL, as type: T.Type) -> T? {
        
        if !FileManager.default.fileExists(atPath: url.path) {
            return nil
        }
        
        if let data = FileManager.default.contents(atPath: url.path) {
            let decoder = JSONDecoder()
            
            let model = try? decoder.decode(type, from: data)
            return model
        }
        return nil
    }
    
    static func url(for fileName: FileType, from directory: Directory) -> URL? {
        let url = getURL(for: directory).appendingPathComponent(fileName.rawValue, isDirectory: false)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            return nil
        }
        
        return url
    }
    
    /// Remove all files at specified directory
    static func clear(_ directory: Directory) {
        let url = getURL(for: directory)
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            for fileUrl in contents {
                try FileManager.default.removeItem(at: fileUrl)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    /// Remove specified file from specified directory
    static func remove(_ fileName: FileType, from directory: Directory) {
        let url = getURL(for: directory).appendingPathComponent(fileName.rawValue, isDirectory: false)
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    /// Returns BOOL indicating whether file exists at specified directory with specified file name
    static func fileExists(_ fileName: FileType, in directory: Directory) -> Bool {
        let url = getURL(for: directory).appendingPathComponent(fileName.rawValue, isDirectory: false)
        return FileManager.default.fileExists(atPath: url.path)
    }
}
