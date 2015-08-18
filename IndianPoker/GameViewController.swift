//
//  GameViewController.swift
//  IndianPoker
//
//  Created by Jae Hoon Lee on 8/17/15.
//  Copyright (c) 2015 Jae Hoon Lee. All rights reserved.
//

import UIKit
import CoreMotion

class GameViewController: UIViewController {
    var socket: SocketIOClient?
    var roomId: String!
    var hasCard: Bool = false
    let motionManager = CMMotionManager()
    
    var currentSuit: String?
    var currentNumber: String?
    
    
    @IBOutlet var numberLabels: [UILabel]!
    @IBOutlet var suitLabels: [UILabel]!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var getCardButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var leaveGameButton: UIButton!
    
    override func viewDidLoad() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        socket = appDelegate.socket
        
        socket?.on("dealCard") { data, ack in
            print("Dealt card")
            
            if let d = data {
                if self.hasCard == false {
                    self.currentSuit = d[0]["suit"] as? String
                    self.currentNumber = d[0]["number"] as? String
                    self.statusLabel.text = "Put in forehead"

                    
                    if self.currentSuit == "Spade" {
                        for suit in self.suitLabels {
                            suit.text = "♠︎"
                            suit.textColor = UIColor.blackColor()
                        }
                        for num in self.numberLabels {
                            num.textColor = UIColor.blackColor()
                        }
                    } else if self.currentSuit == "Diamond" {
                        for suit in self.suitLabels {
                            suit.text = "♦︎"
                            suit.textColor = UIColor.redColor()
                        }
                        for num in self.numberLabels {
                            num.textColor = UIColor.redColor()
                        }
                    } else if self.currentSuit == "Heart" {
                        for suit in self.suitLabels {
                            suit.text = "♥︎"
                            suit.textColor = UIColor.redColor()
                        }
                        for num in self.numberLabels {
                            num.textColor = UIColor.redColor()
                        }
                    } else if self.currentSuit == "Clover" {
                        for suit in self.suitLabels {
                            suit.text = "♣︎"
                            suit.textColor = UIColor.blackColor()

                        }
                        for num in self.numberLabels {
                            num.textColor = UIColor.blackColor()
                        }
                    }
                    
                    for num in self.numberLabels {
                        num.text = self.currentNumber
                    }
                    
                    self.hasCard = true
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if motionManager.deviceMotionAvailable {
            for suit in self.suitLabels {
                suit.hidden = true
            }
            
            for num in self.numberLabels {
                num.hidden = true
            }
            
            self.statusLabel.hidden = false
            self.getCardButton.hidden = false
            self.leaveGameButton.hidden = false
            self.shuffleButton.hidden = false
            let mainQueue = NSOperationQueue.mainQueue()
            
            motionManager.startDeviceMotionUpdatesToQueue(mainQueue) {
                (motion, error) in
                
                
                let roll = motion!.attitude.roll
                                
                if roll > -3.3 && roll < -2 || roll > 1 {
                    for suit in self.suitLabels {
                        suit.hidden = false
                    }
                    
                    for num in self.numberLabels {
                        num.hidden = false
                    }
                    
                    
                    self.statusLabel.hidden = true
                    self.getCardButton.hidden = true
                    self.leaveGameButton.hidden = true
                    self.shuffleButton.hidden = true
                    
                } else {
                    
                    for suit in self.suitLabels {
                        suit.hidden = true
                    }
                    
                    for num in self.numberLabels {
                        num.hidden = true
                    }

                    self.statusLabel.hidden = false
                    self.getCardButton.hidden = false
                    self.leaveGameButton.hidden = false
                    self.shuffleButton.hidden = false
                }
            }
        }
        
        socket?.emit("getCard", roomId)
    }

    @IBAction func newGameButtonPressed(sender: UIButton) {
        hasCard = false
        socket?.emit("newGame", roomId)
    }
    
    @IBAction func shuffleButtonPressed(sender: UIButton) {
        socket?.emit("shuffle", roomId)
    }
    
    @IBAction func leaveGameButtonPressed(sender: UIButton) {
        socket?.emit("leave", roomId)

        
    }
    
}
