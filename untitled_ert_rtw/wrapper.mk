###########################################################################
## Makefile for calling other makefiles
###########################################################################

###########################################################################
## MACROS
###########################################################################
###########################################################################
## TOOLCHAIN SPECIFICATIONS
###########################################################################
## Toolchain Name:          ESP32


###########################################################################
## FILE INCLUSIONS
###########################################################################
-include arduino_macros.mk
-include codertarget_assembly_flags.mk


###########################################################################
## TOOLCHAIN MACROS
###########################################################################
# ARDUINO_ROOT = Intrinsically defined
# ARDUINO_PORT = Intrinsically defined
# ARDUINO_MCU = Intrinsically defined
# ARDUINO_BAUD = Intrinsically defined
# ARDUINO_PROTOCOL = Intrinsically defined
# ARDUINO_F_CPU = Intrinsically defined
# ARDUINO_IDE_VERSION = Intrinsically defined
# ESP_BOARD_NAME = Intrinsically defined
# ESP_VARIANT_NAME = Intrinsically defined
# ESP_FLASH_MODE = Intrinsically defined
# ESP_FLASH_FREQUENCY = Intrinsically defined
# ESP_FLASH_SIZE = Intrinsically defined
# ESP_PARTITION_SCHEME = Intrinsically defined
# ESP_DEFINES = Intrinsically defined
# ESP_EXTRA_FLAGS = Intrinsically defined
# ESP_EXTRA_LIBS = Intrinsically defined
SHELL = %SystemRoot%/system32/cmd.exe
PRODUCT_HEX = $(RELATIVE_PATH_TO_ANCHOR)/$(PRODUCT_NAME).hex
PRODUCT_BIN = $(RELATIVE_PATH_TO_ANCHOR)/$(PRODUCT_NAME).bin
PRODUCT_MAP = $(RELATIVE_PATH_TO_ANCHOR)/$(PRODUCT_NAME).map
PRODUCT_PARTITION_BIN = $(RELATIVE_PATH_TO_ANCHOR)/$(PRODUCT_NAME).partitions.bin
PRODUCT_BOOTLOADER_BIN = $(RELATIVE_PATH_TO_ANCHOR)/$(PRODUCT_NAME).bootloader.bin
ARDUINO_XTENSA_TOOLS = $(ARDUINO_ESP32_ROOT)/tools/xtensa-esp32-elf-gcc/$(ESP32_GCC_VERSION)/bin
ARDUINO_ESP32_TOOLS = $(ARDUINO_ESP32_ROOT)/hardware/esp32/$(ESP32_LIB_VERSION)/tools
ARDUINO_ESP32_SDK = $(ARDUINO_ESP32_TOOLS)/sdk/esp32
ELF2BIN_OPTIONS =  elf2image --flash_mode $(ESP_FLASH_MODE) --flash_freq $(ESP_FLASH_FREQUENCY) --flash_size $(ESP_FLASH_SIZE) --elf-sha256-offset 0xb0
BOOTLOADER_IMAGE_OPTIONS =  elf2image --flash_mode $(ESP_FLASH_MODE) --flash_freq $(ESP_FLASH_FREQUENCY) --flash_size $(ESP_FLASH_SIZE)


#-------------------------
# Directives/Utilities
#-------------------------
RM                        = 
ECHO                      = echo
MV                        = 


#------------------------
# BUILD TOOL COMMANDS
#------------------------

# Assembler: ESP32 Assembler
AS_PATH := $(ARDUINO_XTENSA_TOOLS)
AS := $(AS_PATH)/xtensa-esp32-elf-gcc

# C Compiler: ESP32 C Compiler
CC_PATH := $(ARDUINO_XTENSA_TOOLS)
CC := $(CC_PATH)/xtensa-esp32-elf-gcc

# Linker: ESP32 Linker
LD_PATH = $(ARDUINO_XTENSA_TOOLS)
LD := $(LD_PATH)/xtensa-esp32-elf-g++


# C++ Compiler: ESP32 C++ Compiler
CPP_PATH := $(ARDUINO_XTENSA_TOOLS)
CPP := $(CPP_PATH)/xtensa-esp32-elf-g++

# C++ Linker: ESP32 C++ Linker
CPP_LD_PATH = $(ARDUINO_XTENSA_TOOLS)
CPP_LD := $(CPP_LD_PATH)/xtensa-esp32-elf-g++

