package com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.utils

import com.google.gson.FieldNamingPolicy
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.JsonObject
import com.google.gson.reflect.TypeToken
import com.samsung.android.sdk.samsungpay.v2.payment.sheet.PlainTextControl
import com.samsung.android.sdk.samsungpay.v2.payment.sheet.SheetControl
import com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo.AddressControlPojo
import com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo.PlainTextControlPojo
import com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo.SheetItemPojo

object PlainTextControlConverter {
    fun getPlainTextControl(plainTextControlJsonString: String): PlainTextControl {
        val plainTextControlPojo = Gson().fromJson(plainTextControlJsonString, PlainTextControlPojo::class.java)
        val plainTextControl = PlainTextControl(plainTextControlPojo.controlId.toString())
        plainTextControl.setText(plainTextControlPojo.getSheetItem().title,plainTextControlPojo.getSheetItem().sValue)
        return plainTextControl
    }

    fun makePlainTextControlJson(plainTextControl: PlainTextControl): JsonObject
    {
        val sheetItem = Gson().fromJson(Gson().toJson(SheetItemPojo(null, plainTextControl.title,plainTextControl.text, null, null)), JsonObject::class.java)

        return Gson().fromJson(Gson().toJson(PlainTextControlPojo(SheetControl.Controltype.PLAINTEXT.name, plainTextControl.controlId, sheetItem)), JsonObject::class.java)
    }
}