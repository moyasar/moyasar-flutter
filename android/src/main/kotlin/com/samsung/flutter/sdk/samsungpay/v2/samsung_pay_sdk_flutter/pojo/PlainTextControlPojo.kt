package com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo

import com.google.gson.JsonObject
import com.google.gson.annotations.SerializedName
import com.google.gson.Gson
import com.samsung.android.sdk.samsungpay.v2.payment.sheet.SheetItem

data class PlainTextControlPojo(

	@field:SerializedName("controltype")
	val controltype: String? = null,

	@field:SerializedName("controlId")
	val controlId: String? = null,

	@field:SerializedName("sheetItem")
	val sheetItem: JsonObject? = null,
){
	fun getSheetItem(): SheetItem {
		val sheetItemPojo = Gson().fromJson(sheetItem.toString(), SheetItemPojo::class.java)

		if(sheetItemPojo.sValue == null)
		{
			return SheetItem.Builder()
				.setTitle(sheetItemPojo.title)
				.setSValue("")
				.build()
		}
		return SheetItem.Builder()
			.setTitle(sheetItemPojo.title)
			.setSValue(sheetItemPojo.sValue)
			.build()
	}
}