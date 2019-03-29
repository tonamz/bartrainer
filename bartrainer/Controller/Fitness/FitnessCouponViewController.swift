//
//  FitnessCouponViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 30/3/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit
import Alamofire

class FitnessCouponViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate{


    var coupon: [Coupon] = []
    
    var selectedfitness: Fitness?
    var selectedcoupon: Coupon?
    
    @IBOutlet weak var couponTableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.couponTableview.dataSource = self
        self.couponTableview.delegate = self
        
          self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        
        Alamofire.request("http://tssnp.com/ws_bartrainer/fitness_coupon.php?id_fitness=1").responseData { response in
            if let data = response.result.value {
                
                do {
                    let decoder = JSONDecoder()
                    
                    self.coupon = try decoder.decode([Coupon].self, from: data)
                    self.couponTableview.reloadData()
                    print(self.coupon)
                    
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("error")
            }
        }

   
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fitnessCode"  {
            let vc = segue.destination as! FitnessGetCodeViewController
            vc.fitnessName = selectedfitness!.name_brand
            vc.fitnessBranch = selectedfitness!.name_branch
            vc.selectedcoupon = selectedcoupon
            vc.selectedfitness = selectedfitness
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coupon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FitnessCouponTableViewCell", for: indexPath) as! FitnessCouponTableViewCell
        let model = coupon[indexPath.row]
        cell.headLabel.text = model.head
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedcoupon = coupon[indexPath.row]
        performSegue(withIdentifier: "fitnessCode", sender: self)
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
