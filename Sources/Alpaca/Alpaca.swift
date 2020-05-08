/// Swift API client for Alpaca’s trade API.
/// Contribute on [GitHub](https://github.com/pixel-foundry/alpaca-swift).
public final class Alpaca {

	public enum Version {
		case v2
	}

	public enum Mode {
		/// Live trade with real money.
		case live
		/// Paper trade in a real-time simulation environment where you can test your code.
		case paper
	}

	private let key: AlpacaKey
	private let mode: Mode
	private let version: Version

	public init(_ key: AlpacaKey, mode: Mode = .paper, version: Version = .v2) {
		self.key = key
		self.mode = mode
		self.version = version
	}

}
