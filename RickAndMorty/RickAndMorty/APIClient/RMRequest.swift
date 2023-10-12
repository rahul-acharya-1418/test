//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by Rahul Acharya on 21/06/23.
//

import Foundation

/// Object that represents a singlet API call
final class RMRequest {
    // Base url
    // Endpoint
    // Path Component
    // Query Component
    // Eg. https://rickandmortyapi.com/api/character/1
    
    /// API Constants
    private struct Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }
    
    /// Desired end point
    private let endPoint: RMEndpoint
    
    /// Path Components for API, if any
    private let pathComponents: [String]
    
    /// Query arguments for API, if any
    private let queryParameters: [URLQueryItem]
    
    /// Constructed url for the api request in string format
    private var urlString: String {
        var string = Constants.baseUrl
        string += "/"
        string += endPoint.rawValue
        
        if !pathComponents.isEmpty {
            string += "/"
            pathComponents.forEach({
                string += "\($0)"
            })
        }
        
        /*
         For Future Reference
         if !pathComponents.isEmpty {
             string += "/"
             // name=value&name=value
             let argumentString = pathComponents.compactMap({
                 return "\($0)"
             }).joined(separator: ",")
             
             string += argumentString
         }
         */
        
        
        if !queryParameters.isEmpty {
            string += "?"
            // name=value&name=value
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            
            string += argumentString
        }
        
        return string
    }
    
    /// Computed and Constructed API url
    public var url: URL? {
        return URL(string: urlString)
    }
    
    /// Desired http method
    public let httpMethod = "GET"
    
    
    // MARK: - Public
    
    /// Construct request
    /// - Parameters:
    ///   - endPoint: Target endpoint
    ///   - pathComponents: Collection of path components
    ///   - queryParameters: Collection of query parameters
    public init(
        endPoint: RMEndpoint,
        pathComponents: [String] = [],
        queryParameters: [URLQueryItem] = []
    ) {
        self.endPoint = endPoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
    /// Attempt to create request
    /// - Parameter url: URL to parse
    convenience init? (url: URL) {
        let string = url.absoluteString
        
        if !string.contains(Constants.baseUrl) {
            return nil
        }
        
        let trimmed = string.replacingOccurrences(of: Constants.baseUrl+"/", with: "")
        
        if trimmed.contains("/") {
            let component = trimmed.components(separatedBy: "/")
            if !component.isEmpty {
                let endpointString = component[0]
                var pathComponents: [String] = []
                if component.count > 1 {
                    pathComponents = component
                    pathComponents.removeFirst()
                }
                if let rmEndpoint = RMEndpoint(
                    rawValue: endpointString
                ) {
                    self.init(endPoint: rmEndpoint, pathComponents: pathComponents)
                    return
                }
            }
        }else if trimmed.contains("?") {
            let component = trimmed.components(separatedBy: "?")
            if !component.isEmpty, component.count >= 2 {
                let endpointString = component[0]
                
                let queryItemString = component[1]
                
                let queryItem: [URLQueryItem] = queryItemString.components(separatedBy: "&").compactMap({
                    guard $0.contains("=") else {
                        return nil
                    }
                    
                    let parts = $0.components(separatedBy: "=")
                    
                    return URLQueryItem(
                        name: parts[0],
                        value: parts[1]
                    )
                })
                if let rmEndpoint = RMEndpoint(rawValue: endpointString) {
                    self.init(endPoint: rmEndpoint, queryParameters: queryItem)
                    return
                }
            }
        }
        
        return nil
    }
    
}

extension RMRequest {
    static let listCharactersRequests = RMRequest(endPoint: .character)
}
