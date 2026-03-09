package com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.utils

import android.src.main.kotlin.com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo.AmountBoxControlPojo
import com.google.gson.*
import com.samsung.android.sdk.samsungpay.v2.payment.sheet.AmountBoxControl
import com.samsung.android.sdk.samsungpay.v2.payment.sheet.AmountConstants.FORMAT_TOTAL_PRICE_ONLY
import com.samsung.android.sdk.samsungpay.v2.payment.sheet.SheetItem
import com.samsung.android.sdk.samsungpay.v2.payment.sheet.SheetItemType
import com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo.SheetItemPojo

object AmountBoxControlConverter {
    fun getAmountBoxControl(amountBoxControlJsonString: String): AmountBoxControl {
        val amountBoxControlPojo = Gson().fromJson(amountBoxControlJsonString, AmountBoxControlPojo::class.java)
        val itemList = amountBoxControlPojo.getSheetItem()
        val amountBoxControl = AmountBoxControl(
            amountBoxControlPojo.controlId ?: "",
            amountBoxControlPojo.currencyCode ?: ""
        )

        for (sheetItem in itemList) {
            if (sheetItem.sheetItemType == SheetItemType.AMOUNT_TOTAL) {
                amountBoxControl.setAmountTotal(sheetItem.dValue, FORMAT_TOTAL_PRICE_ONLY)
            } else {
                amountBoxControl.addItem(sheetItem.id, sheetItem.title, sheetItem.dValue, sheetItem.sValue)
            }
        }
        return amountBoxControl
    }

    fun getAmountBoxControlJsonObject(amountBoxControl: AmountBoxControl): JsonObject {
        val gson: Gson = GsonBuilder()
            .serializeNulls()
            .setFieldNamingPolicy(FieldNamingPolicy.IDENTITY)
            .create()

        val sheetItemJsonArray = JsonArray()

         for(item in amountBoxControl.items){
             if (item.sheetItemType != null){
                 val extraValueJson = JsonObject()
                 item.extraValue?.keySet()?.forEach{
                     extraValueJson.addProperty(it, item.extraValue.get(it).toString())
                 }
                 val sheetItemPojo = SheetItemPojo(item.id, item.title, item.sValue, item.dValue, item.sheetItemType.name, extraValueJson)
                 val sheetItemPojoJson = gson.toJsonTree(sheetItemPojo, SheetItemPojo::class.java)
                 sheetItemJsonArray.add(sheetItemPojoJson)
             }
         }
        val amountBoxControlPojo = AmountBoxControlPojo(amountBoxControl.controltype.name,amountBoxControl.controlId,sheetItemJsonArray,amountBoxControl.currencyCode)
        val amountBoxControlJsonObject = gson.toJsonTree(amountBoxControlPojo, AmountBoxControlPojo::class.java) as JsonObject
        return amountBoxControlJsonObject
    }
}
