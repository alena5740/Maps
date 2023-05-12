//
//  InfoBottomSheet.swift
//  Map
//
//  Created by Alena Sidorova on 12.05.2023.
//

import UIKit

protocol InfoBottomSheetProtocol {
    func updateView(model: Location)
}

final class InfoBottomSheet: UIViewController {
    
    private let infoView = InfoView()

    private let presenter : MapPresenterProtocol

    init(presenter : MapPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }


    func updateView() {
        guard let model = presenter.getWeatherModel() else { return }
        self.infoView.model = model
        self.infoView.configure()
    }

    private func setupUI() {
        setupScreen()
        setupInfoView()
    }
    
    private func setupScreen() {
        view.backgroundColor = .white  
    }
    
    private func setupInfoView() {
        infoView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(infoView)
        NSLayoutConstraint.activate([
            infoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            infoView.topAnchor.constraint(equalTo: view.topAnchor),
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
