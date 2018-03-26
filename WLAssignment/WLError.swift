//
//  WLError.swift
//  WLAssignment
//
//  Created by Nick Yekimov on 3/24/18.
//  Copyright © 2018 Nick Yekimov. All rights reserved.
//
import Foundation

enum WLError: Error {
    // MARK: Default
    case `default`
    case systemError(Error)

    // MARK: - Networking
    case httpInvalidHeaders
    case httpUnauthorized
    case httpForbidden
    case httpConflict
    case httpPreconditionFailed
    case httpPreconditionRequired
    case httpInternalError
    case httpServiceUnavailable
    case httpNotFound
    case httpTimeout
    case httpConnectionLost
    case httpTooManyRequests
    case httpPayloadTooLarge
    case httpGone
    case httpDefault(Int)
    case invalidURL

    // MARK: Payload
    case payloadInvalidData
    case payloadNotData
    case payloadNotDataList
    case payloadNotEmpty
}
extension WLError: LocalizedError {
    public var errorDescription: String? {
        return description
    }
}
extension WLError: CustomStringConvertible {
    public var description: String {
        switch self {

        // MARK: - Common
        case .default, .systemError, .httpDefault:
            return "Something went wrong. Please try again later."

        // MARK: - Networking
        case .httpInvalidHeaders:
            return "Invalid headers"
        case .httpUnauthorized:
            return "Unauthorized - invalid token"
        case .httpForbidden:
            return "Forbidden - insufficient scope"
        case .httpConflict:
            return "The server returns this response code to a POST request which would result in duplicate resource identifiers. Ignore the request and log the response. If it was not a duplicate request, attempt to retry the request. Upon persistent failure, contact the System Administrator."
        case .httpPreconditionFailed:
            return "The server returns this response code to a PUT request with a non-matching Entity Tag in the If-Match header or etag query parameter. Retrieve the latest version of the resource (using a GET) and compose the new state of the resource based on that response."
        case .httpPreconditionRequired:
            return "The server returns this response code upon receiving a PUT request for a resource which requires an Entity Tag to be provided and the PUT request does not contain a If-Match header or etag query parameter. Retry the request with either the If-Match header or the etag query parameter contain the last known Entity Tag."
        case .httpInternalError:
            return "Internal Error"
        case .httpServiceUnavailable:
            return "Service Unavailable"
        case .httpNotFound:
            return "The server has not found anything matching the request URI."
        case .httpTimeout:
            return "Network request timed out."
        case .httpConnectionLost:
            return "Network connection was lost."
        case .httpTooManyRequests:
            return "Too many requests."
        case .httpPayloadTooLarge:
            return "Payload too large."
        case .httpGone:
            return "Indicates that the resource requested is no longer available and will not be available again."
        case .invalidURL:
            return "Invalid request url"

        // MARK: - Payload
        case .payloadInvalidData:
            return "Invalid data format"
        case .payloadNotData:
            return "Payload is not data."
        case .payloadNotDataList:
            return "Payload is not data list."
        case .payloadNotEmpty:
            return "Unknown payload."
        }
    }
}
