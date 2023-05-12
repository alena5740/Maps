//
//  InfoView.swift
//  Map
//
//  Created by Alena Sidorova on 12.05.2023.
//

import UIKit

final class InfoView: UIView {
    
    private let infoLable = UILabel()
    private let temperatureSwitcher = UISwitch()
    var model: Location?

    var customSwitch: CustomSwitch = {
        let customSwitch = CustomSwitch()
        customSwitch.translatesAutoresizingMaskIntoConstraints = false
        customSwitch.onTintColor = UIColor.blue
        customSwitch.offTintColor = UIColor.blue
        customSwitch.cornerRadius = 0.1
        customSwitch.thumbCornerRadius = 0.1
        customSwitch.thumbTintColor = UIColor.white
        customSwitch.animationDuration = 0.25
        customSwitch.labelOn.text = "F"
        customSwitch.labelOff.text = "C"
        customSwitch.areLabelsShown = true

        return customSwitch
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        setupUI()
    }
    
    private func setupUI() {
        setupInfoLabel()
        setupSwitcher()
    }
    
    private func setupInfoLabel() {
        infoLable.translatesAutoresizingMaskIntoConstraints = false
        infoLable.numberOfLines = 0
        self.addSubview(infoLable)
        NSLayoutConstraint.activate([
            infoLable.topAnchor
                .constraint(equalTo: self.topAnchor, constant: LayoutValues.InfoLabel.top),
            infoLable.bottomAnchor
                .constraint(equalTo: self.bottomAnchor, constant: LayoutValues.InfoLabel.bottom),
            infoLable.leadingAnchor
                .constraint(equalTo: self.leadingAnchor, constant: LayoutValues.InfoLabel.leading),
            infoLable.trailingAnchor
                .constraint(equalTo: self.trailingAnchor, constant: LayoutValues.InfoLabel.trailing)
        ])
    }
    
    private func setupSwitcher() {
        customSwitch.addTarget(self, action: #selector(switcherChanged), for: .allEvents)
        self.addSubview(customSwitch)
        NSLayoutConstraint.activate([
            customSwitch.topAnchor.constraint(equalTo: self.centerYAnchor),
            customSwitch.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: LayoutValues.CustomSwitch.trailing),
            customSwitch.leadingAnchor.constraint(equalTo: infoLable.trailingAnchor, constant: LayoutValues.CustomSwitch.leading),
            customSwitch.widthAnchor.constraint(equalToConstant: LayoutValues.CustomSwitch.width),
            customSwitch.heightAnchor.constraint(equalToConstant: LayoutValues.CustomSwitch.height)])
    }

    func configure() {
        guard model != nil else { return }
        let celsius = self.model?.tempCelsius ?? 0.0
        let fahrenheit = self.model?.tempFahrenheit ?? 0.0
        let temperature: String = customSwitch.isOn ? String(celsius) + " C" : String(fahrenheit) + " F"
        let city = self.model?.city ?? "Не найдено"
        let lat = self.model?.latitude ?? 0.0
        let lon = self.model?.longitude ?? 0.0
        infoLable.text = """
    Lat: \(lat), Lon: \(lon)
    City: \(city)
    Temperature: \(temperature)
    """
    }
    
    @objc private func switcherChanged() {
        configure()
    }
}

private struct LayoutValues {
    struct InfoLabel {
        static let top: CGFloat = 16.0
        static let bottom: CGFloat = -16.0
        static let leading: CGFloat = 16.0
        static let trailing: CGFloat = -112.0
    }
    struct CustomSwitch {
        static let leading: CGFloat = 16.0
        static let height: CGFloat = 40.0
        static let width: CGFloat = 80.0
        static let trailing: CGFloat = -16.0
    }
}
