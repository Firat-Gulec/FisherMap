//
//  ButtonModels.swift
//  FisherMap
//
//  Created by Fırat GÜLEÇ on 2.10.2021.
//

import UIKit
import Foundation



//Buttons Model
private let floatingButton: UIButton = {
    let button = UIButton(frame: CGRect(x: 0, y: 0,
                                        width: 60, height: 60))
    button.layer.shadowRadius = 10
    button.layer.shadowOpacity = 0.3
    //button.layer.masksToBounds = true
    button.layer.cornerRadius = 20
    button.backgroundColor = .systemPink
    let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
    button.setImage(image, for: .normal)
    button.tintColor = .white
    button.setTitleColor(.white, for: .normal)
    return button
    
}()
private let measureButton: UIButton = {
    let button = UIButton(frame: CGRect(x: 0, y: 0,
                                        width: 40, height: 40))
    button.layer.shadowRadius = 10
    button.layer.shadowOpacity = 0.3
    //button.layer.masksToBounds = true
    button.layer.cornerRadius = 20
    button.backgroundColor = .systemPink
    let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
    button.setImage(image, for: .normal)
    button.tintColor = .white
    button.setTitleColor(.white, for: .normal)
    return button
    
}()
private let setancorButton: UIButton = {
    let button = UIButton(frame: CGRect(x: 0, y: 0,
                                        width: 40, height: 40))
    button.layer.shadowRadius = 10
    button.layer.shadowOpacity = 0.3
    //button.layer.masksToBounds = true
    button.layer.cornerRadius = 20
    button.backgroundColor = .systemPink
    let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
    button.setImage(image, for: .normal)
    button.tintColor = .white
    button.setTitleColor(.white, for: .normal)
    return button
    
}()
private let savecatchButton: UIButton = {
    let button = UIButton(frame: CGRect(x: 0, y: 0,
                                        width: 40, height: 40))
    button.layer.shadowRadius = 10
    button.layer.shadowOpacity = 0.3
    //button.layer.masksToBounds = true
    button.layer.cornerRadius = 20
    button.backgroundColor = .systemPink
    let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
    button.setImage(image, for: .normal)
    button.tintColor = .white
    button.setTitleColor(.white, for: .normal)
    return button
    
}()
private let savecurrentButton: UIButton = {
    let button = UIButton(frame: CGRect(x: 0, y: 0,
                                        width: 40, height: 40))
    button.layer.shadowRadius = 10
    button.layer.shadowOpacity = 0.3
    //button.layer.masksToBounds = true
    button.layer.cornerRadius = 20
    button.backgroundColor = .systemPink
    let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
    button.setImage(image, for: .normal)
    button.tintColor = .white
    button.setTitleColor(.white, for: .normal)
    return button
    
}()
