
import Foundation
import RealmSwift

class DBHelper
{

    static let shared = DBHelper()
    private let realm: Realm
    
    private init()
    {
        self.realm = try! Realm()
    }
    
    //삽입
    func insertData(_ data: PillModel)
    {

        //let realm = try! Realm()
        
        try! realm.write {
            realm.add(data)
            print("생성 성공")
        }
    }
    
    //읽기
    func readData()
    {
        //let realm = try! Realm()
        
        let pillModel = realm.objects(PillModel.self)
        print(pillModel)
    }
    
    //업데이트(아마 쓸일없음)
    func updateData(_ data: PillModel)
    {
        //let realm = try! Realm()
        
        try! realm.write {
            realm.add(data, update: .modified)
        }
    }
    
    //삭제
    func deleteData(_ id: Int)
    {
        //let realm = try! Realm()
        
        guard let pillData = realm.objects(PillModel.self).filter("id == %@", id).first else { return }
        
        try! realm.write {
            realm.delete(pillData)
        }
    }
}
