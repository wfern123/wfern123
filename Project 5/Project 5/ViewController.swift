//
//  ViewController.swift
//  Project 5
//
//  Created by William Fernandez on 10/11/19.
//  Copyright © 2019 William Fernandez. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(startGame))
        // assign the text file to the constant
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // pass the contents of the text file to the constant
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        // checks to see if array is empty
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        // starts the game when the view loads
        startGame()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    
    @objc func startGame() {
        // designate title to have random word
        title = allWords.randomElement()
        // removes all of the user's used words
        usedWords.removeAll(keepingCapacity: true)
        // reloads the tableView
        tableView.reloadData()
    }

    @objc func promptForAnswer() {
        // alert controller for entering answer
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        // add text field to alert controller
        ac.addTextField()
        // everything before action in describes the closure, and everthing after action in is the closure. the weak keywords is to avoid a strong reference cycle.
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            // capture the text in the textfield and submit the answer
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        // make the user input lower case
        let lowerAnswer = answer.lowercased()

        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    if isLongEnough(word: lowerAnswer) {
                    // insert the word into the usedWords array as lower case. if you don't implement this, and if you enter a used word but with different case, it will not recognize it in the array
                    usedWords.insert(lowerAnswer, at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    // inserts the row into the tob of the table view with a slide in animation
                    tableView.insertRows(at: [indexPath], with: .automatic)

                    return
                    } else {
                        showErrorMessage(errorTitle: "Word too short", errorMessage: "Come up with a longer word!")
                    }
                } else {
                    showErrorMessage(errorTitle: "Word not real", errorMessage: "You can't just make up words!")
                }
            } else {
                showErrorMessage(errorTitle: "Word used already", errorMessage: "Be more original!")
            }
        } else {
            // we wrap title with an optional because the title may not have a value
            guard let title = title?.lowercased() else {return}
            showErrorMessage(errorTitle: "Word not possible", errorMessage: "You can't spell that word from \(title)!")
        }
    }
    // this function sorts through each letter in the word and determines if the spelt word is possible using the title word's letters
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        // loops through each letter in the word and removes the letter from the temporary word stored
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }

        return true
    }
    // checks to make sure that the user didn't type in the same word
    func isOriginal(word: String) -> Bool {
        if (word == title) {
            return false
        }
        return !usedWords.contains(word)
    }
    // checks to see if the word is real
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        // returns true if there is no mispelledRange
        return misspelledRange.location == NSNotFound
    }
    
    func isLongEnough(word: String) -> Bool {
        return word.count > 2 ? true : false
    }
    // loads the error message
    func showErrorMessage(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }


}

