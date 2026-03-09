package com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo

import android.os.Bundle
import com.google.gson.JsonObject
import com.google.gson.annotations.SerializedName
import com.samsung.android.sdk.samsungpay.v2.payment.sheet.SheetItemType

data class SheetItemPojo(

	@field:SerializedName("id")
	val id: String? = null,

	@field:SerializedName("title")
	val title: String? = null,

	@field:SerializedName("sValue")
	val sValue: String? = null,

	@field:SerializedName("dValue")
	val dValue: Double? = null,

	@field:SerializedName("sheetItemType")
	val sheetItemType: String? = null,

	@field:SerializedName("extraValue")
	val extraValue:  JsonObject? = null
){
	fun getSheetItemType(): SheetItemType{
		if(sheetItemType == SheetItemType.BILLING_ADDRESS.name) {
			return SheetItemType.BILLING_ADDRESS
		}
		else if(sheetItemType == SheetItemType.SHIPPING_ADDRESS.name) {
			return SheetItemType.SHIPPING_ADDRESS
		}
		else if (sheetItemType == SheetItemType.ZIP_ONLY_ADDRESS.name){
			return SheetItemType.ZIP_ONLY_ADDRESS
		}
		else if(sheetItemType == SheetItemType.AMOUNT_ITEM.name)
			return SheetItemType.AMOUNT_ITEM
		else if(sheetItemType == SheetItemType.AMOUNT_TOTAL.name)
			return SheetItemType.AMOUNT_TOTAL
		else if(sheetItemType == SheetItemType.SHIPPING_METHOD_SPINNER.name)
			return  SheetItemType.SHIPPING_METHOD_SPINNER
		else
			return SheetItemType.INSTALLMENT_SPINNER
	}

	fun getBundle(): Bundle {
		val bundleData = Bundle()
		return if (extraValue==null)
			bundleData
		else{
			extraValue.keySet()?.forEach {
				bundleData.putString(it, extraValue.get(it).asString)
			}
			bundleData
		}
	}
}
