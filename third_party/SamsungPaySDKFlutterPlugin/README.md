# Samsung Pay SDK Flutter Plugin (official)

This folder contains the **official** Samsung Pay SDK Flutter Plugin downloaded from [Samsung Developer](https://developer.samsung.com/pay/web/download.html). Only the **Libs** copy is kept; Samsung’s sample apps (sample_merchant, sample_issuer) were removed because Moyasar only needs the plugin for **Samsung Pay In-App Payment** (merchant flow), not the demos or issuer flow.

## What’s here

- **`Libs/samsungpaysdkflutter_v1.01.00`** — the plugin. The moyasar SDK depends on this path for Samsung Pay.

## MADA support

The plugin uses **samsungpay_2.22.00.jar** (the same as **moyasar-android-sdk** in `moyasar-android-sdk/sdk/libs/`). This version includes `SpaySdk.Brand.MADA`, so MADA is supported in Flutter: use `supportedNetworks: ['mada', ...]` in your Samsung Pay config and the native sheet will allow MADA cards.
