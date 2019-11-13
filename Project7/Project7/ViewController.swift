//
//  ViewController.swift
//  Project7
//
//  Created by William Fernandez on 10/14/19.
//  Copyright © 2019 William Fernandez. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var searchPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(info))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        let urlString: String

        if navigationController?.tabBarItem.tag == 0 {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        
        // make sure the url is valid
        if let url = URL(string: urlString) {
            // use try? to catch any errors, i.e. the internet connection is bad
            if let data = try? Data(contentsOf: url) {
                // we're ok to parse!
                parse(json: data)
                // this return statement exits out of the viewDidLoad function
                return
            }
        }
        
        showError()
    }
    
    // if the code in viewDidLoad reaches the end, runs this code
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        // stores the results into the petitions array
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            // copy the results into the original petitions array and the one for filtered results
            petitions = jsonPetitions.results
            searchPetitions = jsonPetitions.results
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = searchPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // easier to designate what vc is; if we had used the storyboard, we would have had to write out the full code to retrieve it from the storyboard
        let vc = DetailViewController()
        vc.detailItem = searchPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func info() {
        let ac = UIAlertController(title: "Information", message: "This data comes from the We The Peope API of the Whitehouse", preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Continue", style: .cancel, handler: nil)
        ac.addAction(continueAction)
        present(ac, animated: true)
    }
    
    @objc func search() {
        let ac = UIAlertController(title: "Search for petition", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            // capture the text in the textfield and submit the answer
            guard let input = ac?.textFields?[0].text else { return }
            self?.submit(filter: input)
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @objc func submit(filter: String) {
        searchPetitions.removeAll(keepingCapacity: true)
        for petition in petitions {
            if ((petition.title).lowercased().contains(filter.lowercased())) {
                searchPetitions.append(petition)
            }
        }
        tableView.reloadData()
    }
}

