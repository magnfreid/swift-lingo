//
//  SettingsViewController.swift
//  Swift Lingo
//
//  Created by Nicholas Samuelsson Jeria on 2025-03-26.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var darkModeLabel: UILabel!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setDarkMode()
//        setupUI()
       customButtonSetup()
        ThemeManager.shared.setTheme(view: self.view)
    }
    
    private func customButtonSetup() {
        
        let navBackButton = UIButton(type: .system)
        navBackButton.setTitle("Back", for: .normal)
        navBackButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        navBackButton.tintColor = .label
        navBackButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        navBackButton.sizeToFit()
        navBackButton.addTarget(self, action: #selector(dismissNav), for: .touchUpInside)
        
        let buttonItem = UIBarButtonItem(customView: navBackButton)
        navigationItem.leftBarButtonItem = buttonItem
        
    }
    
    @objc private func dismissNav() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func darkModeSwitched(_ sender: UISwitch) {
//        let selectedDark = sender.isOn
//        UserDefaultsManager.shared.saveDarkMode(isOn: selectedDark)
//        
//        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//           let window = windowScene.windows.first {
//            window.overrideUserInterfaceStyle = selectedDark ? .dark : .light
//            
//        }
//        
//        self.overrideUserInterfaceStyle = selectedDark ? .dark : .light
//        self.view.backgroundColor = .systemBackground
//        self.darkModeLabel.textColor = .label
//        
    }
    
    private func setDarkMode() {
        
        let isDark = UserDefaultsManager.shared.loadDarkMode()
        darkModeSwitch.isOn = isDark
        overrideUserInterfaceStyle = isDark ? .dark : .light
        
    }
    
    
}

extension SettingsViewController {
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        darkModeLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        darkModeLabel.textColor = .label
        darkModeSwitch.onTintColor = .systemBlue
        
    }
    
    
}

//Vad säger vi med koden? vad gör vi?


