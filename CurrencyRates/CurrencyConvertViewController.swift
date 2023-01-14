//
//  CurrencyConvertViewController.swift
//  CurrencyRates
//
//  Created by Quien on 2023/1/13.
//

import UIKit

class CurrencyConvertViewController: UIViewController {
  
  @IBOutlet weak var currenyTextField: UITextField!
  @IBOutlet weak var currencyButton: UIButton!
  @IBOutlet weak var rateLabel: UILabel!
  
  var rate: Double?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func updateUI(with rate: Double) {
    self.rate = rate
    rateLabel.text = "1 \(currenyTextField.text!.uppercased()) = \(rate) CAD"
  }
  
  func displayError(_ error: Error, title: String) {
    guard let _ = viewIfLoaded?.window else { return }
    
    let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  
  @IBAction func convertButtonTapped(_ sender: UIButton) {
    let currency = currenyTextField.text
    if !currency!.isEmpty {
      Task {
        do {
          let rate = try await CurrencyController.shared.fetchCurrencyRateBaseOnCAD(forCurrency: currency!.lowercased())
          updateUI(with: rate)
        } catch {
          displayError(error, title: "Failed to Fetch Convert")
        }
      }
    }

  }
  
}
