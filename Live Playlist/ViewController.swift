//
//  ViewController.swift
//  Live Playlist
//
//  Created by Alejandro Cano on 10/21/17.
//  Copyright © 2017 Alejandro Cano. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var getStartedbttn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Button customization
        getStartedbttn.layer.cornerRadius = 24.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func mainBttn(_ sender: Any) {
        
        self.performSegue(withIdentifier: "firstSegue", sender: nil)

    }
}

