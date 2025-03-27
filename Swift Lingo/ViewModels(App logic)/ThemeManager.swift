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
        UILabel.appearance().textColor = currentTheme?.labelTextColor
        UIButton.appearance().setTitleColor(
            currentTheme?.buttonTextColor, for: .normal)
        UIButton.appearance().tintColor = currentTheme?.buttonTintColor
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
                    labelTextColor: .black,
                    buttonTextColor: .white,
                    buttonTintColor: .systemBlue
                )
            case .dark:
                return Theme(
                    viewBackgroundColor: .black,
                    labelTextColor: .white,
                    buttonTextColor: .white,
                    buttonTintColor: .systemPurple
                )
            case .orange:
                return Theme(
                    viewBackgroundColor: .systemOrange,
                    labelTextColor: .white,
                    buttonTextColor: .white,
                    buttonTintColor: .systemPink
                )
            case .green:
                return Theme(
                    viewBackgroundColor: .systemGreen,
                    labelTextColor: .white,
                    buttonTextColor: .white,
                    buttonTintColor: .systemMint
                )
            case .red:
                return Theme(
                    viewBackgroundColor: .systemRed,
                    labelTextColor: .white,
                    buttonTextColor: .white,
                    buttonTintColor: .systemOrange
                )
            }
        }

    }
}