# Archiver: ESP32 Archiver
AR_PATH := $(ARDUINO_XTENSA_TOOLS)
AR := $(AR_PATH)/xtensa-esp32-elf-ar

# Indexing: ESP32 Ranlib
RANLIB_PATH := $(ARDUINO_XTENSA_TOOLS)
RANLIB := $(RANLIB_PATH)/xtensa-esp32-elf-ranlib

# Execute: Execute
EXECUTE = $(PRODUCT)


# Builder: GMAKE Utility
MAKE_PATH = C:/Program Files/MATLAB/R2024a/bin/win64
MAKE = $(MAKE_PATH)/gmake


#--------------------------------------
# Faster Runs Build Configuration
#--------------------------------------
ARFLAGS              = cr
ASFLAGS              = -MMD -MP  \
                       -Wall \
                       -x assembler-with-cpp \
                       $(ASFLAGS_ADDITIONAL) \
                       $(DEFINES) \
                       $(INCLUDES) \
                       -c \
                       $(ESP_DEFINES) $(ESP_EXTRA_FLAGS)
ESPTOOLFLAGS_BIN     = --chip esp32 $(ELF2BIN_OPTIONS) -o $(PRODUCT_BIN)  $(PRODUCT)
CFLAGS               = -mlongcalls -Wno-frame-address -ffunction-sections -fdata-sections -Wno-error=unused-function -Wno-error=unused-variable -Wno-error=deprecated-declarations -Wno-unused-parameter -Wno-sign-compare -ggdb -freorder-blocks -Wwrite-strings -fstack-protector -fstrict-volatile-bitfields -Wno-error=unused-but-set-variable -fno-jump-tables -fno-tree-switch-conversion -std=gnu99 -Wno-old-style-declaration -MMD -c -w \
                       -DF_CPU=$(ARDUINO_F_CPU) -DARDUINO=$(ARDUINO_IDE_VERSION) -DARDUINO_$(ESP_BOARD_NAME)  \
                       -DARDUINO_ARCH_ESP32 "-DARDUINO_BOARD=\"$(ESP_BOARD_NAME)\"" "-DARDUINO_VARIANT=\"$(ESP_VARIANT_NAME)\"" -DARDUINO_PARTITION_$(ESP_PARTITION_SCHEME) -DESP32 -DCORE_DEBUG_LEVEL=0  \
                       -DARDUINO_RUNNING_CORE=1 -DARDUINO_EVENT_RUNNING_CORE=1 -DARDUINO_USB_CDC_ON_BOOT=0 @"$(ARDUINO_CODEGEN_FOLDER)/esp32sdkincludes.txt" \
                       -Os \
                       $(ESP_DEFINES) $(ESP_EXTRA_FLAGS)
CPPFLAGS             = -mlongcalls -Wno-frame-address -ffunction-sections -fdata-sections -Wno-error=unused-function -Wno-error=unused-variable -Wno-error=deprecated-declarations -Wno-unused-parameter -Wno-sign-compare -ggdb -freorder-blocks -Wwrite-strings -fstack-protector -fstrict-volatile-bitfields -Wno-error=unused-but-set-variable -fno-jump-tables -fno-tree-switch-conversion -std=gnu++11 -fexceptions -fno-rtti -MMD -c -w \
                       -DF_CPU=$(ARDUINO_F_CPU) -DARDUINO=$(ARDUINO_IDE_VERSION) -DARDUINO_$(ESP_BOARD_NAME)  \
                       -DARDUINO_ARCH_ESP32 "-DARDUINO_BOARD=\"$(ESP_BOARD_NAME)\"" "-DARDUINO_VARIANT=\"$(ESP_VARIANT_NAME)\"" -DARDUINO_PARTITION_$(ESP_PARTITION_SCHEME) -DESP32 -DCORE_DEBUG_LEVEL=0  \
                       -DARDUINO_RUNNING_CORE=1 -DARDUINO_EVENT_RUNNING_CORE=1 -DARDUINO_USB_CDC_ON_BOOT=0 @"$(ARDUINO_CODEGEN_FOLDER)/esp32sdkincludes.txt" \
                       -Os \
                       $(ESP_DEFINES) $(ESP_EXTRA_FLAGS)
