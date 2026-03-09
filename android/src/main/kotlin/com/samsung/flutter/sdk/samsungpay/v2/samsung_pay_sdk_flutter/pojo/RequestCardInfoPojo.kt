package com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo

import com.google.gson.JsonArray
import com.google.gson.annotations.SerializedName
import com.samsung.android.sdk.samsungpay.v2.SpaySdk
import com.samsung.android.sdk.samsungpay.v2.SpaySdk.Brand

data class RequestCardInfoPojo(
    @field:SerializedName("brandList")
    val data: JsonArray? = null,
) {
    fun getBrandList(): ArrayList<SpaySdk.Brand> {
        val brandList = ArrayList<SpaySdk.Brand>()
        val list = data ?: return brandList
        for (i in 0 until list.size()) {
            val brand = list[i].asString
            when (brand) {
                Brand.VISA.name -> brandList.add(SpaySdk.Brand.VISA)
                Brand.MASTERCARD.name -> brandList.add(SpaySdk.Brand.MASTERCARD)
                Brand.AMERICANEXPRESS.name -> brandList.add(SpaySdk.Brand.AMERICANEXPRESS)
                Brand.CHINAUNIONPAY.name -> brandList.add(SpaySdk.Brand.CHINAUNIONPAY)
                Brand.DISCOVER.name -> brandList.add(SpaySdk.Brand.DISCOVER)
                Brand.ECI.name -> brandList.add(SpaySdk.Brand.ECI)
                Brand.PAGOBANCOMAT.name -> brandList.add(SpaySdk.Brand.PAGOBANCOMAT)
                Brand.MADA.name -> brandList.add(SpaySdk.Brand.MADA)
                else -> { }
            }
        }
        return brandList
    }
}