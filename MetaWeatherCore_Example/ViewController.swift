//
//  ViewController.swift
//  MetaWeatherCore_Example
//
//  Created by Alejandro Zalazar on 21/04/2022.
//

import UIKit
import MetaWeatherCore

class ViewController: UIViewController {
    
    @IBOutlet weak var searchResultsCollectionView: UICollectionView!
    @IBOutlet weak var searchCityTextField: UITextField!
    
    var vSpinner : UIView?
    
    var locations: [WeatherLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultsCollectionView.backgroundColor = .white
        
        searchCityTextField.delegate = self
        searchCityTextField.layer.borderColor = UIColor.gray.cgColor
        searchCityTextField.layer.borderWidth = 1.0
        searchCityTextField.layer.cornerRadius = searchCityTextField.bounds.height / 2
        
        let flowLayout = UICollectionViewFlowLayout()
        let space: CGFloat = 1.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.scrollDirection = .vertical
        searchResultsCollectionView.collectionViewLayout = flowLayout
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
        searchResultsCollectionView.showsVerticalScrollIndicator = false
        searchResultsCollectionView.showsHorizontalScrollIndicator = false
        searchResultsCollectionView.isPagingEnabled = false
        searchResultsCollectionView.register(UINib(nibName: "ResultCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ResultCollectionViewCell")
        searchResultsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DEFAULT")
    }

    @IBAction func onSearchButtonDidTapped(_ sender: Any) {
        searchCity()
    }
    
    
    func searchCity() {
        
        guard let city = searchCityTextField.text, !city.isEmpty else { return }
        
        showSpinner(onView: self.view)
        WeatherApi().locationSearch(query: city) { locations, error in
            
            self.removeSpinner()
            
            if let locations = locations {
                self.locations = locations
                self.searchResultsCollectionView.reloadData()
            }
        }
    }
}

extension ViewController: UITextFieldDelegate {
    // Use this if you have a UITextField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        // make sure the result is under 16 characters
        return updatedText.count <= 16
    }
}


extension ViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
}


// MARK: UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        locations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultCollectionViewCell", for: indexPath) as? ResultCollectionViewCell else { return UICollectionViewCell()}
        
        let location = locations[indexPath.row]
        
        cell.idLabel.text = cell.idLabel.text?.replacingOccurrences(of: "$ID", with: "\(location.woeid)")
        cell.nameLabel.text = cell.nameLabel.text?.replacingOccurrences(of: "$NAME", with: location.title)
        cell.latlongLabel.text = cell.latlongLabel.text?.replacingOccurrences(of: "$latlong", with: location.latt_long)
        
        return cell
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 70.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