CPP_LDFLAGS          = "-Wl,--Map=$(PRODUCT_MAP)"  \
                       "-L$(ARDUINO_ESP32_SDK)/lib" "-L$(ARDUINO_ESP32_SDK)/ld" "-L$(ARDUINO_ESP32_SDK)/qio_qspi" \
                       -T esp32.rom.redefined.ld -T memory.ld -T sections.ld -T esp32.rom.ld -T esp32.rom.api.ld -T esp32.rom.libgcc.ld -T esp32.rom.newlib-data.ld  \
                       -T esp32.rom.syscalls.ld -T esp32.peripherals.ld   \
                       -mlongcalls -Wno-frame-address -Wl,--cref -Wl,--gc-sections  \
                       -fno-rtti -fno-lto -Wl,--wrap=esp_log_write -Wl,--wrap=esp_log_writev  \
                       -Wl,--wrap=log_printf -u ld_include_hli_vectors_bt  \
                       -u _Z5setupv -u _Z4loopv -u esp_app_desc -u pthread_include_pthread_impl -u pthread_include_pthread_cond_impl  \
                       -u pthread_include_pthread_local_storage_impl -u pthread_include_pthread_rwlock_impl -u include_esp_phy_override  \
                       -u ld_include_highint_hdl -u start_app -u start_app_other_cores -u __ubsan_include -Wl,--wrap=longjmp -u __assert_func -u vfs_include_syscalls_impl  \
                       -Wl,--undefined=uxTopUsedPriority -u app_main -u newlib_include_heap_impl -u newlib_include_syscalls_impl -u newlib_include_pthread_impl  \
                       -u newlib_include_assert_impl -u __cxa_guard_dummy -DESP32 -DCORE_DEBUG_LEVEL=0 -DARDUINO_RUNNING_CORE=1 -DARDUINO_EVENT_RUNNING_CORE=1 -DARDUINO_USB_CDC_ON_BOOT=0  \
                       $(ESP_DEFINES) $(ESP_EXTRA_FLAGS)
CPP_SHAREDLIB_LDFLAGS =
DEF                  = --chip esp32 $(BOOTLOADER_IMAGE_OPTIONS) -o $(PRODUCT_BOOTLOADER_BIN)  $(ARDUINO_ESP32_SDK)/bin/bootloader_qio_80m.elf
DOWNLOAD_FLAGS       =
EXECUTE_FLAGS        =
LDFLAGS              = "-Wl,--Map=$(PRODUCT_MAP)"  \
                       "-L$(ARDUINO_ESP32_SDK)/lib" "-L$(ARDUINO_ESP32_SDK)/ld" "-L$(ARDUINO_ESP32_SDK)/qio_qspi" \
                       -T esp32.rom.redefined.ld -T memory.ld -T sections.ld -T esp32.rom.ld -T esp32.rom.api.ld -T esp32.rom.libgcc.ld -T esp32.rom.newlib-data.ld  \
                       -T esp32.rom.syscalls.ld -T esp32.peripherals.ld   \
                       -mlongcalls -Wno-frame-address -Wl,--cref -Wl,--gc-sections  \
                       -fno-rtti -fno-lto -Wl,--wrap=esp_log_write -Wl,--wrap=esp_log_writev  \
                       -Wl,--wrap=log_printf -u ld_include_hli_vectors_bt  \
                       -u _Z5setupv -u _Z4loopv -u esp_app_desc -u pthread_include_pthread_impl -u pthread_include_pthread_cond_impl  \
                       -u pthread_include_pthread_local_storage_impl -u pthread_include_pthread_rwlock_impl -u include_esp_phy_override  \
                       -u ld_include_highint_hdl -u start_app -u start_app_other_cores -u __ubsan_include -Wl,--wrap=longjmp -u __assert_func -u vfs_include_syscalls_impl  \
                       -Wl,--undefined=uxTopUsedPriority -u app_main -u newlib_include_heap_impl -u newlib_include_syscalls_impl -u newlib_include_pthread_impl  \
                       -u newlib_include_assert_impl -u __cxa_guard_dummy -DESP32 -DCORE_DEBUG_LEVEL=0 -DARDUINO_RUNNING_CORE=1 -DARDUINO_EVENT_RUNNING_CORE=1 -DARDUINO_USB_CDC_ON_BOOT=0  \
                       $(ESP_DEFINES) $(ESP_EXTRA_FLAGS)
MAKE_FLAGS           = -f $(MAKEFILE)
GENPARTFLAGS_HEX     = -q  $(START_DIR)/$(PRODUCT_NAME)_ert_rtw/partitions.csv $(PRODUCT_PARTITION_BIN)
SHAREDLIB_LDFLAGS    =


