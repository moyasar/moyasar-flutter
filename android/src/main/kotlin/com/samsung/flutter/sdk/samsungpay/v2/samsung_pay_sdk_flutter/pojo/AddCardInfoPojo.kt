package com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo

import android.os.Bundle
import com.google.gson.JsonObject
import com.google.gson.annotations.SerializedName

data class AddCardInfoPojo(

	@field:SerializedName("cardType")
	val cardType: String? = null,

	@field:SerializedName("cardDetail")
	val cardDetail: JsonObject? = null,

	@field:SerializedName("tokenizationProvider")
	val tokenizationProvider: String? = null
){
	fun getBundle(): Bundle {
		val bundleData=Bundle()
		cardDetail?.keySet()?.forEach {
			bundleData.putString(it,cardDetail.get(it).asString)
		}
		return bundleData
	}
}
