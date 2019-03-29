//
//  statisticsViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 30/3/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit
import Alamofire

class StatisticsViewController: UIViewController ,UICollectionViewDataSource, UICollectionViewDelegate{

    

    @IBOutlet weak var statisticscollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
        self.statisticscollection.dataSource = self
        self.statisticscollection.delegate = self
        
        statisticscollection.reloadData()
//
//        Alamofire.request("  http://tssnp.com/ws_bartrainer/statistics.php?id_user=\(User.currentUser?.id_user ?? "1")&created_at=2019-02-23%").responseData { response in
//            if let data = response.result.value {
//
//                do {
//                    let decoder = JSONDecoder()
//
//                    self.challengeGroup = try decoder.decode([ChallengeName].self, from: data)
//
//                    self.challengeCollection.reloadData()
//
//                } catch {
//                    print(error.localizedDescription)
//                }
//            } else {
//                print("error")
//            }
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 31
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatisticsCollectionViewCell", for: indexPath) as! StatisticsCollectionViewCell
        
        cell.dayLabel.text = "\(indexPath.row+1)"
        
        return cell
    }
    


}
