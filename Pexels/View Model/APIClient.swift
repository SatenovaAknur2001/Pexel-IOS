//
//  APIClient.swift
//  Pexels
//
//  Created by Kenes Yerassyl on 8/25/20.
//  Copyright © 2020 Tinker Tech. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
    case trace = "TRACE"
    case connect = "CONNECT"
}

struct HTTPHeader {
    let field: String
    let value: String
}

class APIRequest {
    let method: HTTPMethod
    let path: String
    var queryItems: [URLQueryItem]?
    var headers: [HTTPHeader]?
    var body: Data?

    init(method: HTTPMethod, path: String) {
        self.method = method
        self.path = path
    }
}

enum APIError: Error {
    case invalidURL
    case requestFailed
}

struct APIClient {

    typealias APIClientCompletion = (HTTPURLResponse?, Data?, APIError?) -> Void

    private let session = URLSession.shared
    private let baseURL = URL(string: "https://api.pexels.com/v1")!

    func request(_ request: APIRequest, _ completion: @escaping APIClientCompletion) {

        var urlComponents = URLComponents()
        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.path = baseURL.path
        urlComponents.queryItems = request.queryItems

        guard let url = urlComponents.url?.appendingPathComponent(request.path) else {
            completion(nil, nil, .invalidURL)
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        request.headers?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.field) }
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async { completion(nil, nil, .requestFailed) }
                return
            }
            DispatchQueue.main.async { completion(httpResponse, data, nil) }
        }
        task.resume()
    }
}
