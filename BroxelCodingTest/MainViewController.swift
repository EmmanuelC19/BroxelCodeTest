//
//  MainViewController.swift
//
//
//  Created by Emmanuel on 12/07/17.
//
//

import UIKit
import GooglePlaces
import Alamofire
import SVProgressHUD

class MainViewController: UIViewController,GMSAutocompleteResultsViewControllerDelegate {
	
	@IBOutlet weak var emptyView: UIView!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var messageLabel: UILabel!
	
	@IBOutlet weak var streetLabel: UILabel!
	@IBOutlet weak var numberLabel: UILabel!
	@IBOutlet weak var Neighborhood: UILabel!
	@IBOutlet weak var stateLabel: UILabel!
	@IBOutlet weak var cityLabel: UILabel!
	@IBOutlet weak var zipCodeLabel: UILabel!
	
	
	
	var resultsViewController: GMSAutocompleteResultsViewController?
	var searchController: UISearchController?
	var resultView: UITextView?
	var hasNeighborhood = false
	var postalCode = ""
	var weatherView : WeatherView?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		resultsViewController = GMSAutocompleteResultsViewController()
		resultsViewController?.delegate = self
		
		searchController = UISearchController(searchResultsController: resultsViewController)
		searchController?.searchResultsUpdater = resultsViewController
		
		// Put the search bar in the navigation bar.
		searchController?.searchBar.sizeToFit()
		navigationItem.titleView = searchController?.searchBar
		
		searchController?.searchBar.placeholder = "Ingresa una dirección"
		
		// When UISearchController presents the results view, present it in
		// this view controller, not one further up the chain.
		definesPresentationContext = true
		
		// Prevent the navigation bar from being hidden when searching.
		searchController?.hidesNavigationBarDuringPresentation = false
		
		let nc = NotificationCenter.default
		nc.addObserver(forName:Notification.Name(rawValue:"CloseQRView"), object:nil, queue:nil) {
			notification in
			self.closeScreen()
		}
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	// Turn the network activity indicator on and off again.
	func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
	}
	
	func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = false
	}
	
	func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
	                       didAutocompleteWith place: GMSPlace) {
		searchController?.isActive = false
		
		self.emptyView.isHidden = true
		self.hasNeighborhood = false
		// Do something with the selected place.
		
		self.streetLabel.text = getInfoFromPlace(place: place, value: "route")
		self.numberLabel.text = getInfoFromPlace(place: place, value: "street_number")
		self.Neighborhood.text = getInfoFromPlace(place: place, value: "neighborhood")
		self.cityLabel.text = getInfoFromPlace(place: place, value: "locality")
		self.stateLabel.text = getInfoFromPlace(place: place, value: "administrative_area_level_1")
		self.zipCodeLabel.text = getInfoFromPlace(place: place, value: "postal_code")
		
		if !hasNeighborhood {
			self.Neighborhood.text = getInfoFromPlace(place: place, value: "sublocality_level_1")
		}
		
		
		
		print("Place address: \(String(describing: place.formattedAddress))")
		print("Place attributions: \(String(describing: place.attributions))")
	}
	
	func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
	                       didFailAutocompleteWithError error: Error){
		// TODO: handle the error.
		
		imageView.image = UIImage(named: "error-icon")
		messageLabel.text = error.localizedDescription
		
	}
	
	func getInfoFromPlace(place: GMSPlace, value: String) -> String{
		
		let address = place.addressComponents
		var info = "No hay información"
		
		
		for element in address! {
			if element.type == value {
				info = element.name
			}
		}
		
		return getTitleForLabel(type: value, value: info)
	}
	
	func getTitleForLabel(type:String, value:String) -> String {
		switch type {
		case "street_number":
			return "Número: \(String(describing: value))"
		case "route":
			return "Calle: \(String(describing: value))"
		case "sublocality_level_1":
			return "Colonia: \(String(describing: value))"
		case "neighborhood":
			if (value != "No hay información"){
				hasNeighborhood = true
			}
			return "Colonia: \(String(describing: value))"
		case "locality":
			return "Ciudad: \(String(describing: value))"
		case "administrative_area_level_1":
			return "Estado: \(String(describing: value))"
		case "postal_code":
			if (value != "No hay información"){
				postalCode = value
			}
			return "Código Postal: \(String(describing: value))"
		default:
			return value
		}
		
	}
	
	@IBAction func clickCheckWeather(_ sender: Any) {
		self.sendRequestRequest()
	}
	
	
	func sendRequestRequest() {
		
		SVProgressHUD.show(withStatus: "Checando el clima en tu ciudad...")
		/**
		Request
		get http://api.openweathermap.org/data/2.5/weather
		*/
		
		// Add URL parameters
		let urlParams = [
			"zip":"01400,mx",
			"appid":"bd1b00636cb7798b63bba0d9ebb1e55d",
			]
		
		// Fetch Request
		Alamofire.request("http://api.openweathermap.org/data/2.5/weather", method: .get, parameters: urlParams)
			.validate(statusCode: 200..<300)
			.responseJSON { response in
				if (response.result.error == nil) {
					debugPrint("HTTP Response Body: \(String(describing: response.data))")
					do {
						if let dictionaryOK = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
							
							print(dictionaryOK)
							
							DispatchQueue.main.async {
								SVProgressHUD.dismiss()
								let weather = Weather(dictionary: dictionaryOK["main"] as! Dictionary<String, AnyObject>)
								let info = dictionaryOK["weather"] as! [Dictionary<String, AnyObject>]
								let selected = info[0]
								
								self.weatherView = WeatherView.instantiateFromNib()
								self.weatherView?.cityNameLabel.text = dictionaryOK["name"] as? String
								self.weatherView?.weatherDescriptionLabel.text = selected["description"] as? String

								self.weatherView?.tempLabel.text = Utils.getCelciusfromKelvin(kelvin: weather.temp)
									self.weatherView?.show()
								self.weatherView?.maxTempLabel.text = "Temperatura Máxima: " + Utils.getCelciusfromKelvin(kelvin: weather.temp_max)
								self.weatherView?.minTempLabel.text = "Temperatura Mínima: " +  Utils.getCelciusfromKelvin(kelvin: weather.temp_min)
							}
						}
					} catch {
						DispatchQueue.main.async {
							SVProgressHUD.showError(withStatus: error.localizedDescription)
						}
					}
					
				} else {
					debugPrint("HTTP Request failed: \(String(describing: response.result.error))")
					DispatchQueue.main.async {
					SVProgressHUD.showError(withStatus: response.result.error as! String)
					}
				}
		}
	}
	
	func closeScreen() {
		
			
			UIView.transition(with: self.weatherView!,
			                  duration: 0.25,
			                  options: [.transitionCrossDissolve],
			                  animations: {
								
								self.weatherView?.remove()
			}, completion: nil)
			
		
		_ = navigationController?.popToRootViewController(animated: true)
	}
	
	
	

	
}

public extension UIView {
	
	public class func instantiateFromNib<T: UIView>(viewType: T.Type) -> T {
		return Bundle.main.loadNibNamed(String(describing: viewType), owner: nil, options: nil)?.first as! T
	}
	
	public class func instantiateFromNib() -> Self {
		return instantiateFromNib(viewType: self)
	}
	
}


