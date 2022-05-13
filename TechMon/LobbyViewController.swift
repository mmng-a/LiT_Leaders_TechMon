//
//  LobbyViewController.swift
//  TechMon
//
//  Created by Masashi Aso on 2022/05/13.
//

import UIKit
import AVFoundation

class LobbyViewController: UIViewController, AVAudioPlayerDelegate {
  
  var maxStamina: Float = 100
  var stamina: Float = 100
  var player = Player()
  var staminaTimer: Timer!
  
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var staminaBar: UIProgressView!
  @IBOutlet var levelLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    staminaBar.transform = CGAffineTransform(scaleX: 1.0, y: 4.0)
    nameLabel.text = player.name
    levelLabel.text = "Lv. \(player.level)"
    
    stamina = maxStamina
    staminaBar.progress = stamina / maxStamina
    staminaTimer = Timer.scheduledTimer(
      timeInterval: 1.0, target: self,selector: #selector (cureStamina),
      userInfo: nil, repeats: true
    )
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    TechDraUtil.playBGM(fileName: "lobby")
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    TechDraUtil.stopBGM()
  }
  
  @IBAction func startBattle(){
    if stamina >= 20 {
      stamina = stamina - 20
      staminaBar .progress = stamina / maxStamina
      performSegue (withIdentifier: "startBattle", sender: nil)
    } else {
      let alert = UIAlertController(title: "スタミナ不足", message: "スタミナが20以上必要です",
                                    preferredStyle: .alert)
      let action = UIAlertAction (title: "OK", style: . default, handler: nil)
      alert.addAction (action)
      present (alert, animated: true, completion: nil)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "startBattle" {
      let battleVC = segue.destination as! BattleViewController
      player.currentHP = player.maxHP
      battleVC.player = player
    }
  }
  
  @objc func cureStamina () {
    if stamina < maxStamina {
      stamina = min (stamina + 1, maxStamina)
      staminaBar.progress = stamina / maxStamina
    }
  }
}
