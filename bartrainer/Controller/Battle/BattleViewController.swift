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
    
    @IBAction func startBattleBT(_ sender: Any) {
    }
    @IBOutlet weak var buttonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        buttonOutlet.layer.cornerRadius = 10
        
        self.BattleGroupTableView.dataSource = self
        self.BattleGroupTableView.delegate = self
        
        
        Alamofire.request("http://tssnp.com/ws_bartrainer/battle_info.php").responseData { response in
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
        cell.profileImageView.image = UIImage(named: "userWee")
        cell.nameUser.text = "\(model.id_user)"
        cell.nameEX.text = "\(model.name_exercise)"
       cell.scoreBattle.text = "\(model.reps)"
        
        return cell
    }
    
    

}
