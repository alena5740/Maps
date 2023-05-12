//
//  InfoCell.swift
//  Map
//
//  Created by Alena Sidorova on 12.05.2023.
//

import UIKit

final class InfoCell: UITableViewCell {

    static let reuseIdentifier = "InfoCell"

    private let infoView = InfoView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        infoView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(infoView)
        NSLayoutConstraint.activate([
            infoView.topAnchor
                .constraint(equalTo: contentView.topAnchor, constant: LayoutValues.InfoView.top),
            infoView.bottomAnchor
                .constraint(equalTo: contentView.bottomAnchor, constant: LayoutValues.InfoView.bottom),
            infoView.leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor, constant: LayoutValues.InfoView.leading),
            infoView.trailingAnchor
                .constraint(equalTo: contentView.trailingAnchor, constant: LayoutValues.InfoView.trailing)
        ])
    }

    func configure(model: Location) {
        infoView.model = model
        infoView.configure()
    }
}

private struct LayoutValues {
    struct InfoView {
        static let top: CGFloat = 16.0
        static let bottom: CGFloat = -16.0
        static let leading: CGFloat = 16.0
        static let trailing: CGFloat = -16.0
    }
}
