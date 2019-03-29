//
//  BattleViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 19/1/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit
import Alamofire

class BattleViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var BattleGroupTableView: UITableView!
    
    var BattleGroup: [Battle] = []
    var user: [User] = []
    var imageUser: [String] = ["userWee","userJune","userPun"]
    var id_user:Int = 0
    var selectedBattleUser: Battle?

    
    @IBAction func startBattleBT(_ sender: Any) {
    }
    @IBOutlet weak var buttonOutlet: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        buttonOutlet.layer.cornerRadius = 10
        
        self.BattleGroupTableView.dataSource = self
        self.BattleGroupTableView.delegate = self
        
//        BattleGroupTableView.backgroundColor = UIColor.red
        
       
        BattleGroupTableView.layer.masksToBounds = true
        BattleGroupTableView.layer.shadowColor = UIColor.lightGray.cgColor
        BattleGroupTableView.layer.shadowOffset = CGSize(width: 0, height: 0)
        BattleGroupTableView.layer.shadowRadius = 8
        BattleGroupTableView.layer.shadowOpacity = 0.5
        BattleGroupTableView.layer.cornerRadius = 10
//     BattleGroupTableView.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.BattleGroupTableView.layer.cornerRadius).cgPath

        
        
        Alamofire.request("http://tssnp.com/ws_bartrainer/battle_rank.php").responseData { response in
            if let data = response.result.value {
                
                do {
                    let decoder = JSONDecoder()
                    
                    self.BattleGroup = try decoder.decode([Battle].self, from: data)
                    self.BattleGroupTableView.reloadData()
                    
                    
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("error")
            }
        }

 
   
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BattleGroup.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BattleGroupTableViewCell", for: indexPath) as! BattleGroupTableViewCell
        
        let model = BattleGroup[indexPath.row]
//        cell.profileImageView.image = UIImage(named: "\(imageUser[1])")
        cell.nameEX.text = "battle score"
        cell.nameUser.text = "\(model.username)"
       cell.scoreBattle.text = "\(model.sumreps)"
//        cell.profileImageView.af_setImage(withURL: URL(string: "\(User.currentUser?.id_user)")!)
        cell.profileImageView.af_setImage(withURL: URL(string: "https://tssnp.com/ws_bartrainer/images/\(model.img_profile)")!)

        
        if(indexPath.row < 3){
            cell.rankImageview.image = UIImage(named:"rank0\(indexPath.row+1)")
            cell.rankLabel.isHidden = true
            cell.rankImageview.isHidden = false
        }else {
            cell.rankImageview.isHidden = true
            cell.rankLabel.isHidden = false
             cell.rankLabel.text = "\(indexPath.row+1)"
            
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BattleUser" {
            let vc = segue.destination as! BattleUserViewController
            vc.selectedBattleUser = selectedBattleUser
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedBattleUser = BattleGroup[indexPath.row]
        performSegue(withIdentifier: "BattleUser", sender: self)
    }
    
    

}
