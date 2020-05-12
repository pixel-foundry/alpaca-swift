import Foundation

public struct PositionLiquidation: Codable, Hashable {

	/// `200` if the position was successfully liquidated.
	/// `500` if the server failed to liquidate the position.
	public let status: Int
	/// The position model.
	public let body: Position?

}
