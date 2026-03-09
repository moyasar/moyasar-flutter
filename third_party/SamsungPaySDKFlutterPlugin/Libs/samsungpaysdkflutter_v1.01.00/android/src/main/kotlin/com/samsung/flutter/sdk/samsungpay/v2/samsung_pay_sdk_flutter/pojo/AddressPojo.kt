package com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo

import android.os.Bundle
import com.google.gson.JsonObject
import com.google.gson.annotations.SerializedName

data class AddressPojo(

	@field:SerializedName("addressee")
	val addressee: String? = null,

	@field:SerializedName("addressLine1")
	val addressLine1: String? = null,

	@field:SerializedName("addressLine2")
	val addressLine2: String? = null,

	@field:SerializedName("city")
	val city: String? = null,

	@field:SerializedName("state")
	val state: String? = null,

	@field:SerializedName("countryCode")
	val countryCode: String? = null,

	@field:SerializedName("postalCode")
	val postalCode: String? = null,

	@field:SerializedName("phoneNumber")
	val phoneNumber: String? = null,

	@field:SerializedName("extraAddressInfo")
	val extraAddressInfo: JsonObject? = null,

	@field:SerializedName("email")
	val email: String? = null
){
	fun getBundle(): Bundle {
		val bundleData= Bundle()
		extraAddressInfo?.keySet()?.forEach {
			bundleData.putString(it,extraAddressInfo.get(it).asString)
		}
		return bundleData
	}
}
