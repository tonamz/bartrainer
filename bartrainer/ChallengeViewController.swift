//
//  ChallengeViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 10/1/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit

class ChallengeViewController: UIViewController, HomeModelDelegate, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    var homeModel = HomeModel()
    
    var locations = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        homeModel.getItems()
        homeModel.delegate = self
    }
    
    func itemsDownloaded(locations:[Location]){
        self.locations = locations
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return locations.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        
        cell.textLabel?.text = locations[indexPath.row].name
        
        return cell
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
