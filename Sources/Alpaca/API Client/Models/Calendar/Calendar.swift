import Foundation

public struct Calendar: Encodable, Hashable {

	/// Year, month, and day components for the given market calendar day.
	public let date: DateComponents
	/// The full date object for market open time. Precision only to the minute.
	public let open: Date
	/// The full date object for market close time. Precision only to the minute.
	public let close: Date

	public static let timeZone: TimeZone? = {
		TimeZone(identifier: "America/New_York")
	}()

	public static let locale: Locale = {
		Locale(identifier: "en_US_POSIX")
	}()

	static let marketDayFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		formatter.locale = locale
		formatter.timeZone = timeZone
		return formatter
	}()

	static let marketTimeFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "HH:mm"
		formatter.locale = locale
		formatter.timeZone = timeZone
		return formatter
	}()

	static let calendar: Foundation.Calendar = {
		Foundation.Calendar(identifier: .iso8601)
	}()

}

extension Calendar: Decodable {

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let dateString = try container.decode(String.self, forKey: .date)
		let openString = try container.decode(String.self, forKey: .open)
		let closeString = try container.decode(String.self, forKey: .close)
		guard let marketDay = Calendar.marketDayFormatter.date(from: dateString) else {
			throw Error.invalidDateString
		}
		guard let openTime = Calendar.marketTimeFormatter.date(from: openString) else {
			throw Error.invalidDateString
		}
		guard let closeTime = Calendar.marketTimeFormatter.date(from: closeString) else {
			throw Error.invalidDateString
		}
		let openComponents = Calendar.calendar.dateComponents([.hour, .minute], from: openTime)
		let closeComponents = Calendar.calendar.dateComponents([.hour, .minute], from: closeTime)

		self.date = Calendar.calendar.dateComponents([.day, .month, .year], from: marketDay)
		guard let openDate = Calendar.calendar.date(byAdding: openComponents, to: marketDay) else {
			throw Error.invalidMarketTime
		}
		guard let closeDate = Calendar.calendar.date(byAdding: closeComponents, to: marketDay) else {
			throw Error.invalidMarketTime
		}
		self.open = openDate
		self.close = closeDate
	}

	enum Error: Swift.Error {
		case invalidDateString
		case invalidMarketTime
	}

}
