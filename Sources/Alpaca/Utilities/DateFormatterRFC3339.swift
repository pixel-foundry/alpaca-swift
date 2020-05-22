import Foundation

class RFC3339DateFormatter: DateFormatter {

	let dateFormats = [
		"yyyy-MM-dd'T'HH:mm:ss.SSXXXXX",
		"yyyy-MM-dd'T'HH:mm:ssZZZZZ",
		"yyyy-MM-dd'T'HH:mm:ss.SSZZZZZ",
		"yyyy-MM-dd'T'HH:mm:ss-SS:ZZ",
		"yyyy-MM-dd'T'HH:mm:ss"
	]

	override init() {
		super.init()
		self.timeZone = TimeZone(secondsFromGMT: 0)
		self.locale = Locale(identifier: "en_US_POSIX")
		self.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSXXXXX"
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) not supported")
	}

	override func date(from string: String) -> Date? {
		let string = string.trimmingCharacters(in: .whitespacesAndNewlines)
		for dateFormat in self.dateFormats {
			self.dateFormat = dateFormat
			if let date = super.date(from: string) {
				return date
			}
		}
		return nil
	}

}

extension JSONDecoder.DateDecodingStrategy {

	static private let formatter = RFC3339DateFormatter()

	static let alpaca: JSONDecoder.DateDecodingStrategy = {
		.custom { decoder in
			let container = try decoder.singleValueContainer()
			let dateString = try container.decode(String.self)
			guard let date = formatter.date(from: dateString) else {
				throw Error.invalidDateString
			}
			return date
		}
	}()

	enum Error: Swift.Error {
		case invalidDateString
	}

}
