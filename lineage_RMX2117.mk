#
# Copyright (C) 2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit from RMX2117L1 device
$(call inherit-product, device/realme/RMX2117/device.mk)

PRODUCT_DEVICE := RMX2117
PRODUCT_NAME := lineage_RMX2117
PRODUCT_BRAND := Realme
PRODUCT_MODEL := Realme Narzo 30 Pro
PRODUCT_MANUFACTURER := Realme

PRODUCT_GMS_CLIENTID_BASE := android-realme

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="RMX2117L1 12 SP1A.210812.016 Q.202208092022 release-keys"

BUILD_FINGERPRINT := realme/RMX2117/RMX2117L1:12/SP1A.210812.016/Q.202208092022:user/release-keys
