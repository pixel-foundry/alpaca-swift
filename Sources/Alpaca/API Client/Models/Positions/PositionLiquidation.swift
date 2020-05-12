import Foundation

public struct PositionLiquidation: Codable, Hashable {

    /// Asset symbol.
    public let symbol: String
	/// `200` if the position was successfully liquidated.
	/// `500` if the server failed to liquidate the position.
	public let status: Int
	/// The market order that liquidated the position.
	public let body: Order?

}
