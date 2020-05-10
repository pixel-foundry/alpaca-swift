import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// The order of responses. Defaults to `desc`.
public enum Direction: String, Codable, Hashable {
	case desc
	case asc
}

/// Order status to be queried. Defaults to `open`.
public enum OrderStatusFilter: String, Codable, Hashable {
	case open
	case closed
	case all
}

protocol QueryParameter: Codable { }

extension QueryParameter {

	func queryParameters(encoder: JSONEncoder) -> [String: String]? {
		guard let data = try? encoder.encode(self) else { return nil }
		return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments))
			.flatMap { $0 as? [String: Any] }?
			.compactMapValues { $0 as? String }
	}

}

public extension Order {

	struct QueryParameters: QueryParameter, Hashable {

		public let status: OrderStatusFilter?
		/// The maximum number of orders in response. Defaults to 50 and max is 500.
		public let limit: Quantity?
		/// The response will include only ones submitted after this timestamp (exclusive.)
		public let after: Date?
		/// The response will include only ones submitted until this timestamp (exclusive.)
		public let until: Date?
		public let direction: Direction?
		/// If true, the result will roll up multi-leg orders under the legs field of primary order.
		public let nested: Bool?

		public init(
			status: OrderStatusFilter? = nil,
			limit: Quantity? = nil,
			after: Date? = nil,
			until: Date? = nil,
			direction: Direction? = nil,
			nested: Bool? = nil
		) {
			self.status = status
			self.limit = limit
			self.after = after
			self.until = until
			self.direction = direction
			self.nested = nested
		}

	}

}

extension URLRequest {

	func addQueryParameters(_ parameters: QueryParameter?, using encoder: JSONEncoder = AlpacaAPI.encoder) -> URLRequest {
		guard let parameters = parameters else { return self }
		guard let url = self.url, var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
			return self
		}
		let queryItems = parameters.queryParameters(encoder: encoder)?.compactMap { (key, value) -> URLQueryItem? in
			return URLQueryItem(name: key, value: value)
		} ?? []
		if urlComponents.queryItems == nil { urlComponents.queryItems = [] }
		urlComponents.queryItems?.append(contentsOf: queryItems)
		guard let urlWithQuery = urlComponents.url else { return self }
		var request = self
		request.url = urlWithQuery
		return request
	}

}
