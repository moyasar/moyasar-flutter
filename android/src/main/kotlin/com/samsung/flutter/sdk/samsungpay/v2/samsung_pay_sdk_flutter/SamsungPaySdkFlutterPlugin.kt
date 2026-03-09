package com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter

import android.content.Context
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import com.google.gson.*
import com.samsung.android.sdk.samsungpay.v2.SamsungPay
import com.samsung.android.sdk.samsungpay.v2.SpaySdk
import com.samsung.android.sdk.samsungpay.v2.StatusListener
import com.samsung.android.sdk.samsungpay.v2.card.AddCardListener
import com.samsung.android.sdk.samsungpay.v2.card.Card
import com.samsung.android.sdk.samsungpay.v2.card.CardManager
import com.samsung.android.sdk.samsungpay.v2.card.GetCardListener
import com.samsung.android.sdk.samsungpay.v2.payment.CardInfo
import com.samsung.android.sdk.samsungpay.v2.payment.CustomSheetPaymentInfo
import com.samsung.android.sdk.samsungpay.v2.payment.PaymentManager
import com.samsung.android.sdk.samsungpay.v2.payment.sheet.*
import com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo.CustomSheetPaymentInfoPojo
import com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo.CustomSheetPojo
import com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo.PartnerInfoPojo
import com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo.PaymentCardInfoPojo
import com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.utils.AddCardInfoConverter
import com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.utils.CustomSheetConverter
import com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.utils.CustomSheetPaymentInfoConverter
import com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.utils.PartnerInfoConverter
import com.samsung.flutter.sdk.samsungpay.v2.samsung_pay_sdk_flutter.pojo.RequestCardInfoPojo
import io.flutter.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.ArrayList

/** SamsungPaySdkFlutterPlugin */
class SamsungPaySdkFlutterPlugin: FlutterPlugin, MethodCallHandler {

