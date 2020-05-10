import Foundation

public struct OrderCancellation: Codable, Hashable {

	/// Order ID of the cancelled order.
	public let id: String
	/// `200` if the order was successfully cancelled.
	/// `500` if the server failed to cancel the order.
	public let status: Int
	/// The order model.
	public let body: Order?

}
