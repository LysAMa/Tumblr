//
//  PhotosViewController.swift
//  Tumblr
//
//  Created by MacBookPro9 on 9/16/18.
//  Copyright © 2018 MacBookPro9. All rights reserved.
//

import UIKit
import Alamofire


class PhotosViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    
    // ------------------ METHODS ---------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCellTableViewCell", for: indexPath) as! PhotoCellTableViewCell
        let post = posts[indexPath.row]
        if let photos = post["photos"] as? [[String: Any]] {
            // photos is NOT nil, we can use it!
            
            // 1.Get the first photo in the photos array
            let photo = photos[0]
            // 2.Get the original size dictionary from the photo
            let originalSize = photo["original_size"] as! [String: Any]
            // 3.Get the url string from the original size dictionary
            let urlString = originalSize["url"] as! String
            // 4.Create a URL using the urlString
            let url = URL(string: urlString)
            // TODO: Get the photo url
            cell.photoImageView.af_setImage(withURL: url!)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        TVPhoto.deselectRow(at: indexPath, animated: true)
    }
    //------------------END METHODS------------------

    @IBOutlet weak var TVPhoto: UITableView!
    var posts: [[String: Any]] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        TVPhoto.delegate = self
        TVPhoto.dataSource = self
        TVPhoto.rowHeight = 200
        TVPhoto.estimatedRowHeight = 250

        // Do any additional setup after loading the view.
        // Network request snippet
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print(dataDictionary)
                
                // TODO: Get the posts and store in posts property
                // Get the dictionary from the response key
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                // Store the returned array of dictionaries in our posts property
                self.posts = responseDictionary["posts"] as! [[String: Any]]
                
                // TODO: Reload the table view
                self.TVPhoto.reloadData()
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        
        if(segue.identifier == "FirstSegue"){
            let vc = segue.destination as! PhotoDetailsViewController
            let cell = sender as! UITableViewCell
            let indexPath = TVPhoto.indexPath(for: sender as! UITableViewCell)!
            
          
            
            
            }
            
            
        }
        

        // Pass the selected object to the new view controller.
    }
    


