package com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo

import android.os.Bundle
import com.google.gson.JsonArray
import com.google.gson.JsonObject
import com.google.gson.annotations.SerializedName
import com.samsung.android.sdk.samsungpay.v2.SpaySdk
import com.samsung.android.sdk.samsungpay.v2.SpaySdk.Brand
import com.samsung.android.sdk.samsungpay.v2.payment.CustomSheetPaymentInfo
import com.samsung.android.sdk.samsungpay.v2.payment.CustomSheetPaymentInfo.AddressInPaymentSheet
import com.samsung.android.sdk.samsungpay.v2.payment.sheet.CustomSheet
import com.samsung.android.sdk.samsungpay.v2.payment.sheet.SheetUpdatedListener
import com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.utils.CustomSheetConverter

data class CustomSheetPaymentInfoPojo(
	@field:SerializedName("merchantId")
	val merchantId: String? = null,

	@field:SerializedName("merchantName")
	val merchantName: String? = null,

	@field:SerializedName("orderNumber")
	val orderNumber: String? = null,

	@field:SerializedName("addressInPaymentSheet")
	val addressInPaymentSheet: String?,

	@field:SerializedName("allowedCardBrand")
	val allowedCardBrand: JsonArray?,

	@field:SerializedName("isCardHolderNameRequired")
	val isCardHolderNameRequired: Boolean,

	@field:SerializedName("isRecurring")
	val isRecurring: Boolean,

	@field:SerializedName("merchantCountryCode")
	val merchantCountryCode: String? = null,

	@field:SerializedName("customSheet")
	val customSheet: JsonObject? = null,

	@field:SerializedName("extraPaymentInfo")
	val extraPaymentInfo: JsonObject? = null,

	@field:SerializedName("cardInfo")
	val cardInfo: JsonObject? = null,
)
{
	fun getCustomSheet(sheetUpdatedListener: SheetUpdatedListener?): CustomSheet {
		return CustomSheetConverter.getCustomSheetConverter(customSheet.toString(), sheetUpdatedListener)
	}

	fun getAddressInPaymentSheet() : AddressInPaymentSheet{
		return when(addressInPaymentSheet){
			AddressInPaymentSheet.DO_NOT_SHOW.name -> AddressInPaymentSheet.DO_NOT_SHOW
			AddressInPaymentSheet.NEED_BILLING_SPAY.name -> AddressInPaymentSheet.NEED_BILLING_SPAY
			AddressInPaymentSheet.NEED_SHIPPING_SPAY.name -> AddressInPaymentSheet.NEED_SHIPPING_SPAY
			AddressInPaymentSheet.SEND_SHIPPING.name -> AddressInPaymentSheet.SEND_SHIPPING
			AddressInPaymentSheet.NEED_BILLING_SEND_SHIPPING.name -> AddressInPaymentSheet.NEED_BILLING_SEND_SHIPPING
			AddressInPaymentSheet.NEED_BILLING_AND_SHIPPING.name -> AddressInPaymentSheet.NEED_BILLING_AND_SHIPPING
			else -> AddressInPaymentSheet.DO_NOT_SHOW
		}
	}

	fun getAllowedCardBrand() : List<Brand>{
		val brandList = mutableListOf<Brand>()
		allowedCardBrand?.forEach { it ->
			brandList.add(getCardBrandAgainstName(it.asString))
		}
		return brandList
	}

    fun getBundle(): Bundle {
        val bundleData = Bundle()
        extraPaymentInfo?.keySet()?.forEach {
            bundleData.putString(it, extraPaymentInfo.get(it)?.asString)
        }
        return bundleData
    }
    private fun getCardBrandAgainstName(brandName: String): Brand {
        return when (brandName) {
            Brand.AMERICANEXPRESS.name -> Brand.AMERICANEXPRESS
            Brand.MASTERCARD.name -> Brand.MASTERCARD
            Brand.VISA.name -> Brand.VISA
            Brand.DISCOVER.name -> Brand.DISCOVER
            Brand.CHINAUNIONPAY.name -> Brand.CHINAUNIONPAY
            Brand.UNKNOWN_CARD.name -> Brand.UNKNOWN_CARD
            Brand.OCTOPUS.name -> Brand.OCTOPUS
            Brand.ECI.name -> Brand.ECI
            Brand.PAGOBANCOMAT.name -> Brand.PAGOBANCOMAT
            Brand.MADA.name -> Brand.MADA
            else -> Brand.UNKNOWN_CARD
        }
    }
}