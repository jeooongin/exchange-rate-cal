//
//  PickerViewController.swift
//  ExchangeRateCal
//
//  Created by jeongin on 2022/12/13.
//

import UIKit

class PickerViewController: UIViewController {

    @IBOutlet weak var inputKrw: UITextField!
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var outputSeledCountry: UITextField!
    @IBOutlet weak var selectedCountry: UILabel!
    
    var rate: [(String, Double)]?
    
    var selectRow = 0 {
        didSet {
            selectedCountry.text = rate?[selectRow].0
            outputSeledCountry.text = calculateExchangeRate()
        }
    }
    
    func calculateExchangeRate() -> String {
        let selectedValue = rate?[selectRow].1 ?? 0
        let krwValue = Double(inputKrw.text ?? "") ?? 0
        let resultValue = String(format: "%.2f", (selectedValue * krwValue))
        return resultValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "환율 계산기"
        
        countryPicker.delegate = self
        countryPicker.dataSource = self
        
        inputKrw.delegate = self
        
        fetchJson()
    }
    
    func fetchJson() {
        Task {
            do {
                let model = try await ExchangeRateAPI.fetchJson()
                self.rate = model.rates?.sorted{$0.key < $1.key}
                self.countryPicker.reloadAllComponents()
                
            } catch {
                print(error)
            }
        }
    }

}

extension PickerViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        outputSeledCountry.text = calculateExchangeRate()
    }
}

extension PickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rate?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let key = rate?[row].0 ?? ""
        let value = rate?[row].1.description ?? ""
        return key + "  " + value
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectRow = row
    }
    
}
