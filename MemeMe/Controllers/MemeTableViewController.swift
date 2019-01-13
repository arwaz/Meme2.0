//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Arwa Alzeaagi on 10/12/2018.
//  Copyright © 2018 udacity. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    
}
