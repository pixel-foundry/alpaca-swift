import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Swift API client for Alpaca’s trade API.
/// Contribute on [GitHub](https://github.com/pixel-foundry/alpaca-swift).
public final class Alpaca {

	public init(
		sessionConfiguration: URLSessionConfiguration = .default,
		mode: Mode = .paper,
		version: Version = .v2,
		key: Key
	) {
		api = AlpacaNetworkAPI(configuration: sessionConfiguration, mode: mode, version: version, key: key)
	}

	private let api: AlpacaNetworkAPI

	public enum Version: String {
		case v2
	}

	public enum Mode {
		/// Live trade with real money.
		case live
		/// Paper trade in a real-time simulation environment where you can test your code.
		case paper
	}

}
