import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public extension Alpaca {

	/// API key for interacting with Alpaca’s trade API.
	struct Key {

		/// To interact with Alpaca’s trade API, sign up for a account
		/// and obtain API key pairs from the [Alpaca dashboard](https://app.alpaca.markets/brokerage/dashboard/overview).
		/// - Parameter key: API key ID
		/// - Parameter secret: Secret key
		public init(key: String, secret: String) {
			self.key = key
			self.secret = secret
		}

		private let key: String
		private let secret: String

		var headerFields: [String: String] {
			[
				"APCA-API-KEY-ID": key,
				"APCA-API-SECRET-KEY": secret
			]
		}

		func authenticate(request: inout URLRequest) {
			for (field, value) in headerFields {
				request.setValue(value, forHTTPHeaderField: field)
			}
		}

	}

}

extension URLRequest {

	func authenticate(with key: Alpaca.Key) -> URLRequest {
		var request = self
		key.authenticate(request: &request)
		return request
	}

}
