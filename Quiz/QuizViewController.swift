//
//  QuizViewController.swift
//  Quiz
//
//  Created by Daniel Carlander on 17/11/2018.
//  Copyright © 2018 Daniel Carlander. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {

    var quizData: [String: Any]!
    var quizImage: UIImage!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var answerField: UITextField!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var quizImageView: UIImageView!
    @IBOutlet weak var tipsButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        question.text = quizData["question"] as? String
        question.lineBreakMode = NSLineBreakMode.byWordWrapping
        question.sizeToFit()
        quizImageView.image = quizImage
        let tips = quizData["tips"] as? [String]
        if tips?.count == 0{
            navigationItem.rightBarButtonItems = []
        }
    }
    
    @IBAction func check(_ sender: UIButton) {
        let user_answer = answerField.text ?? "test"
        let quiz_id = quizData["id"]!
        let result_url = "https://quiz2019.herokuapp.com/api/quizzes/\(quiz_id)/check?token=bc0e796d7d9eaf927fff&answer=\(user_answer)"
        print(result_url)
        let url = URL(string: result_url)!
        var result = false
        if let data = try? Data(contentsOf: url),
            let response = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            result = (response?["result"] as? Bool)!
        }
        if result {
            alert("La respuesta es correcta!")
        } else {
            alert("Prueba otra vez!")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            print("\nentramos en prepare\n")
            if let tvc = segue.destination as? TipTableViewController {
                
                tvc.tipData = quizData["tips"] as? [String]
            }
    }
    
    func alert(_ message: String){
        let alertView = UIAlertController(title: "Resultado", message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertView, animated: true)
    }
    
}
