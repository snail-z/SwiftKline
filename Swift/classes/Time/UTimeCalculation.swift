//
//  UTimeCalculation.swift
//  swiftKline
//
//  Created by zhanghao on 2020/11/3.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import UIKit

internal class UTimeCalculation {

    /// 价格最大值和最小值
    private(set) var pricePeakValue = UPeakValue.zero
    
    /// 涨幅最大值和最小值
    private(set) var changeRatePeakValue = UPeakValue.zero
    
    /// 成交量最大值和最小值
    private(set) var volumePeakValue = UPeakValue.zero
    
    /// 大盘成交量最大值和最小值
    private(set) var leadVolumePeakValue = UPeakValue.zero
    
    /// 参考价 (昨收价)
    private(set) var referenceValue: Double = 0
    
    /// 重新计算
    internal func recalculate() {
        guard let _ = target.dataList else { return }
        referenceValue = getReferenceValue()
        pricePeakValue = calculatePricePeakValue()
        changeRatePeakValue = calculateChangeRatePeakValue()
        volumePeakValue = calculateVolumePeakValue()
        leadVolumePeakValue = calculateLeadVolumePeakValue()
    }
    
    private func getReferenceValue() -> Double {
        if let refValue = target.frameReference?._referenceValue {
            return refValue
        } else {
            return target.dataList?.first?._latestPrice ?? 0
        }
    }
    
    private func calculatePricePeakValue() -> UPeakValue {
        if
            let max = target.frameReference?._maxPrice,
            let min = target.frameReference?._minPrice {
            return UPeakValue(max: max, min: min)
        } else {
            // 计算当前价最大跨度
            let spanLatestPrice = target.dataList!.spanValue(reference: referenceValue, { $0._latestPrice })
            // 计算均价最大跨度
            let spanAveragePrice: Double = target.dataList!.spanValue(reference: referenceValue, { $0._averagePrice })
            // 获取较大跨度
            var spanValue = fmax(spanLatestPrice, spanAveragePrice)
            // 若跨度无效则使用默认比率
            if !spanValue.isValid {
                spanValue = target.preference.defaultChange / 100 * referenceValue
            }
            // 计算最大最小值
            return UPeakValue(max: referenceValue + spanValue, min: referenceValue - spanValue)
        }
    }
    
    private func calculateChangeRatePeakValue() -> UPeakValue {
        if
            let max = target.frameReference?._maxChangeRate,
            let min = target.frameReference?._minChangeRate {
            return UPeakValue(max: max, min: min)
        } else {
            var peakValue = UPeakValue.zero
            if referenceValue > 0 {
                peakValue.max = (pricePeakValue.max - referenceValue) / referenceValue
                peakValue.min = (pricePeakValue.min - referenceValue) / referenceValue
            } else {
                peakValue.max = target.preference.defaultChange / 100
                peakValue.min = -target.preference.defaultChange / 100
            }
            return peakValue
        }
    }
    
    private func calculateVolumePeakValue() -> UPeakValue {
        if
            let max = target.frameReference?._maxVolume,
            let min = target.frameReference?._minVolume {
            return UPeakValue(max: max, min: min)
        } else {
            return target.dataList!.peakValue({ $0._volume })
        }
    }
    
    private func calculateLeadVolumePeakValue() -> UPeakValue {
        guard let _ = target.dataList?.first?._leadRgbVolume else {
            return .zero
        }
        return target.dataList!.peakValue({ $0._leadRgbVolume })
    }
    
    internal init(target: UTimeView) {
        self.target = target
    }
    
    internal private(set) weak var target: UTimeView!
}
