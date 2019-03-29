//
//  FitnessViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 25/1/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit
import Alamofire

class FitnessViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate{

    
    
    @IBOutlet weak var fitnessTableView: UITableView!
    
    var selectedfitness: Fitness?
    var FitnessDetail: [Fitness] = []

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        self.fitnessTableView.dataSource = self
        self.fitnessTableView.delegate = self
        
        Alamofire.request("http://tssnp.com/ws_bartrainer/fitness.php").responseData { response in
            if let data = response.result.value {
                
                do {
                    let decoder = JSONDecoder()
                    
                    self.FitnessDetail = try decoder.decode([Fitness].self, from: data)
                    self.fitnessTableView.reloadData()
                    
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("error")
            }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fitnessDetail" {
            let vc = segue.destination as! FitnessDetailViewController
            vc.selectedfitness = selectedfitness
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FitnessDetail.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FitnessTableViewCell", for: indexPath) as! FitnessTableViewCell
        let model = FitnessDetail[indexPath.row]
        cell.fitnessImageView.image = UIImage(named: "fitness-\( model.id_fitness)")
        cell.fitnessLabel.text = model.name_brand
        cell.branchLabel.text = model.name_branch

        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedfitness = FitnessDetail[indexPath.row]
        performSegue(withIdentifier: "fitnessDetail", sender: self)
    }

    


}
