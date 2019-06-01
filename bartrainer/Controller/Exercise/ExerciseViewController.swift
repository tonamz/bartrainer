//
//  ExerciseViewController.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 16/12/2561 BE.
//  Copyright © 2561 Methira Denthongchai. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import AVFoundation

class ExerciseViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {


    
//    var audioPlayer = AVAudioPlayer()

    var audioPlayer: AVAudioPlayer?
    var audioPlayerTrainer: AVAudioPlayer?
    
    var sound: URL?
    
    var player = AVPlayer()

    @IBOutlet weak var exerciseCollection: UICollectionView!
        var images = ["Arms","Legs","Abs","Butt"]
    
    @IBOutlet var gifImage: UIImageView!
    
    var categoryGroup: [Category] = []
    var selectedCategoryGroup: Category?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        if (User.currentUser?.id_user==nil){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
            self.present(nextViewController, animated:true, completion:nil)
        }

        

        
   
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.soundTrainer()
        })
   
        do {
            if let fileURL = Bundle.main.path(forResource: "Backgroud", ofType: "m4a") {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
                
                try backgroundMusic.shared.audioPlayer = AVAudioPlayer (contentsOf: URL(fileURLWithPath: fileURL))
                
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                
                
                backgroundMusic.shared.audioPlayer?.prepareToPlay()
                backgroundMusic.shared.audioPlayer?.play()
                backgroundMusic.shared.audioPlayer?.numberOfLoops = -1
            } else {
                print("No file with specified name exists")
            }
        } catch let error {
            print("Can't play the audio file failed with an error \(error.localizedDescription)")
        }
        
        
        


        
        print("user : \(User.currentUser?.id_user)")
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        self.exerciseCollection.backgroundColor = UIColor(white: 1, alpha: 0)
        self.gifImage.loadGif(name: "1")

        self.exerciseCollection.dataSource = self
        self.exerciseCollection.delegate = self
        
    
//
//                sound = URL(string: "http://tssnp.com/ws_bartrainer/sounds/backgroud.mp3")
//                let soundItem = AVPlayerItem(url: sound!)
//                audioPlayer = AVPlayer(playerItem: soundItem)
//                audioPlayer?.play()
       

        
        Alamofire.request("http://tssnp.com/ws_bartrainer/category.php").responseData { response in
            if let data = response.result.value {
                
                do {
                    let decoder = JSONDecoder()
                    
                    self.categoryGroup = try decoder.decode([Category].self, from: data)
                    
                    self.exerciseCollection.reloadData()
                    
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                print("error")
            }
        }
        
        


  

    }
    func soundTrainer(){
        
        
        do {
            let number = Int.random(in: 1 ..< 4)
            if let fileURL = Bundle.main.path(forResource: "hello\(number)", ofType: "m4a") {
                audioPlayerTrainer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
                
                audioPlayerTrainer?.setVolume(10, fadeDuration: 0)
                audioPlayerTrainer?.play()
                
            } else {
                print("No file with specified name exists")
            }
        } catch let error {
            print("Can't play the audio file failed with an error \(error.localizedDescription)")
        }
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        if    backgroundMusic.shared.audioPlayer?.isPlaying == false{
            
            backgroundMusic.shared.audioPlayer?.prepareToPlay()
            backgroundMusic.shared.audioPlayer?.play()
            backgroundMusic.shared.audioPlayer?.numberOfLoops = -1
                    self.tabBarController?.tabBar.isHidden = false
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
    }


    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ExList" {
            let vc = segue.destination as! ExerciseListViewController
            vc.selectedCategoryGroup = selectedCategoryGroup
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryGroup.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exercise_collection", for: indexPath) as! ExerciseCollectionViewCell
        var model = categoryGroup[indexPath.row]
        cell.iconImageView.image = UIImage(named: model.name)
          cell.headerLabel.text = model.name
        
        if Int(model.id)! == 2 {
            cell.arLabel.isHidden = true
        } else{
            cell.arLabel.isHidden =  false
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategoryGroup = categoryGroup[indexPath.row]
        performSegue(withIdentifier: "ExList", sender: self)
        

        
    }
        
        
  


}
class backgroundMusic {
    
    static let shared = backgroundMusic()
    var audioPlayer :AVAudioPlayer?
}


