package com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.utils

import com.google.gson.Gson
import com.samsung.android.sdk.samsungpay.v2.payment.CustomSheetPaymentInfo
import com.samsung.android.sdk.samsungpay.v2.payment.sheet.SheetUpdatedListener
import com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo.CustomSheetPaymentInfoPojo

object CustomSheetPaymentInfoConverter {
    fun getCustomSheetPaymentInfo(
        customSheetPaymentInfoJsonString: String,
        sheetUpdatedListener: SheetUpdatedListener?
    ): CustomSheetPaymentInfo {
        println("getCustomSheetPaymentInfo called")
        val customSheetPaymentInfoPojo = Gson().fromJson(customSheetPaymentInfoJsonString, CustomSheetPaymentInfoPojo::class.java)
        val customSheetPaymentInfo = CustomSheetPaymentInfo.Builder()
        if(customSheetPaymentInfoPojo.merchantCountryCode != null){
            customSheetPaymentInfo.setMerchantCountryCode(customSheetPaymentInfoPojo.merchantCountryCode)
        }
        return customSheetPaymentInfo.setMerchantId(customSheetPaymentInfoPojo.merchantId)
            .setMerchantName(customSheetPaymentInfoPojo.merchantName)
            .setOrderNumber(customSheetPaymentInfoPojo.orderNumber)
            .setAddressInPaymentSheet(customSheetPaymentInfoPojo.getAddressInPaymentSheet())
            .setAllowedCardBrands(customSheetPaymentInfoPojo.getAllowedCardBrand())
//            .setCardInfo(customSheetPaymentInfoPojo.getCardInfo())
            .setCardHolderNameEnabled(customSheetPaymentInfoPojo.isCardHolderNameRequired)
            .setRecurringEnabled(customSheetPaymentInfoPojo.isRecurring)
            .setCustomSheet(customSheetPaymentInfoPojo.getCustomSheet(sheetUpdatedListener))
            .setExtraPaymentInfo(customSheetPaymentInfoPojo.getBundle())
            .build()
    }
}