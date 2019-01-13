//
//  MemeEditorCollectionViewController.swift
//  MemeMe
//
//  Created by Arwa Alzeaagi on 11/12/2018.
//  Copyright © 2018 udacity. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController{
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
