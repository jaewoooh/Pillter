import Foundation

extension PillInfoViewController {
    func loadPillJson() {
        // 여기에 JSON 파일을 불러오는 코드 작성
        if let filePath = Bundle.main.url(forResource: "PillInfo", withExtension: "json") {
            do {
                let jsonData = try Data(contentsOf: filePath)
                let decodedData = try JSONDecoder().decode(PillDataWrapper.self, from: jsonData)
                self.pillDataWrapper = decodedData // 데이터를 pillDataWrapper에 할당
                print("Pill data loaded successfully.")
                
            } catch {
                print("Error loading pill data: \(error)")
            }
        } else {
            print("PillInfo.json 파일을 찾을 수 없습니다.")
        }
    }
}

extension HomeController {
    func loadPillJson() {
        // 여기에 JSON 파일을 불러오는 코드 작성
        if let filePath = Bundle.main.url(forResource: "PillInfo", withExtension: "json") {
            do {
                let jsonData = try Data(contentsOf: filePath)
                let decodedData = try JSONDecoder().decode(PillDataWrapper.self, from: jsonData)
                self.pillDataWrapper = decodedData // 데이터를 pillDataWrapper에 할당
                print("Pill data loaded successfully.")
                
            } catch {
                print("Error loading pill data: \(error)")
            }
        } else {
            print("PillInfo.json 파일을 찾을 수 없습니다.")
        }
    }
}
