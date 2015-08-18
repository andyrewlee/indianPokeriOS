//
//  ViewController.swift
//  IndianPoker
//
//  Created by Jae Hoon Lee on 8/17/15.
//  Copyright (c) 2015 Jae Hoon Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var socket: SocketIOClient?
    var roomId: String?
    
    @IBOutlet weak var joinGameLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        socket = appDelegate.socket
    }

    @IBAction func joinGamePressed(sender: UIButton) {
        roomId = joinGameLabel.text
        performSegueWithIdentifier("GameSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GameSegue" {
            socket?.emit("joinRoom", roomId!)
            let controller = segue.destinationViewController as! GameViewController
            controller.roomId = roomId!
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backToJoin(segue: UIStoryboardSegue) {
        self.presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
    }


}

