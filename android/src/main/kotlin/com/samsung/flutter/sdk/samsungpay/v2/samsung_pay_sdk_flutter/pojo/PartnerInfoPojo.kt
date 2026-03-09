package com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo

import android.os.Bundle
import com.google.gson.JsonObject
import com.google.gson.annotations.SerializedName

data class PartnerInfoPojo(

    @field:SerializedName("data")
    val data: JsonObject? = null,

    @field:SerializedName("ServiceId")
    val serviceId: String? = null
){
    fun getBundle(): Bundle {
        val bundleData= Bundle()
        data?.keySet()?.forEach {
            bundleData.putString(it,data.get(it).asString)
        }
        return bundleData
    }
}