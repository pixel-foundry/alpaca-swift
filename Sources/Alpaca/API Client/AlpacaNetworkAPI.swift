import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class AlpacaNetworkAPI {

	init(
		configuration: URLSessionConfiguration,
		mode: Alpaca.Mode,
		version: Alpaca.Version,
		key: Alpaca.Key
	) {
		self.configuration = configuration
		self.mode = mode
		self.version = version
		self.key = key
	}

	private let configuration: URLSessionConfiguration
	private let mode: Alpaca.Mode
	private let version: Alpaca.Version
	private let key: Alpaca.Key

	private lazy var endpoint: URL = {
		switch mode {
		case .paper:
			return URL(string: "https://paper-api.alpaca.markets")!
		case .live:
			return URL(string: "https://api.alpaca.markets")!
		}
	}()

	private lazy var session: URLSession = {
		URLSession(configuration: configuration)
	}()

	enum API: String {

		func request(endpoint: URL, version: Alpaca.Version) -> URLRequest {
			var request = URLRequest(url: endpoint.appendingPathComponent(path(version)))
			request.httpMethod = method
			return request
		}

		func path(_ version: Alpaca.Version) -> String {
			"\(version.rawValue)/\(rawValue)"
		}

		var method: String {
			switch self {
			default: return "GET"
			}
		}

		case account

	}

}
