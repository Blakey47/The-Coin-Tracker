//
//  ViewController.swift
//  The Coin Tracker
//
//  Created by Darragh Blake on 11/12/2019.
//  Copyright © 2019 Darragh Blake. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI() {
        setupPickerView()
    }
    
    func setupPickerView() {
        menuView.layer.cornerRadius = 30
    }

    @IBAction func toggleMenuButton(_ sender: Any) {
        
        if menuView.transform == .identity {
            UIView.animate(withDuration: 1, animations: {
                self.menuView.backgroundColor = .white
                self.menuView.transform = CGAffineTransform(translationX: 0, y: -283)
                self.menuButton.setBackgroundImage(UIImage(systemName: "minus.circle"), for: UIControl.State.normal)
                self.menuButton.transform = CGAffineTransform(translationX: 0, y: -290)
            }) { (true) in
                
            }
        } else {
            UIView.animate(withDuration: 1, animations: {
                self.menuView.transform = .identity
                self.menuView.backgroundColor = .clear
                self.menuButton.transform = .identity
                self.menuButton.setBackgroundImage(UIImage(systemName: "plus.circle"), for: UIControl.State.normal)
            }) { (true) in
                
            }
        }
        
    }
    

}


