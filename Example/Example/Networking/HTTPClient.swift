//
//  HttpClient.swift
//  JedlixSDK
//
//  Copyright © 2022 Jedlix. All rights reserved.
//

import Foundation
import JedlixSDK

class HTTPClient {
    private struct Path {
        static let base = "/api/v1"
        static let vehicles = "/users/%@/vehicles"
        static let vehicle = "/users/%@/vehicles/%@"
        static let chargingLocations = "/users/%@/charging-locations"
        static let chargingLocation = "/users/%@/charging-locations/%@"
        static let chargers = "/users/%@/chargers"
        static let charger = "/users/%@/charging-locations/%@/chargers/%@"
        static let connectSessions = "/users/%@/connect-sessions"
    }
    
    private let userIdentifier: String
    
    required init(userIdentifier: String) {
        self.userIdentifier = userIdentifier
    }
    
    func getVehicles() async throws -> [Vehicle] {
        var request = try await request(with: Path.vehicles, parameters: userIdentifier)
        request.httpMethod = "GET"
        let response = try await URLSession.shared.response(for: request, delegate: nil)
        let data = response.0
        do {
            return try JSONDecoder().decode([Vehicle].self, from: data)
        } catch {
            let errorResponse = try JSONDecoder().decode(HTTPErrorResponse.self, from: data)
            throw HTTPError.errorResponse(detail: errorResponse.detail)
        }
    }
    
    func removeVehicle(_ vehicle: Vehicle) async throws {
        var request = try await request(with: Path.vehicle, parameters: userIdentifier, vehicle.id)
        request.httpMethod = "DELETE"
        let response = try await URLSession.shared.response(for: request, delegate: nil)
        let data = response.0
        let urlResponse = response.1
        guard (urlResponse as? HTTPURLResponse)?.statusCode == 204 else {
            throw try HTTPError(with: data)
        }
    }
    
    func getChargingLocations() async throws -> [ChargingLocation] {
        var request = try await request(with: Path.chargingLocations, parameters: userIdentifier)
        request.httpMethod = "GET"
        let response = try await URLSession.shared.response(for: request, delegate: nil)
        let data = response.0
        do {
            return try JSONDecoder().decode([ChargingLocation].self, from: data)
        } catch {
            let errorResponse = try JSONDecoder().decode(HTTPErrorResponse.self, from: data)
            throw HTTPError.errorResponse(detail: errorResponse.detail)
        }
    }
    
    func getChargers() async throws -> [Charger] {
        var request = try await request(with: Path.chargers, parameters: userIdentifier)
        request.httpMethod = "GET"
        let response = try await URLSession.shared.response(for: request, delegate: nil)
        let data = response.0
        do {
            return try JSONDecoder().decode([Charger].self, from: data)
        } catch {
            let errorResponse = try JSONDecoder().decode(HTTPErrorResponse.self, from: data)
            throw HTTPError.errorResponse(detail: errorResponse.detail)
        }
    }
    
    func removeCharger(_ charger: Charger) async throws {
        var request = try await request(with: Path.charger, parameters: userIdentifier, charger.chargingLocationId, charger.id)
        request.httpMethod = "DELETE"
        let response = try await URLSession.shared.response(for: request, delegate: nil)
        let data = response.0
        let urlResponse = response.1
        guard (urlResponse as? HTTPURLResponse)?.statusCode == 204 else {
            throw try HTTPError(with: data)
        }
    }
    
    func getConnectSessions<T: ConnectSession>() async throws -> [T] {
        let type: String = {
            switch T.self {
            case is VehicleConnectSession.Type: return "vehicle"
            case is ChargerConnectSession.Type: return "charger"
            default: fatalError("Invalid ConnectSession type")
            }
        }()
        let queryItems = [URLQueryItem(name: "type", value: type)]
        var request = try await request(with: Path.connectSessions, queryItems: queryItems, parameters: userIdentifier)
        request.httpMethod = "GET"
        let response = try await URLSession.shared.response(for: request, delegate: nil)
        let data = response.0
        do {
            return try JSONDecoder().decode([T].self, from: data)
        } catch {
            let errorResponse = try JSONDecoder().decode(HTTPErrorResponse.self, from: data)
            throw HTTPError.errorResponse(detail: errorResponse.detail)
        }
    }
    
    private func url(with path: String, queryItems: [URLQueryItem]) -> URL {
        var components = URLComponents()
        components.scheme = baseURL.scheme
        components.host = baseURL.host
        components.path = path
        components.queryItems = queryItems
        return components.url!
    }
    
    private func request(with path: String, queryItems: [URLQueryItem] = [], parameters: String...) async throws -> URLRequest {
        guard let accessToken = await authentication.getAccessToken() else { throw HTTPError.notAuthenticated }
        let pathWithParameters = String(format: path, arguments: parameters)
        let url = url(with: Path.base + pathWithParameters, queryItems: queryItems)
        var request = URLRequest(url: url)
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
