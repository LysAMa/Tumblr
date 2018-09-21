//
//  PhotoDetailsViewController.swift
//  Tumblr
//
//  Created by MacBookPro9 on 9/20/18.
//  Copyright © 2018 MacBookPro9. All rights reserved.
//

import UIKit

fileprivate let PhotoPreviewSegueIden = "PhotoPreview"

class PhotoDetailsViewController: UIViewController {
    var image: UIImage!
    
    @IBOutlet weak var ImageDetails: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ImageDetails.image = image
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
