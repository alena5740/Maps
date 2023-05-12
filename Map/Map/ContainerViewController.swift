//
//  ContainerViewController.swift
//  Map
//
//  Created by Alena Sidorova on 12.05.2023.
//

import UIKit

final class ContainerViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private let contentViewController: MapViewController
    private let bottomSheetViewController: InfoBottomSheet
    
    private var topConstraint = NSLayoutConstraint()
    private let height: CGFloat
    
    private var bottomSheetIsVisible = false
        
    private lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.delegate = self
        tap.addTarget(self, action: #selector(handleTap))
        return tap
    }()
    
    
    init(contentViewController: MapViewController,
         bottomSheetViewController: InfoBottomSheet) {
        
        self.contentViewController = contentViewController
        self.bottomSheetViewController = bottomSheetViewController
        
        self.height = UIScreen.main.bounds.height * 0.6
        
        super.init(nibName: nil, bundle: nil)
        
        self.setupContentViewController()
        self.setupBottomSheetViewController()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupScreen()
        contentViewController.didTapOnLocation = { [weak self] in
            guard let self = self else { return }
            self.bottomSheetIsVisible ? self.hideBottomSheet() : self.showBottomSheet()
        }
        contentViewController.didTapOnClose = { [weak self] in
            guard let self = self else { return }
            self.bottomSheetIsVisible ? self.hideBottomSheet() : self.showBottomSheet()
        }
    }

    @objc func handleTap() {

    }
    
    private func showBottomSheet() {
        bottomSheetViewController.updateView()
        UIView.animate(withDuration: 0.2, delay: 0, animations: {
            self.topConstraint.constant = -200
            self.view.layoutIfNeeded()
        })
        bottomSheetIsVisible = true
    }

    private func setupScreen() {
        navigationItem.title = "Карты"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "👉",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(buttonTapped))
    }

    @objc func buttonTapped() {
        let vc = LocationViewController(presenter: LocationPresenter(networkService: NetworkService()))
        navigationController?.pushViewController(vc, animated: true)
    }

    private func hideBottomSheet() {
        UIView.animate(withDuration: 0.2, delay: 0, animations: {
            self.topConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
        bottomSheetIsVisible = false
    }

    
    private func setupContentViewController() {
        addChild(contentViewController)
        view.addSubview(contentViewController.view)
        makeConstraintsContentViewController()
        contentViewController.didMove(toParent: self)
    }
    
    private func makeConstraintsContentViewController() {
        contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        contentViewController.view.addGestureRecognizer(tapGesture)
        NSLayoutConstraint.activate([
            contentViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupBottomSheetViewController() {
        addChild(bottomSheetViewController)
        view.addSubview(bottomSheetViewController.view)
        makeConstraintsBottomSheetViewController()
        bottomSheetViewController.didMove(toParent: self)
    }
    
    private func makeConstraintsBottomSheetViewController() {
        bottomSheetViewController.view.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetViewController.view.layer.cornerRadius = 24.0
        
        topConstraint = bottomSheetViewController.view.topAnchor
            .constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            bottomSheetViewController.view.heightAnchor.constraint(equalToConstant: height),
            bottomSheetViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheetViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSheetViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            topConstraint
        ])
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

