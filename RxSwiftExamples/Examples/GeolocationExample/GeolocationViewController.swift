//
//  GeolocationViewController.swift
//  RxSwiftExamples
//
//  Created by Nelo on 2022/2/15.
//


import RxSwift
import CoreLocation


private extension Reactive where Base: UILabel {
    var coordinates: Binder<CLLocationCoordinate2D> {
        return Binder(base) { label, location in
            label.text = "Lat: \(location.latitude)\nLon: \(location.longitude)"
        }
    }
}

class GeolocationViewController: ViewController {

    @IBOutlet weak var jumpBtn: UIButton!
    @IBOutlet weak var jump2Btn: UIButton!
    @IBOutlet weak var displayLbl: UILabel!
    @IBOutlet weak var noGeoloactionView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let geolocationService = GeolocationService.instance
        
        geolocationService.authorized
            .drive(noGeoloactionView.rx.isHidden)
            .disposed(by: disposeBag)
        
        geolocationService.location
            .drive(displayLbl.rx.coordinates)
            .disposed(by: disposeBag)
        
        jumpBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.openAppPreferences()
            })
            .disposed(by: disposeBag)
        
        jump2Btn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.openAppPreferences()
            })
            .disposed(by: disposeBag)
    }
    
    private func openAppPreferences() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
}
