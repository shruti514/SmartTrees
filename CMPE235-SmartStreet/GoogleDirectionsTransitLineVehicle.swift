//
//  GoogleDirectionsTransitLineVehicle.swift
//  GoogleDirections
//
//  Created by Romain on 05/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation
import UIKit

/// A type of vehicle used on a specific line
public struct GoogleDirectionsTransitLineVehicle {
	/// The name of the vehicle on a specific line, eg. "Subway."
	public var name: String?
	/// The type of vehicle that runs on a specific line
	public var type: GoogleDirectionsVehicleType?
	/// An icon associated with this vehicle type
	public var icon: UIImage?
}
