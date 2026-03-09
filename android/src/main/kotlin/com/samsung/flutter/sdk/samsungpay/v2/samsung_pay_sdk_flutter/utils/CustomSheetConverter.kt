package com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.utils

import com.google.gson.*
import com.samsung.android.sdk.samsungpay.v2.payment.sheet.*
import com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo.CustomSheetPojo

object CustomSheetConverter {
    fun getCustomSheetConverter(
        customSheetJsonString: String,
        sheetUpdatedListener: SheetUpdatedListener?
    ): CustomSheet{
        val customSheetPojo = Gson().fromJson(customSheetJsonString, CustomSheetPojo::class.java)
        return customSheetPojo.getCustomSheet(sheetUpdatedListener)
    }

    fun getCustomSheetJsonObject(customSheet: CustomSheet?): JsonObject{
        val sheetControlsJsonArray = JsonArray()

        for(sheetcontrol in customSheet?.sheetControls!!){
            if(sheetcontrol.controltype == SheetControl.Controltype.ADDRESS){
                val addressControl = customSheet.getSheetControl(sheetcontrol.controlId) as AddressControl
                sheetControlsJsonArray.add(AddressControlConverter().getAddressControlJsonObject(addressControl))
            }
            else if(sheetcontrol.controltype == SheetControl.Controltype.AMOUNTBOX){
                val amountBoxControl = customSheet.getSheetControl(sheetcontrol.controlId) as AmountBoxControl
                sheetControlsJsonArray.add(AmountBoxControlConverter.getAmountBoxControlJsonObject(amountBoxControl))
            }
            else if(sheetcontrol.controltype == SheetControl.Controltype.SPINNER){
                val spinnerControl = customSheet.getSheetControl(sheetcontrol.controlId) as SpinnerControl
                sheetControlsJsonArray.add(SpinnerControlConverter.makeSpinnerControlJson(spinnerControl))
            }
            else if(sheetcontrol.controltype == SheetControl.Controltype.PLAINTEXT){
                val plainTextControl = customSheet.getSheetControl(sheetcontrol.controlId) as PlainTextControl
                sheetControlsJsonArray.add(PlainTextControlConverter.makePlainTextControlJson(plainTextControl))
            }
        }
        val customSheetJsonObject = JsonObject()
        customSheetJsonObject.add("sheetControls",sheetControlsJsonArray)
        return  customSheetJsonObject
    }
}