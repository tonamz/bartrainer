//
//  HomeModel.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 10/1/2562 BE.
//  Copyright © 2562 Methira Denthongchai. All rights reserved.
//

import UIKit
protocol HomeModelDelegate {
    func itemsDownloaded(locations:[Location])
}

class HomeModel: NSObject {
    
    var delegate:HomeModelDelegate?
    
    func getItems(){
        //hit the web service url
        let serviceUrl = "https://localhost/server.php"
        //download json data
        let url = URL(string: serviceUrl)
        if let url = url {
            //Creat Url session
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url,completionHandler: { (data, response, error) in
                
                if error == nil {
                    //success
                    
                    self.parseJson(data!)
                }
                else {
                    //error
                }
            })
            // start the task
            task.resume()
        }
        //parse it out location structs
        //notify the view controller ans pass the data back
    }
    
    func parseJson(_ data:Data){
        
        var locArray = [Location]()
        //Parse the data into
        do{
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
            
            for jsonResult in jsonArray{
                
                let jsonDict = jsonResult as! [String:String]
                
                let loc = Location(name: jsonDict["name"]!,number: jsonDict["number"]!)
                
                locArray.append(loc)
            }
            
            delegate?.itemsDownloaded(locations: locArray)
        }
        catch{
            print("There was an error")
        }
    }
}
