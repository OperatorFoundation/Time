//
//  MutableTime.swift
//
//
//  Created by Dr. Brandon Wiley on 2/26/24.
//

import Foundation

import Number
import Text

public final class MutableTime: TimeProtocol
{
    public static func == (lhs: MutableTime, rhs: MutableTime) -> Bool
    {
        lhs.time == rhs.time
    }

    public static func < (lhs: MutableTime, rhs: MutableTime) -> Bool
    {
        return lhs.time < rhs.time
    }

    public var maybeNetworkData: Data?
    {
        return self.time.maybeNetworkData
    }

    public var time: Time

    public init(time: Time)
    {
        self.time = time
    }

    public init?(maybeNetworkData: Data)
    {
        guard let time = Time(maybeNetworkData: maybeNetworkData) else
        {
            return nil
        }

        self.time = time
    }

    public func hash(into hasher: inout Hasher)
    {
        hasher.combine(self.time)
    }

    public func toTime() -> Time
    {
        return self.time
    }

    public func toDate() -> Date
    {
        return self.time.toDate()
    }

    public func toText() -> Text
    {
        return self.time.toText()
    }

    public func rescale(to targetResolution: TimeResolution) -> Time
    {
        return self.time.rescale(to: targetResolution)
    }

    public func hour() -> Number
    {
        return self.time.hour()
    }

    public func seconds() -> Number
    {
        return self.time.seconds()
    }
}
