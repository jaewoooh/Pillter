
//  LoadJson.swift
//  Pillter
//
//  Created by 이상원 on 8/30/24.
//

import UIKit

extension LocationController
{
    func loadPharmacyData() {
        // Load the JSON data
        guard let path = Bundle.main.path(forResource: "SeoulPharmacy", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            let root = try JSONDecoder().decode(Root.self, from: data)
            setupBottomPharmacyScrollView(with: root.data) // 스크롤뷰

            
        } catch {
            print("Failed to load JSON: \(error)")
        }
    }
}
