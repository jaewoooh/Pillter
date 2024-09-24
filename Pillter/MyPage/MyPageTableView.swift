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
        
        return pillData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let pill = pillData?[indexPath.row]
        {
            cell.textLabel?.text = pill.pillName
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //터치하면 발생하는 함수
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let pill = pillData?[indexPath.row] {
            // UIAlert 생성
            let alert = UIAlertController(title: nil, message: "\(pill.pillName)의 정보로 이동하겠습니까?", preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "예", style: .default) { _ in
                // "예"를 눌렀을 때 PillInfoViewController로 이동
                let pillInfoVC = PillInfoViewController()
                
                // 선택된 pill의 id와 shapeType을 전달하여 displayPillInfo 함수 호출
                pillInfoVC.id = pill.id
                pillInfoVC.myPageFlag = true
                
                // 화면 전환
                self.navigationController?.pushViewController(pillInfoVC, animated: true)
            }
            
            let noAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
            
            alert.addAction(yesAction)
            alert.addAction(noAction)
            
            // Alert를 표시
            self.present(alert, animated: true, completion: nil)
        }
    }
        
    func setupTableView()
    {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //tableView.backgroundColor = .white
    }
    

}
