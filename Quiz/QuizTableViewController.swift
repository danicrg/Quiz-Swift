//
//  QuizTableViewController.swift
//  Quiz
//
//  Created by Daniel Carlander on 17/11/2018.
//  Copyright © 2018 Daniel Carlander. All rights reserved.
//

import UIKit

class QuizTableViewController: UITableViewController {
    
    var token: String = "bc0e796d7d9eaf927fff"
    var quizzes: [[String: Any]] = []
    var session: URLSession!
    fileprivate var images = [String:UIImage]()
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getQuizzes()
    }
    
    @IBAction
    func getQuizzes(){
        self.quizzes = []
        refreshButton.isEnabled = false
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let queue = DispatchQueue(label: "quiz download queue", attributes: DispatchQueue.Attributes.concurrent)
        var quizPages = true
        var i = 0
        queue.async {
            while quizPages {
                i += 1
                
                let quizzes_url = "https://quiz2019.herokuapp.com/api/quizzes?token=\(self.token)&pageno=\(i)"
                let url = URL(string: quizzes_url)!
                if let data = try? Data(contentsOf: url),
                    let response = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    let quizzes = response?["quizzes"] as? [[String: Any]]
                    if quizzes?.count != 0 {
                        DispatchQueue.main.async {
                            self.quizzes += quizzes!
                            
                        }
                    } else {
                        DispatchQueue.main.async {
                            quizPages = false
                            self.tableView.reloadData()
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.refreshButton.isEnabled = true
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
            
        }
    }
        
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quiz", for: indexPath) as? QuizTableViewCell

        let quiz = quizzes[indexPath.row]
        let author = quiz["author"] as? [String: Any]
        let attachment = quiz["attachment"] as? [String: Any]
        
        cell?.questionLabel?.text = quiz["question"] as? String
        cell?.authorLabel?.text = author?["username"] as? String
        if let imageUrl = attachment?["url"] as? String {
            if let image = images[imageUrl] {
                cell?.quizImage.image = image
            } else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                if let url = URL(string: imageUrl) {
                    let queue = DispatchQueue(label: "Image Download Queue")
                    queue.async {
                        if let data = try? Data(contentsOf: url),
                            let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.images[imageUrl] = image
                                self.tableView.reloadRows(at: [indexPath], with: .fade)
                                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            }
                        }
                    }
                }
            }
        }
        

        return cell!
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Quiz" {
            if let qvc = segue.destination as? QuizViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let quiz = quizzes[indexPath.row]
                    let attachment = quiz["attachment"] as? [String: String]
                    let url = attachment?["url"]
                    qvc.quizData = quiz
                    print(url!)
                    qvc.quizImage = images[url!]
                    
                }
            }
        }
    }
 

    
    
}
