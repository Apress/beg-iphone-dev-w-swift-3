//
//  TinyPixDocument.swift
//  TinyPix
//
//  Created by Molly Maskrey on 7/20/16.
//  Copyright © 2016 Apress Inc. All rights reserved.
//

import UIKit

class TinyPixDocument: UIDocument {
    private var bitmap: [UInt8]
    
    override init(fileURL: URL) {
        bitmap = [0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80]
        super.init(fileURL: fileURL)
    }
    
    func stateAt(row: Int, column: Int) -> Bool {
        let rowByte = bitmap[row]
        let result = UInt8(1 << column) & rowByte
        return result != 0
    }
    
    func setState(_ state: Bool, atRow row: Int, column: Int) {
            var rowByte = bitmap[row]
            if state {
            rowByte |= UInt8(1 << column)
        } else {
            rowByte &= ~UInt8(1 << column)
        }
        bitmap[row] = rowByte
    }
    
    func toggleStateAt(row: Int, column: Int) {
        let state = stateAt(row: row, column: column)
        setState(!state, atRow: row, column: column)
    }
    
    override func contents(forType typeName: String) throws -> Any {
        print("Saving document to URL \(fileURL)")
        let bitmapData = Data(bytes: UnsafePointer<UInt8>(bitmap), count: bitmap.count)
        return bitmapData as AnyObject
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        print("Loading document from URL \(fileURL)")
        if let bitmapData = contents as? Data {
            (bitmapData as NSData).getBytes(UnsafeMutablePointer<UInt8>(mutating: bitmap), length: bitmap.count)
        }
    }
}
