/// API key for interacting with Alpaca’s trade API.
public struct AlpacaKey {

	let key: String
	let secret: String

	/// To interact with Alpaca’s trade API, sign up for a account
	/// and obtain API key pairs from the [Alpaca dashboard](https://app.alpaca.markets/brokerage/dashboard/overview).
	/// - Parameter key: API key ID
	/// - Parameter secret: Secret key
	public init(key: String, secret: String) {
		self.key = key
		self.secret = secret
	}

}
