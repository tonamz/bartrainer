//
//  ChallengeDetailViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 30/1/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit
import Alamofire

class ChallengeDetailViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate{
   
    @IBOutlet weak var challengeDetailCollection: UICollectionView!
    
    var challengeGroup: [Challenge] = []
    var selectedChallengeGroup: Challenge?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        
        self.challengeDetailCollection.dataSource = self
        self.challengeDetailCollection.delegate = self
        
        Alamofire.request("http://tssnp.com/ws_bartrainer/challenge.php").responseData { response in
            if let data = response.result.value {
                
                do {
                    let decoder = JSONDecoder()
                    
                    self.challengeGroup = try decoder.decode([Challenge].self, from: data)
                    
                    self.challengeDetailCollection.reloadData()
                    
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("error")
            }
        }
        
        
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return challengeGroup.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "challenge_detail_collection", for: indexPath) as! ChallengeDetailCollectionViewCell
        let model = challengeGroup[indexPath.row]
        cell.headerLabel.text = model.day
        
        return cell
    }
    

}
