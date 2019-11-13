//
//  ViewController.swift
//  Project2
//
//  Created by William Fernandez on 10/6/19.
//  Copyright © 2019 William Fernandez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    var countries = [String]()
    var correctAnswer = 0
    var score = 0
    var counter = 0
    var highScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Check Score", style: .plain, target: self, action: #selector(addTapped))

        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
    
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        let defaults = UserDefaults.standard

        if let highestScore = defaults.object(forKey: "highScore") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                highScore = try jsonDecoder.decode(Int.self, from: highestScore)
            } catch {
                print("Failed to load view count.")
            }
        }

        askQuestion()
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        correctAnswer = Int.random(in: 0...2)
        title = countries[correctAnswer].uppercased() + " Score: \(score)"
    }
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let wrongMessageAlert = "Wrong! That's the flag of \(countries[correctAnswer])"
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            score -= 1
            title = wrongMessageAlert
        }
        
        counter += 1
        
        if counter < 10 {
        let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Final Score", message: "Your final score is \(score).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Play Again", style: .default, handler: askQuestion))
            
            if score > highScore {
                let beatScore = UIAlertController(title: "You beat your high score!", message: nil, preferredStyle: .alert)
                beatScore.addAction(UIAlertAction(title: "Continue", style: .default) { action in
                    self.present(ac, animated: true)
                    })
                present(beatScore, animated: true)
                highScore = score
                save()
            } else {
                present(ac, animated: true)
            }
            score = 0
            counter = 0
        }
        
    }
    
    @objc func addTapped() {
        let scoreAlert = UIAlertController(title: "Score", message: "Your score is \(score)", preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Continue", style: .cancel, handler: nil)
        scoreAlert.addAction(continueAction)
        present(scoreAlert, animated: true)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(highScore) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "highScore")
        } else {
            print("Failed to save high score.")
        }
    }
    
}

