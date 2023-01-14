//
//  CurrencyRateTableViewController.swift
//  CurrencyRates
//
//  Created by Quien on 2023/1/13.
//

import UIKit

class CurrencyRateTableViewController: UITableViewController {
  
  var currencies = [String : Double]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    Task {
      do {
        let currencies = try await CurrencyController.shared.fetchCurrencyRatesBaseOnCAD()
        updateUI(with: currencies)
      } catch {
        displayError(error, title: "Failed to Fetch CurrencyList Rates Base On CAD")
      }
    }
  }
  
  func updateUI(with currencies: [String: Double]) {
    self.currencies = currencies
    self.tableView.reloadData()
  }
  
  func displayError(_ error: Error, title: String) {
    guard let _ = viewIfLoaded?.window else { return }
    
    let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return currencies.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyRateListCell", for: indexPath)
    configureCell(cell, forCategoryAt: indexPath)
    return cell
  }
  
  func configureCell(_ cell: UITableViewCell, forCategoryAt indexPath: IndexPath) {
    let currency = Array(currencies)[indexPath.row]
    var content = cell.defaultContentConfiguration()
    content.text = currency.key
    content.secondaryText = String(currency.value)
    cell.contentConfiguration = content
  }
  
}