  private val TAG = "SPAYSDKFLUTTERPLUGIN:"
  private lateinit var channel : MethodChannel
  private lateinit var samsungPay: SamsungPay
  private lateinit var cardManager: CardManager
  private lateinit var paymentManager: PaymentManager
  private lateinit var context: Context
  private lateinit var gson: Gson
  private var sheetUpdatedListener: SheetUpdatedListener? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "samsung_pay_sdk_flutter")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
    gson = Gson()
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    loggingCall(call)
    when (call.method) {
        "initSamsungPay" -> {
          init(call.arguments as String)
        }
        "getSamsungPayStatus" -> {
          getSamsungPayStatus()
        }
         "getWalletInfo" -> {
           getWalletInfo()
         }
        "goToUpdatePage" -> {
          goToUpdatePage(result)
        }
        "activateSamsungPay" -> {
          activateSamsungPay(result)
        }
        "addCard" -> {
          addCard(call.arguments as String)
        }
        "getAllCards"->{
          getAllCards()
        }
      "requestCardInfo"->{
        requestCardInfo(call.arguments as String)
      }
      "startInAppPayWithCustomSheet"->{
        startInAppPayWithCustomSheet(call.arguments as String)
      }
      "updateSheet"->{
        updateSheet(call.arguments as String)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  private fun init(partnerInfoJsonString: String) {
    val partnerInfo = PartnerInfoConverter.getPartnerInfo(partnerInfoJsonString)
    samsungPay=SamsungPay(context,partnerInfo)
    cardManager = CardManager(context,partnerInfo)
    paymentManager = PaymentManager(context,partnerInfo)
  }


  private fun getSamsungPayStatus() {
    Log.d(TAG, "getSamsungPayStatus()")
    val statusListener: StatusListener = object : StatusListener {
      override fun onSuccess(status: Int, bundle: Bundle) {
        Log.d(TAG, "onSuccess: status=$status,bundle:$bundle")
        val spayStatusResult= JsonObject()
        val bundleDataJson= JsonObject()
        spayStatusResult.addProperty("event","onSuccess")
        spayStatusResult.addProperty("status",status.toString())
        bundle.keySet().forEach {
          bundleDataJson.addProperty(it,bundle.get(it).toString())
        }
        spayStatusResult.add("bundle",bundleDataJson)
        channel.invokeMethod(/* method = */ "samsungPayStatusFlutter",
          /* arguments = */ spayStatusResult.toString())
      }
      override fun onFail(errorCode: Int, bundle: Bundle) {
        Log.d(TAG, "onFail: errorCode=$errorCode,bundle:$bundle")
        val spayStatusResult= JsonObject()
        val bundleDataJson= JsonObject()
        spayStatusResult.addProperty("event","onFail")
        spayStatusResult.addProperty("status",errorCode.toString())
        bundle.keySet().forEach {
          bundleDataJson.addProperty(it,bundle.get(it).toString())
        }
        spayStatusResult.add("bundle",bundleDataJson)
        channel.invokeMethod(/* method = */ "samsungPayStatusFlutter",
          /* arguments = */spayStatusResult.toString())
      }
    }
    samsungPay.getSamsungPayStatus(statusListener)
  }

  private fun getWalletInfo() {
    Log.d(TAG, "getWalletInfo()")
    val keys = ArrayList<String>()
    keys.add(SamsungPay.WALLET_DM_ID)
    keys.add(SamsungPay.DEVICE_ID)
    keys.add(SamsungPay.WALLET_USER_ID)

    val statusListener: StatusListener = object : StatusListener {
      override fun onSuccess(status: Int, walletData: Bundle) {
        Log.d(TAG, "onSuccess: status=$status,bundle:$walletData")

        // VISA requires DEVICE_ID for deviceID, WALLET_USER_ID for walletAccountId. Please refer VISA spec document.
        val clientDeviceId: String = walletData.get(SamsungPay.DEVICE_ID).toString()
        val clientWalletAccountId: String = walletData.get(SamsungPay.WALLET_USER_ID).toString()

        val spayStatusResult = JsonObject()
        val bundleDataJson = JsonObject()

        spayStatusResult.addProperty("event","onSuccess")
        spayStatusResult.addProperty("status",status.toString())

        walletData.keySet().forEach {
          bundleDataJson.addProperty(it,walletData.get(it).toString())
        }

        spayStatusResult.add("bundle",bundleDataJson)

        channel.invokeMethod(/* method = */ "samsungPayStatusFlutter",
          /* arguments = */ spayStatusResult.toString())
      }
      override fun onFail(errorCode: Int, bundle: Bundle) {
        Log.d(TAG, "onFail: errorCode=$errorCode,bundle:$bundle")
        val spayStatusResult = JsonObject()
        val bundleDataJson = JsonObject()
        spayStatusResult.addProperty("event","onFail")
        spayStatusResult.addProperty("status",errorCode.toString())
        bundle.keySet().forEach {
          bundleDataJson.addProperty(it,bundle.get(it).toString())
        }
        spayStatusResult.add("bundle",bundleDataJson)
        channel.invokeMethod(/* method = */ "samsungPayStatusFlutter",
          /* arguments = */spayStatusResult.toString())
      }
    }
    samsungPay.getWalletInfo(keys,statusListener)
  }
  private fun activateSamsungPay(result: Result) {
    Log.d(TAG, "activateSamsungPay()")
    samsungPay.activateSamsungPay()
  }

  private fun goToUpdatePage(result: Result) {
    Log.d(TAG, "goToUpdatePage()")
    samsungPay.goToUpdatePage()
  }

  private fun addCard(addCardInfoJsonString : String){
    Log.d(TAG, "addCard()")
    val addCardInfo = AddCardInfoConverter.getAddCardInfo(addCardInfoJsonString)
    cardManager.addCard(addCardInfo, object : AddCardListener {
      override fun onSuccess(status: Int, card: Card?) {
        Log.d(TAG, "onSuccess: currentCount=$status,card:$card")
        val spayOnSuccessResult= JsonObject()
        val cardDataJson= JsonObject()
        val cardInfo= JsonObject()
        card?.cardInfo?.keySet()?.forEach {
          cardInfo.addProperty(it, card.cardInfo?.get(it).toString())
        }
        spayOnSuccessResult.addProperty("event","onSuccess")
        spayOnSuccessResult.addProperty("status",status.toString())
        cardDataJson.addProperty("cardId",card?.cardId)
        cardDataJson.addProperty("cardStatus",card?.cardStatus)
        cardDataJson.addProperty("cardBrand", card?.cardBrand?.name)
        cardDataJson.add("cardInfo",cardInfo)
        spayOnSuccessResult.add("card",cardDataJson)
        channel.invokeMethod(/* method = */ "addCardFlutter",
          /* arguments = */ spayOnSuccessResult.toString())
      }
      override fun onFail(status: Int, bundle: Bundle?) {
        Log.d(TAG, "onFail: status=$status,bundle:$bundle")
        val spayOnFailedResult= JsonObject()
        val bundleDataJson = JsonObject()
        bundle?.keySet()?.forEach {
          bundleDataJson.addProperty(it, bundle.get(it).toString())
        }
        spayOnFailedResult.addProperty("event","onFail")
        spayOnFailedResult.addProperty("status",status.toString())
        spayOnFailedResult.add("bundle",bundleDataJson)
        channel.invokeMethod(/* method = */ "addCardFlutter",
          /* arguments = */ spayOnFailedResult.toString())
      }
      override fun onProgress(currentCount: Int, totalCount: Int, bundle: Bundle?) {
        Log.d(TAG, "onProgress: currentCount=$currentCount,bundle:$bundle")
        val spayOnProgressResult= JsonObject()
        val bundleDataJson = JsonObject()
        bundle?.keySet()?.forEach {
          bundleDataJson.addProperty(it, bundle.get(it).toString())
        }
        spayOnProgressResult.addProperty("event","onProgress")
        spayOnProgressResult.addProperty("currentCount",currentCount.toString())
        spayOnProgressResult.addProperty("totalCount",totalCount.toString())
        spayOnProgressResult.add("bundle",bundleDataJson)
        channel.invokeMethod(/* method = */ "addCardFlutter",
          /* arguments = */ spayOnProgressResult.toString())
      }

    })
  }

  private fun getAllCards(){
    Log.d(TAG, "getAllCards()")
    val getCardListener: GetCardListener = object : GetCardListener {
      override fun onSuccess(cardList: List<Card?>) {
        Log.d(TAG, "onSuccess: ")
        val spayOnSuccessResult= JsonObject()
        spayOnSuccessResult.addProperty("event","onSuccess")
        val cardListJson = JsonArray()
        for(card in cardList){
          val cardJson = JsonObject()
          val bundleCardInfoJson = JsonObject()
          cardJson.addProperty("cardBrand", card?.cardBrand.toString())
          cardJson.addProperty("cardId", card?.cardId)
          card?.cardInfo?.keySet()?.forEach {
            bundleCardInfoJson.addProperty(it, card.cardInfo.get(it).toString())
          }
          cardJson.add("cardInfo",bundleCardInfoJson)
          cardJson.addProperty("cardStatus", card?.cardStatus)
          cardListJson.add(cardJson)
        }
        spayOnSuccessResult.add("cardList",cardListJson)
        channel.invokeMethod(/* method = */ "getAllCardsFlutter",
          /* arguments = */ spayOnSuccessResult.toString())
      }
      override fun onFail(status: Int, bundle: Bundle?) {
        Log.d(TAG, "onFail: status=$status,bundle:$bundle")
        val spayOnFailedResult= JsonObject()
        val bundleDataJson = JsonObject()
        bundle?.keySet()?.forEach {
          bundleDataJson.addProperty(it, bundle.get(it).toString())
        }
        spayOnFailedResult.addProperty("event","onFail")
        spayOnFailedResult.addProperty("status",status.toString())
        spayOnFailedResult.add("bundle",bundleDataJson)
        channel.invokeMethod(/* method = */ "getAllCardsFlutter",
          /* arguments = */ spayOnFailedResult.toString())
      }
    }
    cardManager.getAllCards(null,getCardListener)
  }

  private fun requestCardInfo(requestedCardtInfoJsonString: String){
    Log.d(TAG, "requestCardInfo()")
    val cardInfoListener: PaymentManager.CardInfoListener= object :PaymentManager.CardInfoListener{
      override fun onResult(cardList: List<CardInfo>?) {
        Log.d(TAG, "onSuccess: ")
        val spayResult= JsonObject()
        spayResult.addProperty("event","onResult")
        val cardListJson = JsonArray()
        val cardJson = JsonObject()
        val bundleCardInfoJson = JsonObject()
        for(card in cardList!!){
          cardJson.addProperty("brand",card.brand.toString())
          cardJson.addProperty("cardId", card.cardId)
          card.cardMetaData?.keySet()?.forEach {
            bundleCardInfoJson.addProperty(it, card.cardMetaData.get(it).toString())
          }
          cardJson.add("cardMetaData",bundleCardInfoJson)
          cardListJson.add(cardJson)
        }
        spayResult.add("cardList",cardListJson)
        channel.invokeMethod(/* method = */ "requestCardInfoFlutter",
          /* arguments = */ spayResult.toString())
      }

      override fun onFailure(status: Int, bundle: Bundle?) {
        Log.d(TAG, "onFail: status=$status,bundle:$bundle")
        val spayOnFailedResult= JsonObject()
        val bundleDataJson = JsonObject()
        bundle?.keySet()?.forEach {
          bundleDataJson.addProperty(it, bundle.get(it).toString())
        }
        spayOnFailedResult.addProperty("event","onFailure")
        spayOnFailedResult.addProperty("errorCode",status.toString())
        spayOnFailedResult.add("bundle",bundleDataJson)
        channel.invokeMethod(/* method = */ "requestCardInfoFlutter",
          /* arguments = */ spayOnFailedResult.toString())
      }
    }

    paymentManager.requestCardInfo(makeBundleWithRequestFilter(requestedCardtInfoJsonString),cardInfoListener)
  }

  private fun startInAppPayWithCustomSheet(customSheetPaymentInfoJsonString: String){
    Log.d(TAG, "startInAppPayWithCustomSheet()")
    sheetUpdatedListener = SheetUpdatedListener { controlId, customSheet ->
      Log.d(TAG, "onSuccess: updatedControlId=$controlId")

      val customSheetJson = CustomSheetConverter.getCustomSheetJsonObject(customSheet)
      val spayOnResult =JsonObject()
      spayOnResult.addProperty("event","onResult")
      spayOnResult.addProperty("updatedControlId",controlId)
      spayOnResult.add("customSheet",customSheetJson)
      channel.invokeMethod(/* method = */ "setSheetUpdatedListenerFlutter",
        /* arguments = */ spayOnResult.toString())
    }
    val transactionListener: PaymentManager.CustomSheetTransactionInfoListener =
      object : PaymentManager.CustomSheetTransactionInfoListener {

        override fun onCardInfoUpdated(selectedCardInfo: CardInfo, customSheet: CustomSheet) {
          Log.d(TAG, "onCardInfoUpdated: selectedCardInfo=$selectedCardInfo")

          val cardMetaDataJson = JsonObject()
          selectedCardInfo.cardMetaData?.keySet()?.forEach{
            cardMetaDataJson.addProperty(it, selectedCardInfo.cardMetaData.get(it).toString())
          }
          val cardInfoPojo = PaymentCardInfoPojo(selectedCardInfo.brand,selectedCardInfo.cardId,cardMetaDataJson)

          val cardInfoJson = gson.toJsonTree(cardInfoPojo, PaymentCardInfoPojo::class.java).asJsonObject
          val customSheetJson = CustomSheetConverter.getCustomSheetJsonObject(customSheet)
          val spayOnCardInfoUpdatedResult= JsonObject()
          spayOnCardInfoUpdatedResult.addProperty("event", "onCardInfoUpdated")
          spayOnCardInfoUpdatedResult.add("selectedCardInfo", cardInfoJson)
          spayOnCardInfoUpdatedResult.add("customSheet", customSheetJson)
          channel.invokeMethod(/* method = */ "startInAppPayWithCustomSheetFlutter",
            /* arguments = */ spayOnCardInfoUpdatedResult.toString())
        }
        override fun onSuccess(response: CustomSheetPaymentInfo, paymentCredential: String, extraPaymentData: Bundle) {
          Log.d(TAG, "onSuccess: paymentCredential=$paymentCredential")

          val extraPaymentInfoJson = JsonObject()
          response.extraPaymentInfo?.keySet()?.forEach {
            extraPaymentInfoJson.addProperty(it, response.extraPaymentInfo.get(it).toString())
          }

          val paymentCardInfoMetaData= JsonObject()
          response.cardInfo.cardMetaData.keySet()?.forEach {
            paymentCardInfoMetaData.addProperty(it, response.cardInfo.cardMetaData.get(it).toString())
          }
          val paymentCardInfoPojo = gson.toJsonTree(PaymentCardInfoPojo(response.cardInfo.brand, response.cardInfo.cardId, paymentCardInfoMetaData), PaymentCardInfoPojo::class.java)

          val customSheetPaymentInfoPojo = CustomSheetPaymentInfoPojo(response.merchantId,response.merchantName,
            response.orderNumber,response.addressInPaymentSheet.name, Gson().toJsonTree(response.allowedCardBrands).asJsonArray,
            response.isCardHolderNameRequired,response.isRecurring,response.merchantCountryCode,
            CustomSheetConverter.getCustomSheetJsonObject(response.customSheet),extraPaymentInfoJson, paymentCardInfoPojo.asJsonObject)
          val customSheetPaymentInfoJson = gson.toJsonTree(customSheetPaymentInfoPojo, CustomSheetPaymentInfoPojo::class.java)
          val extraPaymentDataJson = JsonObject()
          extraPaymentData.keySet()?.forEach {
            extraPaymentInfoJson.addProperty(it, extraPaymentData.get(it).toString())
          }

          val spayOnSuccessResult= JsonObject()
          spayOnSuccessResult.addProperty("event", "onSuccess")
          spayOnSuccessResult.add("response", customSheetPaymentInfoJson)
          spayOnSuccessResult.addProperty("paymentCredential", paymentCredential)
          spayOnSuccessResult.add("extraPaymentData",extraPaymentDataJson)
          channel.invokeMethod(/* method = */ "startInAppPayWithCustomSheetFlutter",
            /* arguments = */ spayOnSuccessResult.toString())
        }
        override fun onFailure(errorCode: Int, errorData: Bundle?) {
          Log.d(TAG, "onFail: errorCode=$errorCode,bundle:$errorData")
          val spayOnFailedResult= JsonObject()
          val errorDataJson = JsonObject()
          errorData?.keySet()?.forEach {
            errorDataJson.addProperty(it, errorData.get(it).toString())
          }
          spayOnFailedResult.addProperty("event","onFailure")
          spayOnFailedResult.addProperty("errorCode",errorCode.toString())
          spayOnFailedResult.add("errorData",errorDataJson)
          channel.invokeMethod(/* method = */ "startInAppPayWithCustomSheetFlutter",
            /* arguments = */ spayOnFailedResult.toString())
        }
      }
    val customSheetPaymentInfo= CustomSheetPaymentInfoConverter.getCustomSheetPaymentInfo(customSheetPaymentInfoJsonString, sheetUpdatedListener)
    paymentManager.startInAppPayWithCustomSheet(customSheetPaymentInfo,transactionListener)
  }

  private fun updateSheet(customSheetJsonString: String){
    Log.d(TAG, "updateSheet()")
    val customSheetJsonObject = gson.fromJson(customSheetJsonString, JsonObject::class.java)
    val customSheetPojo = gson.fromJson(customSheetJsonObject["customSheet"].asJsonObject, CustomSheetPojo::class.java)
    val customSheet = customSheetPojo.getCustomSheet(sheetUpdatedListener)
    if(!customSheetJsonObject["customErrorCode"].isJsonNull && !customSheetJsonObject["customErrorMessage"].isJsonNull) {
      val errorCode = customSheetJsonObject["customErrorCode"].asInt
      val errorMessage = customSheetJsonObject["customErrorMessage"].asString
      Handler(Looper.getMainLooper()).postDelayed({
        try {
          paymentManager.updateSheet(customSheet,errorCode,errorMessage)
        } catch (e: IllegalStateException) {
          //Service is disconnected.
          Log.e(TAG, e.message.toString())
        } catch (e: NullPointerException) {
          Log.e(TAG, e.message.toString())
        }
      },0)
    }
    else {
      Handler(Looper.getMainLooper()).postDelayed({
        try {
          paymentManager.updateSheet(customSheet)
        } catch (e: IllegalStateException) {
          //Service is disconnected.
          Log.e(TAG, e.message.toString())
        } catch (e: NullPointerException) {
          Log.e(TAG, e.message.toString())
        }
      },0)
    }
  }

  private fun makeBundleWithRequestFilter(requestedCardtInfoJsonString: String): Bundle {
    val filter = Bundle()
    filter.putParcelableArrayList(PaymentManager.EXTRA_KEY_CARD_BRAND_FILTER, requestedBrandList(requestedCardtInfoJsonString))
    return filter
  }

  private fun requestedBrandList(requestedCardtInfoJsonString: String): ArrayList<SpaySdk.Brand>{
    var brandList = java.util.ArrayList<SpaySdk.Brand>()
    val brandListString = Gson().fromJson(requestedCardtInfoJsonString, RequestCardInfoPojo::class.java)
    brandList = brandListString.getBrandList()

    return brandList;
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun loggingCall(call: MethodCall) {
    Log.d(TAG, call.method.toString())
    if (call.arguments != null){
      Log.d(TAG, call.arguments.toString())
    }
  }
}
