//
//  TimeFactory.swift
//
//
//  Created by Dr. Brandon Wiley on 2/27/24.
//

import Foundation

public class TimeFactory
{
    public func now(_ resolution: TimeResolution) -> Time
    {
        let now = Date()
        return self.fromDate(resolution, now)
    }

    public func fromDate(_ resolution: TimeResolution, _ date: Date) -> Time
    {
        let interval = date.timeIntervalSince1970
        switch resolution
        {
            case .nanoseconds:
                let nsTicks = UInt64(interval * Double(Time.e9))
                return Time(resolution: resolution, ticks: nsTicks)

            case .milliseconds:
                let msTicks = UInt64(interval * Double(Time.e3))
                return Time(resolution: resolution, ticks: msTicks)

            case .seconds:
                let sTicks = UInt64(interval)
                return Time(resolution: resolution, ticks: sTicks)
        }
    }
}
