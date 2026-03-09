package com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo

import android.os.Bundle
import com.google.gson.JsonObject
import com.google.gson.annotations.SerializedName
import com.samsung.android.sdk.samsungpay.v2.SpaySdk

data class PaymentCardInfoPojo(
	@field:SerializedName("brand")
	val brand: SpaySdk.Brand? = null,

	@field:SerializedName("cardId")
	val cardId: String? = null,

	@field:SerializedName("cardMetaData")
	val cardMetaData: JsonObject? = null,
)
{
	fun getBundle(): Bundle {
		val bundleData= Bundle()
		cardMetaData?.keySet()?.forEach {
			bundleData.putString(it,cardMetaData.get(it).asString)
		}
		return bundleData
	}
}
