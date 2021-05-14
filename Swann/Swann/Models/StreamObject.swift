//
//  StreamObject.swift
//  Swann
//
//  Created by sid on 14/5/21.
//

import Foundation

class StreamObject: Decodable {
    let screen1: URL?
    let screen2: URL?
    let screen3: URL?

    var streams: [URL] {
        var result = [URL]()
        if screen1 != nil {
            result.append(screen1!)
        }
        if screen2 != nil {
            result.append(screen2!)
        }
        if screen3 != nil {
            result.append(screen3!)
        }
        return result
    }
}
