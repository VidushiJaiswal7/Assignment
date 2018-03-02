//
//  ViewController.swift
//  Twitter Feed
//
//  Created by VIdushi Jaiswal on 01/03/18.
//  Copyright © 2018 Vidushi Jaiswal. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var tweets:[String] = []
    
    var activityIndicator = UIActivityIndicatorView()
    
    //MARK: Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        userImage.layer.cornerRadius = 8
        userImage.layer.masksToBounds = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Actions
    @IBAction func searchButton(_ sender: Any) {
        if searchTextField.text != "" {
            startActivityIndicator()
            let user = searchTextField.text?.replacingOccurrences(of: " ", with: "")
            getInfo(user: user!)
        }
    }
    //MARK: Helper Functions
    
    //Function to add activity indicator
    func startActivityIndicator() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    //Function to get info from twitter.com
    func getInfo(user:String) {
        let url = URL(string: "https://twitter.com/" + user)
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error ) in
            if error != nil {
                DispatchQueue.main.async {
                    if let errorMessage = error?.localizedDescription {
                        print("Error \(error?.localizedDescription)")
                        self.usernameLabel.text = errorMessage
                    } else {
                        self.usernameLabel.text = "There has been an error. Try Again"
                    }
                }
            } else {
                let webContent = String(data: data!, encoding: String.Encoding.utf8)!
                
                if webContent.contains("<title>") && webContent.contains("data-resolved-url-large=\"") {
                    //Get the name
                    var array:[String] = webContent.components(separatedBy: "<title>")
                    array = array[1].components(separatedBy: " |")
                    let name = array[0]
                    array.removeAll()
                    
                    //Get the profile picture
                    array = webContent.components(separatedBy: "data-resolved-url-large=\"")
                    array = array[1].components(separatedBy: "\"")
                    let profilePicture = array[0]
                    print(profilePicture)
                    
                    //Get the tweets
                    array = webContent.components(separatedBy: "data-aria-label-part=\"0\">")
                    array.remove(at: 0)
                    
                    for i in 0...array.count - 1 {
                        let newTweet = array[i].components(separatedBy: "<")
                        array[i] = newTweet[0]
                    }
                    
                    self.tweets = array
                    
                    DispatchQueue.main.async {
                        self.usernameLabel.text = name
                        self.updateImage(url: profilePicture)
                        self.tableView.reloadData()
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.usernameLabel.text = "Sorry, we could not find the user."
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                }

            }
        }
       task.resume()
    
    }
    
    //Function to get the image of the user
    func updateImage(url: String) {
        let url = URL(string: url)
        let task = URLSession.shared.dataTask(with: url!) { (data,response,error) in
            DispatchQueue.main.async {
                self.userImage.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
    
    
    //MARK: Table View Delegate Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TweetTableViewCell
        cell.tweetTextView.text = tweets[indexPath.row]
        return cell
    }
    
    //MARK: Text Field Delegate Functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

