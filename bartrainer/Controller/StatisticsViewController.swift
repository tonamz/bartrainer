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

    
    var calsum:String?
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var calLebel: UILabel!
    @IBOutlet weak var statisticscollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        self.statisticscollection.dataSource = self
        self.statisticscollection.delegate = self
        

        
        let myColor : UIColor = UIColor(red:0.99, green:0.50, blue:0.25, alpha:1.0)
        
        self.bgView.layer.cornerRadius = 100
        self.bgView.layer.borderWidth = 2
        self.bgView.layer.borderColor = myColor.cgColor

        

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 31
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatisticsCollectionViewCell", for: indexPath) as! StatisticsCollectionViewCell
        
        cell.dayLabel.text = "\(indexPath.row+1)"
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let url = "http://tssnp.com/ws_bartrainer/statistics.php?id_user=\(User.currentUser?.id_user ?? "1")&created_at=2019-02-\(indexPath.row+1)%"
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        Alamofire.request(encodedUrl ?? "0").responseString { response in
           if let data = response.data, let utf8Text = String(data: data, encoding: .utf8){
  
                do {
                  
        
                    self.calsum = utf8Text
                    let calsum = String(utf8Text.filter { !" \n\t\r".contains($0) })
                        print("Data: \(calsum)")
                    self.calLebel.text = "\(calsum)"
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("error")
            }
        }
 
     
  
        
  
  

        
 
    }
    


}
