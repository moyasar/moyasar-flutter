package com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.utils

import android.os.Bundle
import com.google.gson.Gson
import com.samsung.android.sdk.samsungpay.v2.PartnerInfo
import com.samsung.android.sdk.samsungpay.v2.SamsungPay
import com.samsung.android.sdk.samsungpay.v2.SpaySdk
import com.samsung.android.sdk.samsungpay.v2.card.AddCardInfo
import com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo.AddCardInfoPojo
import com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo.PartnerInfoPojo

object PartnerInfoConverter{
    fun getPartnerInfo(partnerInfoJsonString: String): PartnerInfo {
        val partnerInfoPojo = Gson().fromJson(partnerInfoJsonString, PartnerInfoPojo::class.java)
        return PartnerInfo(partnerInfoPojo.serviceId,partnerInfoPojo.getBundle())
    }
}