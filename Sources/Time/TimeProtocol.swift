//
//  TimeProtocol.swift
//
//
//  Created by Dr. Brandon Wiley on 2/26/24.
//

import Foundation

import Datable
import Text
import Number

infix operator +

public protocol TimeProtocol:
    Codable,
    Comparable,
    Equatable,
    Hashable,
    MaybeNetworkDatable
{
    func toDate() -> Date
    func toText() -> Text
    func hour() -> Number
//    func dayOfWeek() -> Number
    func rescale(to: TimeResolution) -> Time
}
