package com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.utils

import com.google.gson.FieldNamingPolicy
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.JsonObject
import com.samsung.android.sdk.samsungpay.v2.card.AddCardInfo
import com.samsung.android.sdk.samsungpay.v2.payment.CustomSheetPaymentInfo
import com.samsung.android.sdk.samsungpay.v2.service.Address
import com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo.AddCardInfoPojo
import com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo.AddressPojo

object AddressConverter {
    fun getAddressConverter(addressJsonString: String): CustomSheetPaymentInfo.Address {
        val addressPojo = Gson().fromJson(addressJsonString, AddressPojo::class.java)

        val address = CustomSheetPaymentInfo.Address.Builder()
        if (addressPojo.countryCode != null){
            address.setCountryCode(addressPojo.countryCode)
        }

        return address.setAddressee(addressPojo.addressee)
            .setAddressLine1(addressPojo.addressLine1)
            .setAddressLine2(addressPojo.addressLine2)
            .setCity(addressPojo.city)
            .setState(addressPojo.state)
            .setPostalCode(addressPojo.postalCode)
            .setPhoneNumber(addressPojo.phoneNumber)
            .setExtraAddressInfo(addressPojo.getBundle())
            .setEmail(addressPojo.email)
            .build()
    }

    fun getAddressJsonObject(address: CustomSheetPaymentInfo.Address?): JsonObject{

        val extraAddressInfoJson = JsonObject()
        address?.extraAddressInfo?.keySet()?.forEach {
            extraAddressInfoJson.addProperty(it, address.extraAddressInfo.get(it).toString())
        }
        val addressPojo=
            AddressPojo(address?.addressee,
                address?.addressLine1,
                address?.addressLine2,
                address?.city,
                address?.state,
                address?.countryCode,
                address?.postalCode,
                address?.phoneNumber,
                extraAddressInfoJson,
                address?.email
        )
        val addressJsonObject = Gson().toJsonTree(addressPojo, AddressPojo::class.java) as JsonObject
        return  addressJsonObject
    }
}