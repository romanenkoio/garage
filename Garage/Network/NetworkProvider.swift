//
//  NetworkProvider.swift
//  Garage
//
//  Created by Illia Romanenko on 8.06.23.
//

import Foundation
import Moya

protocol NetworkManagerProtocol {
    func request<Target: TargetType, Model: Decodable>(_ target: Target, model: [Model].Type) async throws -> [Model]
    func request<Target: TargetType, Model: Decodable>(_ target: Target, model: Model.Type) async throws -> Model
    func request<Target: TargetType>(_ target: Target) async throws
}

final class NetworkManager: ObservableObject, NetworkManagerProtocol {
    static let sh: NetworkManagerProtocol = NetworkManager()

    private init() {}

    private lazy var provider: MoyaProvider<MultiTarget> = {
        var plugins: [PluginType] = [networkPlugin]
        return MoyaProvider<MultiTarget>(endpointClosure: endpointClosure, plugins: plugins, trackInflights: true)
    }()

    private let endpointClosure = { (target: MultiTarget) -> Endpoint in
        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
        return defaultEndpoint
    }

    private func jsonDataFormatter(_ data: Data) -> String {
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: data)
            let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            guard let result = String(data: prettyData, encoding: String.Encoding.utf8) else {
                return String(decoding: data, as: UTF8.self)
            }
            return result
        } catch {
            return String(decoding: data, as: UTF8.self)
        }
    }

    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    private lazy var networkPlugin: NetworkLoggerPlugin = {
        let formatter = NetworkLoggerPlugin.Configuration.Formatter(
            requestData: jsonDataFormatter,
            responseData: jsonDataFormatter)

        let configuration = NetworkLoggerPlugin.Configuration(
            formatter: formatter,
            output: NetworkLoggerPlugin.Configuration.defaultOutput,
            logOptions: .verbose
        )
        return NetworkLoggerPlugin(configuration: configuration)
    }()

    func request<Target: TargetType, Model: Decodable>(_ target: Target, model: [Model].Type) async throws -> [Model] {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(MultiTarget(target)) { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(response):
                    do {
                        guard let _ = response.request else {
                            fatalError("guard failure handling has not been implemented")
                        }
                        let items = try self.decoder.decode(model, from: response.data)
                        continuation.resume(returning: items)
                    } catch let error {
                        continuation.resume(throwing: error)
                    }
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

func request<Target: TargetType, Model: Decodable>(_ target: Target, model: Model.Type) async throws -> Model {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(MultiTarget(target)) { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(response):
                    do {
                        guard let _ = response.request else {
                            fatalError("guard failure handling has not been implemented")
                        }
                        let items = try self.decoder.decode(model, from: response.data)
                        continuation.resume(returning: items)
                    } catch let error {
                        continuation.resume(throwing: error)
                    }
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func request<Target: TargetType>(_ target: Target) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(MultiTarget(target)) { result in
                switch result {
                case let .success(response):

                        guard let _ = response.request else {
                            fatalError("guard failure handling has not been implemented")
                        }
                        continuation.resume()
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
