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
        UIButton.appearance().setTitleColor(
            currentTheme?.buttonTextColor, for: .normal)
        UIButton.appearance().tintColor = currentTheme?.buttonTintColor
        UITextField.appearance().backgroundColor = currentTheme?.textFieldBackgroundColor
        UITextField.appearance().textColor = currentTheme?.textColor
        view?.backgroundColor = currentTheme?.viewBackgroundColor
    }
}

//MARK: Themes
extension ThemeManager {

    enum ThemeColors {
        case light, dark, orange, green, red

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
                    viewBackgroundColor: .systemOrange,
                    textColor: .white,
                    buttonTextColor: .white,
                    buttonTintColor: .systemPink,
                    textFieldBackgroundColor: .white
                )
            case .green:
                return Theme(
                    viewBackgroundColor: .systemGreen,
                    textColor: .white,
                    buttonTextColor: .white,
                    buttonTintColor: .systemMint,
                    textFieldBackgroundColor: .black
                )
            case .red:
                return Theme(
                    viewBackgroundColor: .systemRed,
                    textColor: .white,
                    buttonTextColor: .white,
                    buttonTintColor: .systemOrange,
                    textFieldBackgroundColor: .black
                )
            }
        }

    }
}
