//
//  Loader.swift
//  Utils
//
//  Created by Johan Nordberg on 2015-12-14.
//  Copyright © 2015 Santa's Little Helpers. All rights reserved.
//

import Foundation

public enum LoadingError: ErrorType {
    case FileNotFound, UnknownError
}

public func loadResourceAsString(path: String, ofType type: String = "") throws -> String {
    if let filePath = NSBundle.mainBundle().pathForResource(path, ofType: type) {
        let fileContent = try NSString(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)
        return fileContent as String
    } else {
        throw LoadingError.FileNotFound
    }
}

public func loadResourceAsNewlineSeparatedArray(path: String, ofType type: String = "") throws -> Array<String> {
    if let filePath = NSBundle.mainBundle().pathForResource(path, ofType: type) {
        let string = try NSString(contentsOfFile: filePath, encoding: NSUTF8StringEncoding) as String
        return string.characters.split{$0 == "\n"}.map(String.init)
    } else {
        throw LoadingError.FileNotFound
    }
}

public func loadResourceAsData(path: String, ofType type: String = "") throws -> NSData {
    if let filePath = NSBundle.mainBundle().pathForResource(path, ofType: type) {
        if let data = NSData(contentsOfFile: filePath) {
            return data
        } else {
            throw LoadingError.UnknownError
        }
    } else {
        throw LoadingError.FileNotFound
    }
}
