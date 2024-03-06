//
//  Time.swift
//
//
//  Created by Dr. Brandon Wiley on 2/26/24.
//

import Foundation

import Datable
import Number
import Text

public struct Time: TimeProtocol
{
    public static let e3: UInt64 = 1000
    public static let e6: UInt64 = 1000000
    public static let e9: UInt64 = 1000000000

    public static func < (lhs: Time, rhs: Time) -> Bool
    {
        let rescaled = rhs.rescale(to: lhs.resolution)
        return lhs.ticks < rescaled.ticks
    }
    
    public var maybeNetworkData: Data?
    {
        let typeByte = self.resolution.rawValue
        let typeData = Data(array: [typeByte])

        guard let tickData = self.ticks.maybeNetworkData else
        {
            return nil
        }

        return typeData + tickData
    }

    let resolution: TimeResolution
    let ticks: UInt64

    public init?(maybeNetworkData data: Data)
    {
        guard data.count > 1 else
        {
            return nil
        }

        let typeByte = data[0]
        let rest = Data(data[1...])

        guard let type = TimeResolution(rawValue: typeByte) else
        {
            return nil
        }

        self.init(resolution: type, data: rest)
    }

    public init(resolution: TimeResolution, ticks: UInt64)
    {
        self.resolution = resolution
        self.ticks = ticks
    }

    public init?(resolution: TimeResolution, data: Data)
    {
        guard let ticks = UInt64(maybeNetworkData: data) else
        {
            return nil
        }

        self.init(resolution: resolution, ticks: ticks)
    }

    public func toDate() -> Date
    {
        switch self.resolution
        {
            case .nanoseconds:
                return Date(timeIntervalSince1970: Double(self.ticks) / Double(Time.e9))

            case .milliseconds:
                return Date(timeIntervalSince1970: Double(self.ticks) / Double(Time.e3))

            case .seconds:
                return Date(timeIntervalSince1970: Double(self.ticks))
        }
    }

    public func toText() -> Text
    {
        let date = self.toDate()
        let string = date.description
        return string.text
    }

    public func hour() -> Number
    {
        let date = self.toDate()
        let hour = Calendar.current.component(.hour, from: date)
        return .int(hour)
    }

    public func rescale(to targetResolution: TimeResolution) -> Time
    {
        switch self.resolution
        {
            case .nanoseconds:
                switch targetResolution
                {
                    case .nanoseconds:
                        return Time(resolution: targetResolution, ticks: self.ticks)

                    case .milliseconds:
                        return Time(resolution: targetResolution, ticks: self.ticks / Time.e6)

                    case .seconds:
                        return Time(resolution: targetResolution, ticks: self.ticks / Time.e9)
                }

            case .milliseconds:
                switch targetResolution
                {
                    case .nanoseconds:
                        return Time(resolution: targetResolution, ticks: self.ticks * Time.e6)

                    case .milliseconds:
                        return Time(resolution: targetResolution, ticks: self.ticks)

                    case .seconds:
                        return Time(resolution: targetResolution, ticks: self.ticks / Time.e3)
                }

            case .seconds:
                switch targetResolution
                {
                    case .nanoseconds:
                        return Time(resolution: targetResolution, ticks: self.ticks * Time.e9)

                    case .milliseconds:
                        return Time(resolution: targetResolution, ticks: self.ticks * Time.e3)

                    case .seconds:
                        return Time(resolution: targetResolution, ticks: self.ticks)
                }
        }
    }

    public func seconds() -> Number
    {
        let secondsDuration = self.rescale(to: .seconds)
        let seconds = secondsDuration.ticks
        return Number.uint64(seconds)
    }
}

extension Time: CustomStringConvertible
{
    public var description: String
    {
        return self.toDate().description
    }
}
