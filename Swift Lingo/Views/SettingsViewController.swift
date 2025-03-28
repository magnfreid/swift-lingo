//
//  SettingsViewController.swift
//  Swift Lingo
//
//  Created by Nicholas Samuelsson Jeria on 2025-03-26.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
   
    
    
    @IBOutlet weak var picker: UIPickerView!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        setDarkMode()
        //        setupUI()
        picker.delegate = self
        customButtonSetup()
        ThemeManager.shared.setTheme(view: self.view)
    }
    
    let themes = ThemeColors.allCases
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return themes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(describing: ThemeColors.allCases[row]).capitalized
    }
    
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        let themeColor = themes[picker.selectedRow(inComponent: 0)]
        ThemeManager.shared.setTheme(themeColor: themeColor)
        dismiss(animated: true, completion: nil)
    }
    
    
    
    private func customButtonSetup() {
        
        let navBackButton = UIButton(type: .system)
        navBackButton.setTitle("Back", for: .normal)
        navBackButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        navBackButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        navBackButton.sizeToFit()
        navBackButton.addTarget(self, action: #selector(dismissNav), for: .touchUpInside)
        
        let buttonItem = UIBarButtonItem(customView: navBackButton)
        navigationItem.leftBarButtonItem = buttonItem
        
    }
    
    @objc private func dismissNav() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
   // @IBAction func darkModeSwitched(_ sender: UISwitch) {
        //        let selectedDark = sender.isOn
        //        UserDefaultsManager.shared.saveDarkMode(isOn: selectedDark)
        //
        //        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
        //           let window = windowScene.windows.first {
        //           window.overrideUserInterfaceStyle = selectedDark ? .dark : .light
        //
        //        }
        //
        //        self.overrideUserInterfaceStyle = selectedDark ? .dark : .light
        //        self.view.backgroundColor = .systemBackground
        //        self.darkModeLabel.textColor = .label
        //
        //    }
        //
        //    private func setDarkMode() {
        //
        //        let isDark = UserDefaultsManager.shared.loadDarkMode()
        //        darkModeSwitch.isOn = isDark
        //        overrideUserInterfaceStyle = isDark ? .dark : .light
        //
        //    }
        //
        //
        
        
        //    extension SettingsViewController {
        //
        //        //    private func setupUI() {
        //        //        view.backgroundColor = .systemBackground
        //        //        darkModeLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        //        //        darkModeLabel.textColor = .label
        //        //        darkModeSwitch.onTintColor = .systemBlue
        //        //
        //        //    }
        //
        //
        //    }
        
        //Vad säger vi med koden? vad gör vi?
        
   // }
}
