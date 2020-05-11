import Foundation

/// See [Alpaca’s docs](https://alpaca.markets/docs/trading-on-alpaca/orders/#bracket-orders) for more details.
public enum OrderClass: String, Codable, Hashable {
	case simple
	case bracket
	case oco
	case oto
}
