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
        static let base = "/api/v01-01"
        static let vehicles = "/users/%@/vehicles"
        static let vehicle = Path.vehicles + "/%@"
    }
    
    private let user: User
    
    required init(user: User) {
        self.user = user
    }
    
    func getVehicles() async throws -> [Vehicle] {
        var request = request(with: Path.vehicles, parameters: user.identifier)
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
        var request = request(with: Path.vehicle, parameters: user.identifier, vehicle.id)
        request.httpMethod = "DELETE"
        let response = try await URLSession.shared.response(for: request, delegate: nil)
        let data = response.0
        let urlResponse = response.1
        guard (urlResponse as? HTTPURLResponse)?.statusCode == 204 else {
            throw try HTTPError(with: data)
        }
    }
    
    private func request(with path: String, parameters: String...) -> URLRequest {
        let pathWithParameters = String(format: path, arguments: parameters)
        let url = URL(string: JedlixSDK.baseURL.absoluteString + Path.base + pathWithParameters)!
        var request = URLRequest(url: url)
        request.addValue("Bearer \(user.accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
