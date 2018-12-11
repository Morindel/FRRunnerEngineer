//
//  ChallengeSummaryViewController.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 09/12/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ChallengeSummaryViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum TableSection: Int {
        case oneRunChallenge = 0, longTermChallenge, total
    }
    
    var challenges : [DateChallenge]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func loadView() {
        super.loadView()
        
        self.registerCells()
        
        print(ChallengesLocalRepository.getDateChallenges())
        challenges = [DateChallenge].init()
        challenges = ChallengesLocalRepository.getDateChallenges()
        
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
    }
    
    func registerCells() {
        tableView.register(UINib.init(nibName: "ChallengeListTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "ChallengeListTitleTableViewCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return challenges?.count ?? 0
        //        guard let numberofUsers : [DateChallenge] = challenges else {
        //            return 0
        //        }
        //
        //        if let number = numberofUsers[section].users?.count {
        //            return number + 1
        //        } else {
        //            return 0
        //        }
        //
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let challenge = challenges?[indexPath.row] else{
            return UITableViewCell.init()
        }
        
        let cell : ChallengeListTitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ChallengeListTitleTableViewCell", for: indexPath) as! ChallengeListTitleTableViewCell
        cell.loadWithChallenge(challenge: challenge)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let challenge = self.challenges?[indexPath.row] else {
            return
        }
        
        guard let vc = ChallengeListDetailsViewController.newInstanceWithChallenge(challenge: challenge) as? ChallengeListDetailsViewController else {
            return
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension Date {
    static var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: Date().noon)!
    }
    static var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date().noon)!
    }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
