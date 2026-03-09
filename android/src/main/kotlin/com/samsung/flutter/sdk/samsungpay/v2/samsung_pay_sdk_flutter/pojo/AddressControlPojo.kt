package com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo

import com.google.gson.Gson
import com.google.gson.JsonObject
import com.google.gson.annotations.SerializedName
import com.samsung.android.sdk.samsungpay.v2.payment.CustomSheetPaymentInfo
import com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.utils.AddressConverter

data class AddressControlPojo(
	@field:SerializedName("controltype")
	val controltype: String? = null,

	@field:SerializedName("controlId")
	val controlId: String? = null,

	@field:SerializedName("sheetItem")
	val sheetItem:JsonObject?=null,

	@field:SerializedName("address")
	val address: JsonObject? = null,

	@field:SerializedName("displayOption")
	val displayOption: Int?,

	@field:SerializedName("errorCode")
	val errorCode: Int?,

	@field:SerializedName("sheetUpdatedListener")
	val sheetUpdatedListener: Boolean
){
	fun getSheetItem(): SheetItemPojo {
		return Gson().fromJson(sheetItem.toString(), SheetItemPojo::class.java)
	}

	fun getAddress():CustomSheetPaymentInfo.Address{
		return  AddressConverter.getAddressConverter(address.toString())
	}
}
