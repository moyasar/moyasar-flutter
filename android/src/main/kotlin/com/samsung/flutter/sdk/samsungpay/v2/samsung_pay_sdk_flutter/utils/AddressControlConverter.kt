package com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.utils

import com.google.gson.FieldNamingPolicy
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.JsonObject
import com.samsung.android.sdk.samsungpay.v2.payment.sheet.AddressControl
import com.samsung.android.sdk.samsungpay.v2.payment.sheet.SheetUpdatedListener
import com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo.AddressControlPojo
import com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo.SheetItemPojo

class AddressControlConverter {
    fun getAddressControl(
        addressControlJsonString: String,
        sheetUpdatedListener: SheetUpdatedListener?
    ): AddressControl {
        val addressControlPojo = Gson().fromJson(addressControlJsonString, AddressControlPojo::class.java)
        val addressControl = AddressControl(
            addressControlPojo.controlId ?: "",
            addressControlPojo.getSheetItem().getSheetItemType()
        )
        if(addressControlPojo.address != null)
            addressControl.address = AddressConverter.getAddressConverter(addressControlPojo.address.toString())
        if(addressControlPojo.sheetItem != null)
            addressControl.addressTitle=addressControlPojo.getSheetItem().title
        if(addressControlPojo.displayOption != null)
            addressControl.displayOption= addressControlPojo.displayOption
        if (addressControlPojo.errorCode != null)
            addressControl.errorCode = addressControlPojo.errorCode
        if(addressControlPojo.sheetUpdatedListener)
            addressControl.sheetUpdatedListener = sheetUpdatedListener
        return addressControl
    }

    fun getAddressControlJsonObject(addressControl: AddressControl?): JsonObject {
        val isSheetUpdatedListener = addressControl?.sheetUpdatedListener != null

        val gson: Gson = GsonBuilder()
            .serializeNulls()
            .setFieldNamingPolicy(FieldNamingPolicy.IDENTITY)
            .create()

        val extraValueJson = JsonObject()
        addressControl?.sheetItem?.extraValue?.keySet()?.forEach {
            extraValueJson.addProperty(it, addressControl.sheetItem.extraValue.get(it).toString())
        }
        val sheetItemPojo =
            SheetItemPojo(
                addressControl?.sheetItem?.id,
                addressControl?.sheetItem?.title,
                addressControl?.sheetItem?.sValue,
                addressControl?.sheetItem?.dValue,
                addressControl?.sheetItem?.sheetItemType?.name,
                extraValueJson)

        val sheetItemJsonElement = gson.toJsonTree(sheetItemPojo, SheetItemPojo::class.java) as JsonObject
        val addressControlPojo = AddressControlPojo(addressControl?.controltype?.name,
            addressControl?.controlId,sheetItemJsonElement,
            AddressConverter.getAddressJsonObject(addressControl?.address),
            addressControl?.displayOption,
            addressControl?.errorCode, isSheetUpdatedListener)

        return gson.toJsonTree(addressControlPojo, AddressControlPojo::class.java).asJsonObject
    }
}