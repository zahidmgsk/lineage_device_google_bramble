#
# Copyright 2018 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# All components inherited here go to system image
#
ifeq (,$(filter %_64,$(TARGET_PRODUCT)))
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
else
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
endif
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_system.mk)

# Inherit some common AOSP stuff.
TARGET_DISABLE_EPPE := true
$(call inherit-product, vendor/aosp/config/common_full_phone.mk)

# Inherit device configuration
$(call inherit-product, device/google/bramble/aosp_bramble.mk)
$(call inherit-product, device/google/redbull/lineage_common.mk)

include device/google/bramble/device-aosp.mk

# Enable mainline checking
PRODUCT_ENFORCE_ARTIFACT_PATH_REQUIREMENTS := strict

#
# All components inherited here go to system_ext image
#
$(call inherit-product, $(SRC_TARGET_DIR)/product/handheld_system_ext.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/telephony_system_ext.mk)

#
# All components inherited here go to product image
#
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_product.mk)

#
# All components inherited here go to vendor image
#
# TODO(b/136525499): move *_vendor.mk into the vendor makefile later
$(call inherit-product, $(SRC_TARGET_DIR)/product/handheld_vendor.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/telephony_vendor.mk)

$(call inherit-product, device/google/bramble/device-bramble.mk)
$(call inherit-product-if-exists, vendor/google_devices/bramble/proprietary/device-vendor.mk)
$(call inherit-product-if-exists, vendor/google_devices/bramble/prebuilts/device-vendor-bramble.mk)

# Keep the VNDK APEX in /system partition for REL branches as these branches are
# expected to have stable API/ABI surfaces.
ifneq (REL,$(PLATFORM_VERSION_CODENAME))
  PRODUCT_PACKAGES += com.android.vndk.current.on_vendor
endif

# Don't build super.img.
PRODUCT_BUILD_SUPER_PARTITION := false

# b/113232673 STOPSHIP deal with Qualcomm stuff later
# PRODUCT_RESTRICT_VENDOR_FILES := all

# Device identifier. This must come after all inclusions
PRODUCT_MANUFACTURER := Google
PRODUCT_BRAND := Android
PRODUCT_NAME := aosp_bramble
PRODUCT_DEVICE := bramble
PRODUCT_MODEL := Pixel 4a (5G)

# Boot animation
TARGET_SCREEN_HEIGHT := 2340
TARGET_SCREEN_WIDTH := 1080
TARGET_BOOT_ANIMATION_RES := 1080

PRODUCT_BUILD_PROP_OVERRIDES += \
    TARGET_PRODUCT=bramble \
    PRIVATE_BUILD_DESC="bramble-user 14 UP1A.231105.001.B2 11260668 release-keys"

BUILD_FINGERPRINT := google/bramble/bramble:14/UP1A.231105.001.B2/11260668:user/release-keys

$(call inherit-product, vendor/google/bramble/bramble-vendor.mk)
