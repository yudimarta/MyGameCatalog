//
//  GetGamesRemoteDataSource.swift
//  Home
//
//  Created by Yudi Marta on 13/05/25.
//

import Core
import Combine
import Alamofire
import Foundation

public struct GetGamesRemoteDataSource : DataSource {
    public typealias Request = Any
    
    public typealias Response = [GameModuleResponse]
    
    private let _endpoint: String
    
    public init(endpoint: String) {
        _endpoint = endpoint
    }
    
    public func execute(request: Any?) -> AnyPublisher<[GameModuleResponse], Error> {
        return Future<[GameModuleResponse], Error> { completion in
          if let url = URL(string: _endpoint) {
            AF.request(url)
              .validate()
              .responseDecodable(of: GameModuleResponses.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value.games))
                case .failure:
                  completion(.failure(URLError.invalidResponse))
                }
              }
          }
        }.eraseToAnyPublisher()
    }
}
