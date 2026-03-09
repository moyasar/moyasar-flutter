package com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo

import com.google.gson.JsonArray
import com.google.gson.JsonObject
import com.google.gson.annotations.SerializedName
import com.samsung.android.sdk.samsungpay.v2.payment.sheet.*
import com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.utils.*

data class CustomSheetPojo(
	@field:SerializedName("sheetControls")
	val sheetControls: JsonArray?=null
) {
	fun getCustomSheet(sheetUpdatedListener: SheetUpdatedListener?): CustomSheet{
		val customSheet:CustomSheet= CustomSheet()
		for(i in 0 until sheetControls!!.size()){
			val sheetObject =sheetControls.get(i) as JsonObject
			if(sheetObject.get("controltype").asString == SheetControl.Controltype.ADDRESS.name){
				customSheet.addControl(AddressControlConverter().getAddressControl(sheetObject.toString(), sheetUpdatedListener))
			}else if(sheetObject.get("controltype").asString == SheetControl.Controltype.AMOUNTBOX.name){
				customSheet.addControl(AmountBoxControlConverter.getAmountBoxControl(sheetObject.toString()))
			}else if(sheetObject.get("controltype").asString == SheetControl.Controltype.PLAINTEXT.name){
				customSheet.addControl(PlainTextControlConverter.getPlainTextControl(sheetObject.toString()))
			}else if(sheetObject.get("controltype").asString == SheetControl.Controltype.SPINNER.name){
				customSheet.addControl(SpinnerControlConverter.getSpinnerControl(sheetObject.toString(), sheetUpdatedListener))
			}
		}
		return customSheet
	}
}
