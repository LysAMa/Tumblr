//
//  PhotoDetailsViewController.swift
//  Tumblr
//
//  Created by MacBookPro9 on 9/20/18.
//  Copyright © 2018 MacBookPro9. All rights reserved.
//

import UIKit
import AlamofireImage




class PhotoDetailsViewController: UIViewController {
    
    @IBOutlet weak var DetailsImage: UIImageView!
    
    var imageURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        DetailsImage.af_setImage(withURL: imageURL)
       
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
