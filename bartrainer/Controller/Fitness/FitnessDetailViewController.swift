//
//  FitnessDetailViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 25/1/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit
import Alamofire

class FitnessDetailViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var fitnessLabel: UILabel!
    @IBOutlet weak var branchLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var fitnessImageView: UIImageView!
     @IBOutlet weak var getcodeBT: UIButton!

    
       @IBOutlet weak var iconmachineCollection: UICollectionView!
    
    
    var selectedfitness: Fitness?
    var FitnessDetail: [Fitness] = []
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
 
        getcodeBT.layer.cornerRadius = 40

        
        customView.clipsToBounds = true

        self.iconmachineCollection.dataSource = self
        self.iconmachineCollection.delegate = self

        title = selectedfitness!.name_brand
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        //        self.exercisListTableView.backgroundColor = UIColor(white: 1, alpha: 0)
        

        Alamofire.request("http://tssnp.com/ws_bartrainer/fitness.php").responseData { response in
            if let data = response.result.value {
                
                do {
                    let decoder = JSONDecoder()
                    
                    self.FitnessDetail = try decoder.decode([Fitness].self, from: data)
                    
                    
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("error")
            }
        }
        
        
        fitnessLabel.text = selectedfitness!.name_brand
        branchLabel.text = selectedfitness!.name_branch
        detailLabel.text = selectedfitness!.detail
        
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fitnessCoupon"  {
            let vc = segue.destination as! FitnessCouponViewController
            vc.selectedfitness = selectedfitness
        

        
        }
//        else if segue.identifier == "fitnessRegis" {
//            let vc2 = segue.destination as! FitnessRegisterViewController
//            vc2.fitnessName = selectedfitness!.name_brand
//            vc2.fitnessBranch = selectedfitness!.name_branch
//            vc2.fitnessid = selectedfitness!.id_fitness
//            
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FitnessDetailCollectionViewCell", for: indexPath) as! FitnessDetailCollectionViewCell
        let number = indexPath.row + 36
        cell.bgView.image = UIImage(named: "Asset \(number)")
        
        return cell
        
    }
    

}
