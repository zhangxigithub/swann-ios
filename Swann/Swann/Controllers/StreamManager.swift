//
//  StreamManager.swift
//  Swann
//
//  Created by sid on 14/5/21.
//

import Foundation
import Alamofire

private let StreamListURL = URL(string: "https://hw1ym521u8.execute-api.us-west-2.amazonaws.com/beta/list-stream")!

/*
 This part is not good. Should not use AFError.
 Just keep this demo simple.
 */
typealias FetchStreamsCompletion = (_ response: StreamObject?, _ error: AFError?) -> Void

class StreamManager {

    static let shared = StreamManager()
    func fetchStreams(completion: @escaping FetchStreamsCompletion) {
        
        AF.request(StreamListURL).responseDecodable(of: StreamObject.self) { response in
            completion(response.value, response.error)
        }
    }
}
