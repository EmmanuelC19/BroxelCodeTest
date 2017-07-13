//
//  Weather.swift
//  BroxelCodingTest
//
//  Created by Emmanuel Casañas Cruz on 7/12/17.
//  Copyright © 2017 Emmanuel. All rights reserved.
//

import Foundation

class Weather: NSObject {
	
	var temp : Double
	var pressure : Double
	var humidity : Double
	var temp_min : Double
	var temp_max : Double

	
	init(dictionary: Dictionary<String, AnyObject>) {
		temp = dictionary["temp"] as? Double ?? 0.0
		pressure = dictionary["pressure"] as? Double ?? 0.0
		humidity = dictionary["humidity"] as? Double ?? 0.0
		temp_min = dictionary["temp_min"] as? Double ?? 0.0
		temp_max = dictionary["temp_max"] as? Double ?? 0.0
	}
}
