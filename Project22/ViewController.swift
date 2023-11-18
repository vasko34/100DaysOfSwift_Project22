import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var beaconReading: UILabel!
    var locationManager: CLLocationManager?
    var circleView: UIView!
    var isDetected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
        
        circleView = UIView()
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.layer.cornerRadius = 128
        circleView.layer.borderWidth = 1
        circleView.layer.borderColor = UIColor.black.cgColor
        circleView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        view.addSubview(circleView)
        
        NSLayoutConstraint.activate([
            circleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            circleView.widthAnchor.constraint(equalToConstant: 256),
            circleView.heightAnchor.constraint(equalToConstant: 256)
        ])
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if let beacon = beacons.first {
            if !isDetected {
                let ac = UIAlertController(title: "Beacon detected!", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
                isDetected = true
            }
            update(distance: beacon.proximity, beacon: beacon)
        } else {
            update(distance: .unknown, beacon: nil)
        }
    }
    
    func startScanning() {
        let uuid1 = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconConstraint1 = CLBeaconIdentityConstraint(uuid: uuid1, major: 123, minor: 456)
        let beaconRegion1 = CLBeaconRegion(beaconIdentityConstraint: beaconConstraint1, identifier: "MyBeacon1")
        
        let uuid2 = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E6")!
        let beaconConstraint2 = CLBeaconIdentityConstraint(uuid: uuid2, major: 123, minor: 456)
        let beaconRegion2 = CLBeaconRegion(beaconIdentityConstraint: beaconConstraint2, identifier: "MyBeacon2")
        
        let uuid3 = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E7")!
        let beaconConstraint3 = CLBeaconIdentityConstraint(uuid: uuid3, major: 123, minor: 456)
        let beaconRegion3 = CLBeaconRegion(beaconIdentityConstraint: beaconConstraint3, identifier: "MyBeacon3")
        
        locationManager?.startMonitoring(for: beaconRegion1)
        locationManager?.startRangingBeacons(satisfying: beaconConstraint1)
        
        locationManager?.startMonitoring(for: beaconRegion2)
        locationManager?.startRangingBeacons(satisfying: beaconConstraint2)
        
        locationManager?.startMonitoring(for: beaconRegion3)
        locationManager?.startRangingBeacons(satisfying: beaconConstraint3)
    }
    
    func update(distance: CLProximity, beacon: CLBeacon?) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
                UIView.animate(withDuration: 1) { [weak self] in
                    self?.circleView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                }
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
                UIView.animate(withDuration: 1) { [weak self] in
                    self?.circleView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "RIGHT HERE"
                UIView.animate(withDuration: 1) { [weak self] in
                    self?.circleView.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
                UIView.animate(withDuration: 1) { [weak self] in
                    self?.circleView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                }
            }
            
            if let beacon = beacon {
                switch beacon.uuid.uuidString {
                case "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5":
                    self.beaconReading.text = "MyBeacon1"
                case "5A4BCFCE-174E-4BAC-A814-092E77F6B7E6":
                    self.beaconReading.text = "MyBeacon2"
                case "5A4BCFCE-174E-4BAC-A814-092E77F6B7E7":
                    self.beaconReading.text = "MyBeacon3"
                default:
                    self.beaconReading.text = "UNKNOWN"
                }
            }
        }
    }
}

