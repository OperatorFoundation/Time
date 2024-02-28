//
//  MutableTimeFactory.swift
//
//
//  Created by Dr. Brandon Wiley on 2/26/24.
//

import Foundation

public class MutableTimeFactory
{
    public func now(_ resolution: TimeResolution) -> MutableTime
    {
        let now = Date()
        return self.fromDate(resolution, now)
    }

    public func fromDate(_ resolution: TimeResolution, _ date: Date) -> MutableTime
    {
        let interval = date.timeIntervalSince1970
        switch resolution
        {
            case .nanoseconds:
                let nsTicks = UInt64(interval * Double(Time.e9))
                return MutableTime(time: Time(resolution: resolution, ticks: nsTicks))

            case .milliseconds:
                let msTicks = UInt64(interval * Double(Time.e3))
                return MutableTime(time: Time(resolution: resolution, ticks: msTicks))

            case .seconds:
                let sTicks = UInt64(interval)
                return MutableTime(time: Time(resolution: resolution, ticks: sTicks))
        }
    }
}
