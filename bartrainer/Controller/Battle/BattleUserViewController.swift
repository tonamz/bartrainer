//
//  BattleUserViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 26/3/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit
import Alamofire

class BattleUserViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var battleUserCollection: UICollectionView!
    
    @IBOutlet weak var nameuserLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    var selectedBattleUser: Battle?
    var battleUser: [BattleUser] = []
    @IBOutlet weak var helloButton: UIButton!
    
    @IBAction func helloPush(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
              self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        
        print(selectedBattleUser)
helloButton.layer.cornerRadius = 10
       userImageView.layer.cornerRadius = 60
    
       nameuserLabel.text = selectedBattleUser?.username
        
        self.battleUserCollection.dataSource = self
        self.battleUserCollection.delegate = self
        
        
        
        Alamofire.request("http://tssnp.com/ws_bartrainer/battle_user.php?id_user=\(selectedBattleUser?.id_user ?? "0")").responseData { response in
            if let data = response.result.value {

                do {
                    let decoder = JSONDecoder()

                    self.battleUser = try decoder.decode([BattleUser].self, from: data)
                    self.battleUserCollection.reloadData()


                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("error")
            }
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return battleUser.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BattleUserCollectionViewCell", for: indexPath) as! BattleUserCollectionViewCell
        let model = battleUser[indexPath.row]
        cell.nameExLabel.text = model.name_exercise
        cell.repsLabel.text = model.sumreps
        
        return cell
    }

}
