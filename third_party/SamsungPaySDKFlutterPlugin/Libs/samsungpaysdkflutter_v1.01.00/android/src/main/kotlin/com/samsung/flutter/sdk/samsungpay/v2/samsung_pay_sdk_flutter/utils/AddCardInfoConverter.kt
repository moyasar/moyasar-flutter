package com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.utils
import com.google.gson.Gson
import com.samsung.android.sdk.samsungpay.v2.card.AddCardInfo
import com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo.AddCardInfoPojo

object AddCardInfoConverter {
    fun getAddCardInfo(addCardInfoJsonString: String): AddCardInfo {
        val addCardInfoPojo = Gson().fromJson(addCardInfoJsonString, AddCardInfoPojo::class.java)
        return AddCardInfo(addCardInfoPojo.cardType.toString(),addCardInfoPojo.tokenizationProvider.toString(),addCardInfoPojo.getBundle())
    }
}