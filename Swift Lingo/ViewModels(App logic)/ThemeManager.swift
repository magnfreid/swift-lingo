//
//  ThemeManager.swift
//  Swift Lingo
//
//  Created by Magnus Freidenfelt on 2025-03-27.
//

import UIKit

final class ThemeManager {

    static let shared = ThemeManager()

    var currentTheme: Theme?

    private init() {}

    func setTheme(themeColor: ThemeColors? = nil, view: UIView? = nil) {
        if let themeColor = themeColor { currentTheme = themeColor.theme }
        UILabel.appearance().textColor = currentTheme?.textColor
        UIButton.appearance().tintColor = currentTheme?.buttonTintColor
        UIButton.appearance().setTitleColor(currentTheme?.buttonTextColor, for: [.normal, .highlighted, .disabled])
        UITextField.appearance().backgroundColor = currentTheme?.textFieldBackgroundColor
        UITextField.appearance().textColor = currentTheme?.textColor
        view?.backgroundColor = currentTheme?.viewBackgroundColor
    }
}


//MARK: Themes

enum ThemeColors: CaseIterable {
        case light, dark, orange, crimson, forest, purple
    

        var theme: Theme {
            switch self {
            case .light:
                return Theme(
                    viewBackgroundColor: .white,
                    textColor: .black,
                    buttonTextColor: .white,
                    buttonTintColor: .systemBlue,
                    textFieldBackgroundColor: .white
                )
            case .dark:
                return Theme(
                    viewBackgroundColor: .black,
                    textColor: .white,
                    buttonTextColor: .white,
                    buttonTintColor: .systemPurple,
                    textFieldBackgroundColor: .black

                )
            case .orange:
                return Theme(
                    viewBackgroundColor: UIColor(named: "Orange4") ?? .systemOrange,
                    textColor:  UIColor(named: "Orange1") ?? .systemOrange,
                    buttonTextColor:  UIColor(named: "Orange1") ?? .systemOrange,
                    buttonTintColor:  UIColor(named: "Orange3") ?? .systemOrange,
                    textFieldBackgroundColor:  UIColor(named: "Orange3") ?? .systemOrange
                )
            case .crimson:
                return Theme(
                    viewBackgroundColor: UIColor(named: "Crimson4") ?? .systemOrange,
                    textColor:  UIColor(named: "Crimson1") ?? .systemOrange,
                    buttonTextColor:  UIColor(named: "Crimson1") ?? .systemOrange,
                    buttonTintColor:  UIColor(named: "Crimson3") ?? .systemOrange,
                    textFieldBackgroundColor:  UIColor(named: "Crimson3") ?? .systemOrange
                )
            case .forest:
                return Theme(
                    viewBackgroundColor: UIColor(named: "Forest4") ?? .systemCyan,
                    textColor:  UIColor(named: "Forest1") ?? .systemOrange,
                    buttonTextColor:  UIColor(named: "Forest1") ?? .systemOrange,
                    buttonTintColor:  UIColor(named: "Forest3") ?? .systemOrange,
                    textFieldBackgroundColor:  UIColor(named: "Forest3") ?? .systemOrange
                )

            case .purple:
                return Theme(
                    viewBackgroundColor: UIColor(named: "Purple4") ?? .systemCyan,
                    textColor:  UIColor(named: "Purple1") ?? .systemOrange,
                    buttonTextColor:  UIColor(named: "Purple1") ?? .systemOrange,
                    buttonTintColor:  UIColor(named: "Purple3") ?? .systemOrange,
                    textFieldBackgroundColor:  UIColor(named: "Purple3") ?? .systemOrange
                )
            }
        }

    }

