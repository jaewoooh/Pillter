
import Foundation
import RealmSwift

class PillModel: Object
{
    @Persisted(primaryKey: true) var id: Int
    @Persisted var pillName: String
    
    convenience init(id: Int, pillName: String) {
        self.init()
        self.id = id
        self.pillName = pillName
    }
}
