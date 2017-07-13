//
//  Utils.swift
//  BroxelCodingTest
//
//  Created by Emmanuel Casañas Cruz on 7/12/17.
//  Copyright © 2017 Emmanuel. All rights reserved.
//


import Foundation


public class Utils {
	
	class func getCelciusfromKelvin (kelvin : Double) -> String  {
		let temperatureInKelvin = Double(kelvin)
		let temperatureInCelsius = temperatureInKelvin - 273.15
		return String(format: "%.0f ºC", temperatureInCelsius)
	}
	
}

