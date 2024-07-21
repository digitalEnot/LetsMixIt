//
//  FilterVC.swift
//  LetsMixIt
//
//  Created by Evgeni Novik on 19.06.2024.
//

import UIKit

protocol FilterDelegate: AnyObject {
    func didPressedButton()
}

final class FilterVC: UIViewController {
    let textForRangeSlider = UILabel()
    let rangeSliderLabel = UILabel()
    let btn = UIButton()
    // LMIRangeSlider не поддерживает autoLayout
    let rangeSlider = LMIRangeSlider(frame: CGRect(x: 20, y: 120, width: UIScreen.main.bounds.width - 20 - 100, height: 40))
    var minProof = 0
    var maxProof = 50
    
    weak var delegate: FilterDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavBarItems()
        configureButton()
        configureRangeSlider()
        configureRangeSliderText()
        configureRangeSliderLabel()
        configureStateOfTheSubmitButton()
        configureConstraints()
    }
    
    
    private func configureNavBarItems() {
        let cancelButton = UIBarButtonItem(image: UIImage(systemName: "xmark.circle.fill"), style: .done, target: self, action: #selector(dismissVC))
        cancelButton.tintColor = .systemGray3
        navigationItem.rightBarButtonItem = cancelButton
        
        let clearButton = UIBarButtonItem(title: "Очистить", style: .done, target: self, action: #selector(clearButton))
        clearButton.tintColor = UIColor(hex: "#FF7F50")
        navigationItem.leftBarButtonItem = clearButton
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)
        ]
    }
    
    private func configureRangeSliderLabel() {
        view.addSubview(rangeSliderLabel)
        rangeSliderLabel.text = "Крепкость"
        rangeSliderLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        rangeSliderLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureButton() {
        view.addSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Показать результаты"
        configuration.baseForegroundColor = .white
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            return outgoing
        }
        configuration.baseBackgroundColor = UIColor(hex: "#FF7F50")
        btn.configuration = configuration
        btn.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        btn.isEnabled = false
    }
    
    
    private func configureRangeSlider() {
        view.addSubview(rangeSlider)
        rangeSlider.addTarget(self, action: #selector(sliderAction), for: .valueChanged)
    }
    
    
    private func configureRangeSliderText() {
        view.addSubview(textForRangeSlider)
        textForRangeSlider.translatesAutoresizingMaskIntoConstraints = false
        textForRangeSlider.text = "\(rangeSlider.minimumValue) - \(rangeSlider.maximumValue)"
    }
    
    
    private func configureConstraints(){
        NSLayoutConstraint.activate([
            rangeSliderLabel.bottomAnchor.constraint(equalTo: rangeSlider.topAnchor, constant: -5),
            rangeSliderLabel.leadingAnchor.constraint(equalTo: rangeSlider.leadingAnchor),
            
            textForRangeSlider.centerYAnchor.constraint(equalTo: rangeSlider.centerYAnchor),
            textForRangeSlider.centerXAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            btn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            btn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            btn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            btn.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    
    func configureStateOfTheSubmitButton() {
        if (rangeSlider.minimumValue == minProof && rangeSlider.maximumValue == maxProof)
            && (minProof == 0 && maxProof == 50) {
            btn.isEnabled = false
        } else {
            btn.isEnabled = true
        }
    }
    
    
    @objc func sliderAction(sender: LMIRangeSlider) {
        let minVal = rangeSlider.minimumValue
        let maxVal = rangeSlider.maximumValue
        textForRangeSlider.text = minVal == maxVal ? "\(minVal)" : "\(minVal) - \(maxVal)"
        configureStateOfTheSubmitButton()
    }
    
    
    @objc func buttonPressed() {
        minProof = rangeSlider.minimumValue
        maxProof = rangeSlider.maximumValue
        delegate?.didPressedButton()
        self.dismiss(animated: true)
    }
    
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    
    @objc func clearButton() {
        rangeSlider.setRangeToDefaultFalues()
    }
}
