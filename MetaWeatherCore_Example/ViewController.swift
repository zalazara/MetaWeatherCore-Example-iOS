//
//  ViewController.swift
//  MetaWeatherCore_Example
//
//  Created by Alejandro Zalazar on 21/04/2022.
//

import UIKit
import MetaWeatherCore

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        WeatherApi().locationSearch { (response, error) -> Void in
            if let response = response {
                print(response)
            }
            
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }


}

