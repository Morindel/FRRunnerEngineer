//
//  ChallengeListDetailsViewController.swift
//  FrRunner
//
//  Created by Jakub Kołodziej on 10/12/2018.
//  Copyright © 2018 Jakub Kołodziej. All rights reserved.
//

import UIKit
import CoreData

class ChallengeListDetailsViewController: BaseController, UITableViewDataSource, UITableViewDelegate {
    
    
    enum cellType : Int {
        case map = 0, titleAndDate, description, author, usersProgress, total
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var challenge : DateChallenge?
    
    
    static func newInstanceWithChallenge( challenge: DateChallenge) -> UIViewController {
       
        let storyboard = UIStoryboard(name: "ChallengeList", bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ChallengeListDetailsViewController") as? ChallengeListDetailsViewController else {
            return UIViewController()
        }
        
        viewController.challenge = challenge
        
        return viewController
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          self.registerCells()
        // Do any additional setup after loading the view.
    }
    
    //MARK : Appearance
    
    func registerCells() {
        tableView.register(UINib.init(nibName: "ChallengeListMapTableViewCell", bundle: nil), forCellReuseIdentifier: "ChallengeListMapTableViewCell")
        tableView.register(UINib.init(nibName: "ChallengeListTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "ChallengeListTitleTableViewCell")
        tableView.register(UINib.init(nibName: "ChallengeListDescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "ChallengeListDescriptionTableViewCell")
        tableView.register(UINib.init(nibName: "ChallengeListAuthorTableViewCell", bundle: nil), forCellReuseIdentifier: "ChallengeListAuthorTableViewCell")
         tableView.register(UINib.init(nibName: "ChallangeSummaryTableViewCell", bundle: nil), forCellReuseIdentifier: "ChallangeSummaryTableViewCell")
        
    }
    
    //MARK : UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellType.total.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case cellType.map.rawValue:
            guard let latitude = self.challenge?.latitude, let longitude = self.challenge?.longitude else {
                return 0
            }
            
            if latitude == 0 || longitude == 0 {
                return 0
            } else {
                return 1
            }
            
        case cellType.titleAndDate.rawValue:
            guard let _ = self.challenge?.title, let _ = self.challenge?.challengeDate else {
                return 0
            }
            return 1
            
        case cellType.description.rawValue:
            guard let _ = self.challenge?.challengeDescription else {
                return 0
            }
            return 1
        
        case cellType.author.rawValue:
            guard let _ = self.challenge?.createdBy, let _ = self.challenge?.createdDate else {
                return 0
            }
            return 1
    
        case cellType.usersProgress.rawValue:
            guard let users = self.challenge?.users else {
                return 0
            }
            
            return users.count

        default:
            return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let challenge = self.challenge else {
            Helper.showAlertWithCompletionController(viewController: self, title: "Challenge error", message: "No challenge")
            return UITableViewCell.init()
        }
        
        switch indexPath.section {
            
        case cellType.map.rawValue:
            let cell : ChallengeListMapTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ChallengeListMapTableViewCell", for: indexPath) as! ChallengeListMapTableViewCell
            cell.loadWithChallenge(challenge: challenge)
            return cell
            
        case cellType.titleAndDate.rawValue:
            let cell : ChallengeListTitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ChallengeListTitleTableViewCell", for: indexPath) as! ChallengeListTitleTableViewCell
            cell.loadWithChallenge(challenge: challenge)
            return cell
            
        case cellType.description.rawValue:
            let cell : ChallengeListDescriptionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ChallengeListDescriptionTableViewCell", for: indexPath) as! ChallengeListDescriptionTableViewCell
            cell.loadWithChallenge(challenge: challenge)
            return cell
            
        case cellType.author.rawValue:
            let cell : ChallengeListAuthorTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ChallengeListAuthorTableViewCell", for: indexPath) as! ChallengeListAuthorTableViewCell
            cell.loadWithChallenge(challenge: challenge)
            return cell
            
        case cellType.usersProgress.rawValue:
            
            guard let usersSet =  challenge.users else {
                return UITableViewCell.init()
            }
            
            guard let usersArray = Array(usersSet) as? [UserModel] else {
                return UITableViewCell.init()
            }
            
            let user = usersArray[indexPath.row]
            
            let cell : ChallangeSummaryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ChallangeSummaryTableViewCell", for: indexPath) as! ChallangeSummaryTableViewCell
            cell.loadWithUserAndChallenge(user: user, challenge: challenge)
            return cell
            
        default:
            return UITableViewCell.init()
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
