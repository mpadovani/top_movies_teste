//
//  Service.swift
//  top_games
//
//  Created by Mateus Padovani on 09/03/19.
//  Copyright © 2019 Mateus Padovani. All rights reserved.
//

import Foundation
import Alamofire
import CodableAlamofire

protocol Service: class {
    var configuration: ServiceConfiguration { get }
    var endPoint: String { get }
}

extension Service {
    var configuration: ServiceConfiguration {
        return .default
    }
    
    typealias ModelResponse<T> = (success: (T) -> Void, failure: (Error) -> Void, completion: () -> Void)
    typealias EmptyResponse = (success: () -> Void, failure: (Error) -> Void, completion: () -> Void)
    
    var endPointURL: URL {
        return configuration.baseURL.appendingPathComponent(endPoint)
    }
    
    @discardableResult
    func request<T: Decodable>(_ url: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, keyPath: String? = nil, response: ModelResponse<T>) -> DataRequest {
        return Alamofire.request(url,
                                 method: method,
                                 parameters: parameters,
                                 encoding: encoding,
                                 headers: headers)
            .validate()
            .responseDecodableObject(keyPath: keyPath,
                                     decoder: configuration.decoder,
                                     completionHandler: completionHandler(for: response))
    }
    
    @discardableResult
    func request(_ url: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, response: EmptyResponse) -> DataRequest {
        return Alamofire.request(url,
                                 method: method,
                                 parameters: parameters,
                                 encoding: encoding,
                                 headers: headers)
            .validate()
            .responseData(completionHandler: completionHandler(for: response))
    }
    
    func completionHandler(for response: EmptyResponse, shouldLogData: Bool = true) -> (DataResponse<Data>) -> Void {
        return { [weak self] dataResponse in
            if shouldLogData {
                self?.log(data: dataResponse.data)
            }
            switch dataResponse.result {
            case .success:
                response.success()
                break
            case .failure(let error):
                response.failure(error)
                break
            }
            response.completion()
        }
    }
    
    func completionHandler<T : Decodable>(for response: ModelResponse<T>, shouldLogData: Bool = true) -> (DataResponse<T>) -> Void {
        return { [weak self] dataResponse in
            if shouldLogData {
                self?.log(data: dataResponse.data)
            }
            switch dataResponse.result {
            case .success(let value):
                response.success(value)
                break
            case .failure(let error):
                if let data = dataResponse.data,
                    let configuration = self?.configuration,
                    let errorsResponse = try? configuration.decoder.decode(ErrorsResponse.self, from: data) {
                    response.failure(errorsResponse)
                } else {
                    response.failure(error)
                }
                break
            }
            response.completion()
        }
    }
    
    private func log(data: Data?) {
        guard let data = data, let string = String(data: data, encoding: .utf8) else { return }
        print(string)
    }
}
