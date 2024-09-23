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
    // #MARK: 테이블뷰 delegate datasource 함수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pillList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let pill = pillList[indexPath.row]
        cell.textLabel?.text = pill.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedPill = pillList[indexPath.row]
//
//        if let dbPointer = DBHelper.shared.db
//        {
//            DBHelper.shared.deleteById(id: selectedPill.id, databasePointer: dbPointer)
//
//            pillList.remove(at: indexPath.row)
//            tableView.reloadData()
//        }
    }
    
    func setupTableView()
    {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.backgroundColor = .darkGray
    }
    

}
