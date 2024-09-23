//
//  MyPageTableView.swift
//  Pillter
//
//  Created by 이상원 on 9/23/24.
//

import Foundation
import UIKit

extension MyPageController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // 셀의 기본 텍스트 레이블에 데이터 설정
        cell.textLabel?.text = data[indexPath.row]
        
        return cell
    }

    // #MARK: 테이블뷰 delegate datasource 함수
    
    func setupTableView()
    {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.backgroundColor = .darkGray
    }
    

}
