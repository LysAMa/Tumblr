//
//  PhotosViewController.swift
//  Tumblr
//
//  Created by MacBookPro9 on 9/16/18.
//  Copyright © 2018 MacBookPro9. All rights reserved.
//

import UIKit
import Alamofire


class PhotosViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate{
    
  

    @IBOutlet weak var TVPhoto: UITableView!
    var posts: [[String: Any]] = []
     var isMoreDataLoading = false
    var refreshControl: UIRefreshControl!
    var loadingMoreView:InfiniteScrollActivityView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        TVPhoto.delegate = self
        TVPhoto.dataSource = self
        
        TVPhoto.rowHeight = 200
        TVPhoto.estimatedRowHeight = 250

        // Do any additional setup after loading the view.
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(PhotosViewController.didPullToRefresh(_:)), for: .valueChanged)
        
        // Network request snippet
        fetchPhotos()
        didPullToRefresh(refreshControl)
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: TVPhoto.contentSize.height, width: TVPhoto.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        TVPhoto.addSubview(loadingMoreView!)
        
        var insets = TVPhoto.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        TVPhoto.contentInset = insets
        
       
    }
    
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl){
        
        fetchPhotos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // ------------------ METHODS ---------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.posts.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = TVPhoto.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - TVPhoto.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && TVPhoto.isDragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: TVPhoto.contentSize.height, width: TVPhoto.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()

                // ... Code to load more results ...
                  loadMoreData()
            }
        }
    }
    
    func loadMoreData() {
        
        // ... Create the NSURLRequest (myRequest) ...
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        var myRequest = URLRequest(url: url)
    
        
        // Configure session so that completion handler is executed on main UI thread
        let session = URLSession(configuration: URLSessionConfiguration.default,
                                 delegate:nil,
                                 delegateQueue:OperationQueue.main
        )
        let task : URLSessionDataTask = session.dataTask(with: myRequest, completionHandler: { (data, response, error) in
            
            // Update flag
            self.isMoreDataLoading = false
            
            // ... Use the new data to update the data source ...
            // Update flag
            self.isMoreDataLoading = false
            
            // Stop the loading indicator
            self.loadingMoreView!.stopAnimating()
            
            // Reload the tableView now that there is new data
            self.TVPhoto.reloadData()
        })
        task.resume()
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
    
    func fetchPhotos() {
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
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 25))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 0, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1;
        
        // Set the avatar
        profileView.af_setImage(withURL: URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")!)
        headerView.addSubview(profileView)
        
        let dateLabel = UILabel(frame: CGRect(x: 50, y: 5, width: 250, height: 15))
        let post = posts[section]
        if let date = post["date"] as? String {
            dateLabel.text = date
        }
        
        headerView.addSubview(dateLabel)
        
        return headerView
    }
    
    
    
    //------------------END METHODS------------------
   

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destinationViewController.
            
            
                    let vc = segue.destination as! PhotoDetailsViewController
                    let cell = sender as! UITableViewCell
                    let indexPath = TVPhoto.indexPath(for: cell)!
                    let post = posts[indexPath.section]
                    let photos = post["photos"] as! [[String: Any]]
                    let photo = photos[0]
                    let originaliSize = photo["original_size"] as! [String: Any]
                    let urlString = originaliSize["url"] as! String
                    vc.imageURL = URL(string: urlString)
                
                
                // Pass the selected object to the new view controller.
            }
    
    
    class InfiniteScrollActivityView: UIView {
        var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        static let defaultHeight:CGFloat = 60.0
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupActivityIndicator()
        }
        
        override init(frame aRect: CGRect) {
            super.init(frame: aRect)
            setupActivityIndicator()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            activityIndicatorView.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
        }
        
        func setupActivityIndicator() {
            activityIndicatorView.activityIndicatorViewStyle = .gray
            activityIndicatorView.hidesWhenStopped = true
            self.addSubview(activityIndicatorView)
        }
        
        func stopAnimating() {
            self.activityIndicatorView.stopAnimating()
            self.isHidden = true
        }
        
        func startAnimating() {
            self.isHidden = false
            self.activityIndicatorView.startAnimating()
        }
    }
    
}
    

