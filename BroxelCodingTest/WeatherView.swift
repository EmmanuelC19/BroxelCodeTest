//
//  WeatherView.swift
//  BroxelCodingTest
//
//  Created by Emmanuel Casañas Cruz on 7/12/17.
//  Copyright © 2017 Emmanuel. All rights reserved.
//

import UIKit

class WeatherView: UIView {

	@IBOutlet weak var cityNameLabel: UILabel!
	@IBOutlet weak var weatherDescriptionLabel: UILabel!

	@IBOutlet weak var tempLabel: UILabel!
	@IBOutlet weak var maxTempLabel: UILabel!
	@IBOutlet weak var minTempLabel: UILabel!
	
	
	@IBAction func ClickButton(_ sender: Any) {
		
		let nc = NotificationCenter.default
		nc.post(name:Notification.Name(rawValue:"CloseQRView"),object: nil,userInfo:nil)
	}
	
	
	func getAlertFrameConfig() -> CGRect{
		return CustomViewHelper.getRectForAlert()
	}
	
	func show() {
		DispatchQueue.main.async {
			let superView = UIApplication.shared.keyWindow;
			
			// Overlay view to uncapacitate users interaction
			let viewAlert = UIView()
			viewAlert.frame = UIScreen.main.bounds
			
			//let blurEffectView = self.blurEffect()
			let shadowEffectView = self.shadowEffect()
			
			// Resize and Center AlertView
			self.frame = self.getAlertFrameConfig()
			
			// Add Alert and effect to the Overlay view
			viewAlert.addSubview(shadowEffectView)
			viewAlert.addSubview(self)
			
			// Add Overlay VIew
			superView?.addSubview(viewAlert)
		}
	}
	
	func remove() {
		
		// Kill Overlay View
		self.superview?.removeFromSuperview()
	}
	
	func blurEffect() -> UIView{
		
		let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView.frame = UIScreen.main.bounds
		blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		return blurEffectView
	}
	
	func shadowEffect() -> UIView{
		
		let shadowEffectView = UIView()
		shadowEffectView.backgroundColor = UIColor.black
		shadowEffectView.alpha = 0.5
		shadowEffectView.frame = UIScreen.main.bounds
		shadowEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		return shadowEffectView
	}


}
