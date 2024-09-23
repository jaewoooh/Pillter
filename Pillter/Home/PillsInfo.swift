import Foundation

struct Pill: Codable {
    let pillName: String
    let id: Int //String으로 교체해야할수도?
    let components: String
    let efficacy: String
    let usageCapacity: String
    let caution: String?
    let pillType: String
    let frontInfo: String
    let frontBack: String
    let cautionSummation: String
}

struct PillDataWrapper: Codable {
    let PillData: [Pill]
}
