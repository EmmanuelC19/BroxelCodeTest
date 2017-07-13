//
//  CustomViewHelper.swift
//  BroxelCodingTest
//
//  Created by Emmanuel Casañas Cruz on 7/12/17.
//  Copyright © 2017 Emmanuel. All rights reserved.
//

import Foundation
import UIKit

enum device : CGFloat {
	case iPhone4 = 480
	case iPhonne5 = 568
	case iPhone7 = 667
	case iPhone7p = 736
	
	var value: CGFloat {
		return self.rawValue
	}
	
}


// Mark - Alert for Review Merchant
public class CustomViewHelper {
	
	class func getRectForAlert() -> CGRect {
		let screenSize: CGRect = UIScreen.main.bounds
		
		switch screenSize.height {
		case device.iPhone4.rawValue:
			return CGRect(x: (screenSize.width / 2 ) - 150, y: 50, width: 300, height: 428)
		case device.iPhonne5.rawValue:
			return CGRect(x:  (screenSize.width / 2 ) - 150, y: 100, width: 300, height: 428)
		case device.iPhone7.rawValue:
			return CGRect(x:  (screenSize.width / 2 ) - 150, y: 130, width: 300, height: 428)
		case device.iPhone7p.rawValue:
			return CGRect(x:  (screenSize.width / 2 ) - 150, y: 150, width: 300, height: 428)
		default:
			return CGRect(x:  (screenSize.width / 2 ) - 150, y: 200, width: 300, height: 428)
		}
		
	}
}
