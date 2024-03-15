//
//  TimeDuration.swift
//
//
//  Created by Dr. Brandon Wiley on 2/27/24.
//

import Foundation

import Datable
import Number
import Text

public struct TimeDuration
{
    public static func < (lhs: TimeDuration, rhs: TimeDuration) -> Bool
    {
        let rescaled = rhs.rescale(to: lhs.resolution)
        return lhs.ticks < rescaled.ticks
    }

    public var data: Data
    {
        let typeByte = self.resolution.rawValue
        let typeData = Data(array: [typeByte])

        return typeData + self.ticks.maybeNetworkData!
    }

    public let resolution: TimeResolution
    public let ticks: UInt64

    public init?(data: Data)
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

    @available(iOS 16, macOS 14, *)
    public func toDuration() -> Duration
    {
        switch self.resolution
        {
            case .nanoseconds:
                return Duration.nanoseconds(self.ticks)

            case .milliseconds:
                return Duration.milliseconds(self.ticks)

            case .seconds:
                return Duration.seconds(self.ticks)
        }
    }

    @available(iOS 16, macOS 14, *)
    public func toText() -> Text
    {
        let date = self.toDuration()
        let string = date.description
        return string.text
    }

    public func rescale(to targetResolution: TimeResolution) -> TimeDuration
    {
        switch self.resolution
        {
            case .nanoseconds:
                switch targetResolution
                {
                    case .nanoseconds:
                        return TimeDuration(resolution: targetResolution, ticks: self.ticks)

                    case .milliseconds:
                        return TimeDuration(resolution: targetResolution, ticks: self.ticks / Time.e6)

                    case .seconds:
                        return TimeDuration(resolution: targetResolution, ticks: self.ticks / Time.e9)
                }

            case .milliseconds:
                switch targetResolution
                {
                    case .nanoseconds:
                        return TimeDuration(resolution: targetResolution, ticks: self.ticks * Time.e6)

                    case .milliseconds:
                        return TimeDuration(resolution: targetResolution, ticks: self.ticks)

                    case .seconds:
                        return TimeDuration(resolution: targetResolution, ticks: self.ticks / Time.e3)
                }

            case .seconds:
                switch targetResolution
                {
                    case .nanoseconds:
                        return TimeDuration(resolution: targetResolution, ticks: self.ticks * Time.e9)

                    case .milliseconds:
                        return TimeDuration(resolution: targetResolution, ticks: self.ticks * Time.e3)

                    case .seconds:
                        return TimeDuration(resolution: targetResolution, ticks: self.ticks)
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

extension TimeDuration: CustomStringConvertible
{
    public var description: String
    {
        switch self.resolution
        {
            case .milliseconds:
                return "\(self.ticks) milliseconds"

            case .nanoseconds:
                return "\(self.ticks) nanoseconds"

            case .seconds:
                return "\(self.ticks) seconds"
        }
    }
}
