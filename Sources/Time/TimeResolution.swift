//
//  TimeResolution.swift
//
//
//  Created by Dr. Brandon Wiley on 2/26/24.
//

import Foundation

public enum TimeResolution: UInt8, Codable
{
    case milliseconds
    case nanoseconds
    case seconds
}
