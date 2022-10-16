//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Ferhat Adiyeke on 14.10.2022.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var texrtField: UITextField!
    @IBOutlet var pcikerView: UIPickerView!
    
    
    var currencyCode: [String] = []
    var values: [Double] = []
    var activeCurrency = 0.0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        pcikerView.delegate = self
        pcikerView.dataSource = self
        
        fetchJSON()
        texrtField.addTarget(self, action: #selector(updateViews), for: .editingChanged)
    }
    
    @objc func updateViews(input: Double) {
        guard let amountText = texrtField.text, let theAmountText = Double(amountText) else { return}
        if texrtField.text != "" {
            let total = theAmountText * activeCurrency
            priceLabel.text = String(format: "%.2f", total)
        }
    }
    

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyCode.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyCode[row]

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            
        activeCurrency = values[row]
        updateViews(input: activeCurrency)
    }
    
    
    func fetchJSON() {
        guard let url = URL(string: "https://open.er-api.com/v6/latest") else { return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            
            
            guard let safeData = data else { return}
            
            
            do {
                let results = try JSONDecoder().decode(ExchangeRates.self, from: safeData)
                self.currencyCode.append(contentsOf: results.rates.keys)
                self.values.append(contentsOf: results.rates.values)
                DispatchQueue.main.async {
                    self.pcikerView.reloadAllComponents()
                }
            }    catch {
                    
                    print(error)
                }
                    
            }.resume()
        }
    }