###########################################################################
## ADDITIONAL TOOLCHAIN FLAGS
###########################################################################
#---------------
# C Compiler
#---------------
CFLAGS_SKIPFORSIL = -DHAVE_CONFIG_H "-DMBEDTLS_CONFIG_FILE=\"mbedtls/esp_config.h\"" -DUNITY_INCLUDE_CONFIG_H -DWITH_POSIX -D_GNU_SOURCE "-DIDF_VER=\"v4.4.5\"" -DESP_PLATFORM -D_POSIX_READER_WRITER_LOCKS -D_RUNONTARGETHARDWARE_BUILD_ -DMW_DONOTSTART_SCHEDULER -D_ROTH_ESP32_
CFLAGS_BASIC = $(DEFINES) $(INCLUDES)
CFLAGS += $(CFLAGS_SKIPFORSIL) $(CFLAGS_BASIC)
#-----------------
# C++ Compiler
#-----------------
CPPFLAGS_SKIPFORSIL = -DHAVE_CONFIG_H "-DMBEDTLS_CONFIG_FILE=\"mbedtls/esp_config.h\"" -DUNITY_INCLUDE_CONFIG_H -DWITH_POSIX -D_GNU_SOURCE "-DIDF_VER=\"v4.4.5\"" -DESP_PLATFORM -D_POSIX_READER_WRITER_LOCKS -D_RUNONTARGETHARDWARE_BUILD_ -DMW_DONOTSTART_SCHEDULER -D_ROTH_ESP32_
CPPFLAGS_BASIC = $(DEFINES) $(INCLUDES)
CPPFLAGS += $(CPPFLAGS_SKIPFORSIL) $(CPPFLAGS_BASIC)
#---------------
# C++ Linker
#---------------
CPP_LDFLAGS_SKIPFORSIL =  
CPP_LDFLAGS += $(CPP_LDFLAGS_SKIPFORSIL)
#------------------------------
# C++ Shared Library Linker
#------------------------------
CPP_SHAREDLIB_LDFLAGS_SKIPFORSIL =  
CPP_SHAREDLIB_LDFLAGS += $(CPP_SHAREDLIB_LDFLAGS_SKIPFORSIL)
#-----------
# Linker
#-----------
LDFLAGS_SKIPFORSIL =  
LDFLAGS += $(LDFLAGS_SKIPFORSIL)
#--------------------------
# Shared Library Linker
#--------------------------
SHAREDLIB_LDFLAGS_SKIPFORSIL =  
SHAREDLIB_LDFLAGS += $(SHAREDLIB_LDFLAGS_SKIPFORSIL)


###########################################################################
## Define Macros
###########################################################################
SLMKPATH=C:/PROGRA~3/MATLAB/SUPPOR~1/R2024a/toolbox/target/SUPPOR~1/ARDUIN~1/STATIC~1
MODELMK=untitled.mk
SLIB_PATH=C:/Users/kzlee/DOCUME~1/MATLAB/R2024a/ARDUIN~1/ESP32W~1/FASTER~1
VARIANT_HEADER_PATH=$(ARDUINO_ESP32_ROOT)/hardware/esp32/2.0.11/variants/esp32
ARDUINO_SKETCHBOOK_ROOT=C:/PROGRA~3/MATLAB/SUPPOR~1/R2024a/aCLI/user/LIBRAR~1
ARDUINO_BASESUPPORTPKG_ROOT=C:/PROGRA~3/MATLAB/SUPPOR~1/R2024a/toolbox/target/SUPPOR~1/ARDUIN~1


###########################################################################
## Export Variables
###########################################################################
export AR
export RANLIB
export AS
export CC
export CPP
export ASFLAGS
export CFLAGS
export CPPFLAGS
export ARFLAGS
export SLIB_PATH
export VARIANT_HEADER_PATH
export ARDUINO_SKETCHBOOK_ROOT
export ARDUINO_BASESUPPORTPKG_ROOT


###########################################################################
## PHONY TARGETS
###########################################################################
.PHONY : all
all : 
	@echo "### Generating static library."
	"$(MAKE)" -j5 -C "$(SLMKPATH)" SHELL="$(SHELL)" -f esp32core.mk all
	"$(MAKE)" -j5 SHELL="$(SHELL)" -f "$(MODELMK)" all

