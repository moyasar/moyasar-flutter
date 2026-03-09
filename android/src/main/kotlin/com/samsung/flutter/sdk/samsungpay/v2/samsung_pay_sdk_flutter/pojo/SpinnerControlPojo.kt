package com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo

import com.google.gson.Gson
import com.google.gson.JsonArray
import com.google.gson.annotations.SerializedName
import com.samsung.android.sdk.samsungpay.v2.payment.sheet.SheetItem

data class SpinnerControlPojo(

	@field:SerializedName("controltype")
	val controltype: String? = null,

	@field:SerializedName("controlId")
	val controlId: String? = null,

	@field:SerializedName("items")
	val items: JsonArray? = null,

	@field:SerializedName("selectedItemId")
	val selectedItemId: String? = null,
){
	fun getSheetItem(): ArrayList<SheetItem> {
		val sheetItemList = ArrayList<SheetItem>()

		for (i in 0 until items?.size()!!) {
			val sheetitem = items[i]
			val sheetItemPojo = Gson().fromJson(sheetitem.toString(), SheetItemPojo::class.java)

			val sheetItem: SheetItem = SheetItem.Builder()
				.setId(sheetItemPojo.id)
				.setTitle(sheetItemPojo.title)
				.setSValue(sheetItemPojo.sValue)
				.setSheetItemType(sheetItemPojo.getSheetItemType())
				.setExtraValue(sheetItemPojo.getBundle())
				.build()

			sheetItemList.add(sheetItem)
		}
		return sheetItemList
	}
}