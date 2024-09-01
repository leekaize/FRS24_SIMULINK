###########################################################################
## Makefile generated for component 'untitled'. 
## 
## Makefile     : untitled.mk
## Generated on : Wed Aug 28 15:12:35 2024
## Final product: $(RELATIVE_PATH_TO_ANCHOR)/untitled.elf
## Product type : executable
## 
###########################################################################

###########################################################################
## MACROS
###########################################################################

# Macro Descriptions:
# PRODUCT_NAME            Name of the system to build
# MAKEFILE                Name of this makefile

PRODUCT_NAME              = untitled
MAKEFILE                  = untitled.mk
MATLAB_ROOT               = C:/PROGRA~1/MATLAB/R2024a
MATLAB_BIN                = C:/PROGRA~1/MATLAB/R2024a/bin
MATLAB_ARCH_BIN           = $(MATLAB_BIN)/win64
START_DIR                 = C:/Users/kzlee/Desktop/FRS24/FRS24_SIMULINK
SOLVER                    = 
SOLVER_OBJ                = 
CLASSIC_INTERFACE         = 0
TGT_FCN_LIB               = None
MODEL_HAS_DYNAMICALLY_LOADED_SFCNS = 0
RELATIVE_PATH_TO_ANCHOR   = ..
SLIB_PATH                 = C:/Users/kzlee/DOCUME~1/MATLAB/R2024a/ARDUIN~1/ESP32W~1/FASTER~1
C_STANDARD_OPTS           = 
CPP_STANDARD_OPTS         = 

###########################################################################
## TOOLCHAIN SPECIFICATIONS
###########################################################################

# Toolchain Name:          ESP32
# Supported Version(s):    
# ToolchainInfo Version:   2024a
# Specification Revision:  1.0
# 
#-------------------------------------------
# Macros assumed to be defined elsewhere
#-------------------------------------------

# ARDUINO_ROOT
# ARDUINO_PORT
# ARDUINO_MCU
# ARDUINO_BAUD
# ARDUINO_PROTOCOL
# ARDUINO_F_CPU
# ARDUINO_IDE_VERSION
# ESP_BOARD_NAME
# ESP_VARIANT_NAME
# ESP_FLASH_MODE
# ESP_FLASH_FREQUENCY
# ESP_FLASH_SIZE
# ESP_PARTITION_SCHEME
# ESP_DEFINES
# ESP_EXTRA_FLAGS
# ESP_EXTRA_LIBS

#-----------
# MACROS
#-----------

SHELL                    = %SystemRoot%/system32/cmd.exe
PRODUCT_HEX              = $(RELATIVE_PATH_TO_ANCHOR)/$(PRODUCT_NAME).hex
PRODUCT_BIN              = $(RELATIVE_PATH_TO_ANCHOR)/$(PRODUCT_NAME).bin
PRODUCT_MAP              = $(RELATIVE_PATH_TO_ANCHOR)/$(PRODUCT_NAME).map
PRODUCT_PARTITION_BIN    = $(RELATIVE_PATH_TO_ANCHOR)/$(PRODUCT_NAME).partitions.bin
PRODUCT_BOOTLOADER_BIN   = $(RELATIVE_PATH_TO_ANCHOR)/$(PRODUCT_NAME).bootloader.bin
ARDUINO_XTENSA_TOOLS     = $(ARDUINO_ESP32_ROOT)/tools/xtensa-esp32-elf-gcc/$(ESP32_GCC_VERSION)/bin
ARDUINO_ESP32_TOOLS      = $(ARDUINO_ESP32_ROOT)/hardware/esp32/$(ESP32_LIB_VERSION)/tools
ARDUINO_ESP32_SDK        = $(ARDUINO_ESP32_TOOLS)/sdk/esp32
ELF2BIN_OPTIONS          =  elf2image --flash_mode $(ESP_FLASH_MODE) --flash_freq $(ESP_FLASH_FREQUENCY) --flash_size $(ESP_FLASH_SIZE) --elf-sha256-offset 0xb0 
BOOTLOADER_IMAGE_OPTIONS =  elf2image --flash_mode $(ESP_FLASH_MODE) --flash_freq $(ESP_FLASH_FREQUENCY) --flash_size $(ESP_FLASH_SIZE) 

TOOLCHAIN_SRCS = 
TOOLCHAIN_INCS = 
TOOLCHAIN_LIBS = -Wl,--start-group @"$(ARDUINO_CODEGEN_FOLDER)/esp32linkerlibs.txt"  $(ESP_EXTRA_LIBS) -Wl,--end-group -Wl,-EL -lcore

#------------------------
# BUILD TOOL COMMANDS
#------------------------

# Assembler: ESP32 Assembler
AS_PATH = $(ARDUINO_XTENSA_TOOLS)
AS = "$(AS_PATH)/xtensa-esp32-elf-gcc"

# C Compiler: ESP32 C Compiler
CC_PATH = $(ARDUINO_XTENSA_TOOLS)
CC = "$(CC_PATH)/xtensa-esp32-elf-gcc"

# Linker: ESP32 Linker
LD_PATH = $(ARDUINO_XTENSA_TOOLS)
LD = "$(LD_PATH)/xtensa-esp32-elf-g++"

# C++ Compiler: ESP32 C++ Compiler
CPP_PATH = $(ARDUINO_XTENSA_TOOLS)
CPP = "$(CPP_PATH)/xtensa-esp32-elf-g++"

# C++ Linker: ESP32 C++ Linker
CPP_LD_PATH = $(ARDUINO_XTENSA_TOOLS)
CPP_LD = "$(CPP_LD_PATH)/xtensa-esp32-elf-g++"

# Archiver: ESP32 Archiver
AR_PATH = $(ARDUINO_XTENSA_TOOLS)
AR = "$(AR_PATH)/xtensa-esp32-elf-ar"

# MEX Tool: MEX Tool
MEX_PATH = $(MATLAB_ARCH_BIN)
MEX = "$(MEX_PATH)/mex"

# Binary Converter: Binary Converter
ESPTOOL = $(ARDUINO_ESP32_ROOT)/tools/esptool_py/$(ESP32_FLASHTOOL_VERSION)/esptool.exe

# Partition Generator: Partition Generator
GENPART = $(ARDUINO_ESP32_TOOLS)/gen_esp32part.exe

# Create Bootloader Image: Create Bootloader Image
ESPTOOL = $(ARDUINO_ESP32_ROOT)/tools/esptool_py/$(ESP32_FLASHTOOL_VERSION)/esptool.exe

# Download: Download
DOWNLOAD =

# Execute: Execute
EXECUTE = $(PRODUCT)

# Builder: Make Tool
MAKE_PATH = %MATLAB%\bin\win64
MAKE = "$(MAKE_PATH)/gmake"


#-------------------------
# Directives/Utilities
#-------------------------

ASDEBUG             = -g
AS_OUTPUT_FLAG      = -o
CDEBUG              = -g
C_OUTPUT_FLAG       = -o
LDDEBUG             = -g
OUTPUT_FLAG         = -o
CPPDEBUG            = -g
CPP_OUTPUT_FLAG     = -o
CPPLDDEBUG          = -g
OUTPUT_FLAG         = -o
ARDEBUG             =
STATICLIB_OUTPUT_FLAG =
MEX_DEBUG           = -g
RM                  =
ECHO                = echo
MV                  =
RUN                 =

#--------------------------------------
# "Faster Runs" Build Configuration
#--------------------------------------

ARFLAGS              = cr
ASFLAGS              = -MMD -MP -MF"$(@:%.o=%.dep)" -MT"$@"  \
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
CPP_SHAREDLIB_LDFLAGS  =
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
MEX_CPPFLAGS         =
MEX_CPPLDFLAGS       =
MEX_CFLAGS           =
MEX_LDFLAGS          =
MAKE_FLAGS           = -f $(MAKEFILE)
GENPARTFLAGS_HEX     = -q  $(START_DIR)/$(PRODUCT_NAME)_ert_rtw/partitions.csv $(PRODUCT_PARTITION_BIN)
SHAREDLIB_LDFLAGS    =



###########################################################################
## OUTPUT INFO
###########################################################################

PRODUCT = $(RELATIVE_PATH_TO_ANCHOR)/untitled.elf
PRODUCT_TYPE = "executable"
BUILD_TYPE = "Top-Level Standalone Executable"

###########################################################################
## INCLUDE PATHS
###########################################################################

INCLUDES_BUILDINFO = -I$(START_DIR) -IC:/PROGRA~3/MATLAB/SUPPOR~1/R2024a/toolbox/target/SUPPOR~1/ARDUIN~1/include -I$(START_DIR)/untitled_ert_rtw -I$(MATLAB_ROOT)/extern/include -I$(MATLAB_ROOT)/simulink/include -I$(MATLAB_ROOT)/rtw/c/src -I$(MATLAB_ROOT)/rtw/c/src/ext_mode/common -I$(MATLAB_ROOT)/rtw/c/ert -I$(ARDUINO_ESP32_ROOT)/hardware/esp32/$(ESP32_LIB_VERSION)/cores/esp32 -I$(ARDUINO_ESP32_ROOT)/hardware/esp32/$(ESP32_LIB_VERSION)/variants/esp32 -I$(ARDUINO_ESP32_ROOT)/tools/esptool_py -I$(ARDUINO_ESP32_ROOT)/tools/mkspiffs -IC:/PROGRA~3/MATLAB/SUPPOR~1/R2024a/toolbox/target/SUPPOR~1/ARDUIN~2/include -IC:/PROGRA~3/MATLAB/SUPPOR~1/R2024a/toolbox/target/SUPPOR~1/ARDUIN~2/SCHEDU~1/include -IC:/PROGRA~3/MATLAB/SUPPOR~1/R2024a/toolbox/target/shared/freertos/include -I$(START_DIR)/include

INCLUDES = $(INCLUDES_BUILDINFO)

###########################################################################
## DEFINES
###########################################################################

DEFINES_ = -D__MW_TARGET_USE_HARDWARE_RESOURCES_H__ -DMW_TIMERID=3 -DMW_PRESCALAR=256 -DMW_TIMERCOUNT=59286 -DMW_SCHEDULERCOUNTER=1 -DARDUINO_NUM_SERIAL_PORTS=3 -DARDUINO_SERIAL_RECEIVE_BUFFER_SIZE=256 -D_RTT_BAUDRATE_SERIAL0_=9600 -D_RTT_BAUDRATE_SERIAL1_=9600 -D_RTT_BAUDRATE_SERIAL2_=9600 -D_RTT_CONFIG_SERIAL0_=SERIAL_8N1 -D_RTT_CONFIG_SERIAL1_=SERIAL_8N1 -D_RTT_CONFIG_SERIAL2_=SERIAL_8N1 -D_RTT_TX_PIN_SERIAL0_=1 -D_RTT_RX_PIN_SERIAL0_=3 -D_RTT_TX_PIN_SERIAL1_=33 -D_RTT_RX_PIN_SERIAL1_=32 -D_RTT_TX_PIN_SERIAL2_=17 -D_RTT_RX_PIN_SERIAL2_=16 -D_RTT_ANALOG_REF_=0 -DMW_NUM_PINS=25 -D_ONBOARD_EEPROM_SIZE_=0
DEFINES_BUILD_ARGS = -DCLASSIC_INTERFACE=0 -DALLOCATIONFCN=0 -DTERMFCN=1 -DONESTEPFCN=1 -DMAT_FILE=0 -DMULTI_INSTANCE_CODE=0 -DINTEGER_CODE=0 -DMT=0
DEFINES_CUSTOM = 
DEFINES_OPTS = -DTID01EQ=0
DEFINES_SKIPFORSIL = -DXCP_CUSTOM_PLATFORM -DEXIT_FAILURE=1 -DEXTMODE_DISABLEPRINTF -DEXTMODE_DISABLETESTING -DEXTMODE_DISABLE_ARGS_PROCESSING=1 -DINCLUDE_xTaskGetCurrentTaskHandle=1 -DOS_STKSIZE=8192 -DINCLUDE_vTaskDelete -DINCLUDE_vTaskDelay=1 -DUSE_FREERTOS -DSTACK_SIZE=64 -DRT
DEFINES_STANDARD = -DMODEL=untitled -DNUMST=1 -DNCSTATES=0 -DHAVESTDIO -DMODEL_HAS_DYNAMICALLY_LOADED_SFCNS=0

DEFINES = $(DEFINES_) $(DEFINES_BUILD_ARGS) $(DEFINES_CUSTOM) $(DEFINES_OPTS) $(DEFINES_SKIPFORSIL) $(DEFINES_STANDARD)

###########################################################################
## SOURCE FILES
###########################################################################

SRCS = C:/ProgramData/MATLAB/SupportPackages/R2024a/toolbox/target/supportpackages/arduinobase/src/MW_arduino_digitalio.cpp $(START_DIR)/untitled_ert_rtw/untitled.c $(START_DIR)/untitled_ert_rtw/untitled_data.c C:/ProgramData/MATLAB/SupportPackages/R2024a/toolbox/target/supportpackages/arduinotarget/src/MW_ArduinoHWInit.cpp C:/ProgramData/MATLAB/SupportPackages/R2024a/toolbox/target/supportpackages/arduinobase/src/io_wrappers.cpp "$(ARDUINO_ESP32_ROOT)/hardware/esp32/$(ESP32_LIB_VERSION)/cores/esp32/IPAddress.cpp" "$(ARDUINO_ESP32_ROOT)/hardware/esp32/$(ESP32_LIB_VERSION)/cores/esp32/Print.cpp" C:/ProgramData/MATLAB/SupportPackages/R2024a/toolbox/target/shared/freertos/src/mw_freertos_init.c C:/ProgramData/MATLAB/SupportPackages/R2024a/toolbox/target/shared/freertos/src/mw_thread.c C:/ProgramData/MATLAB/SupportPackages/R2024a/toolbox/target/shared/freertos/src/mw_timer.c C:/ProgramData/MATLAB/SupportPackages/R2024a/toolbox/target/shared/freertos/src/mw_semaphore.c

MAIN_SRC = $(START_DIR)/untitled_ert_rtw/ert_main.c

ALL_SRCS = $(SRCS) $(MAIN_SRC)

###########################################################################
## OBJECTS
###########################################################################

OBJS = MW_arduino_digitalio.o untitled.o untitled_data.o MW_ArduinoHWInit.o io_wrappers.o IPAddress.o Print.o mw_freertos_init.o mw_thread.o mw_timer.o mw_semaphore.o

MAIN_OBJ = ert_main.o

ALL_OBJS = $(OBJS) $(MAIN_OBJ)

###########################################################################
## PREBUILT OBJECT FILES
###########################################################################

PREBUILT_OBJS = 

###########################################################################
## LIBRARIES
###########################################################################

LIBS = $(SLIB_PATH)/MW_RebuildSrc_Core.o $(SLIB_PATH)/libcore.a

###########################################################################
## SYSTEM LIBRARIES
###########################################################################

SYSTEM_LIBS = 

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

CPP_LDFLAGS_ = -L"$(SLIB_PATH)"
CPP_LDFLAGS_SKIPFORSIL =  

CPP_LDFLAGS += $(CPP_LDFLAGS_) $(CPP_LDFLAGS_SKIPFORSIL)

#------------------------------
# C++ Shared Library Linker
#------------------------------

CPP_SHAREDLIB_LDFLAGS_ = -L"$(SLIB_PATH)"
CPP_SHAREDLIB_LDFLAGS_SKIPFORSIL =  

CPP_SHAREDLIB_LDFLAGS += $(CPP_SHAREDLIB_LDFLAGS_) $(CPP_SHAREDLIB_LDFLAGS_SKIPFORSIL)

#-----------
# Linker
#-----------

LDFLAGS_ = -L"$(SLIB_PATH)"
LDFLAGS_SKIPFORSIL =  

LDFLAGS += $(LDFLAGS_) $(LDFLAGS_SKIPFORSIL)

#--------------------------
# Shared Library Linker
#--------------------------

SHAREDLIB_LDFLAGS_ = -L"$(SLIB_PATH)"
SHAREDLIB_LDFLAGS_SKIPFORSIL =  

SHAREDLIB_LDFLAGS += $(SHAREDLIB_LDFLAGS_) $(SHAREDLIB_LDFLAGS_SKIPFORSIL)

###########################################################################
## INLINED COMMANDS
###########################################################################


DERIVED_SRCS = $(subst .o,.dep,$(OBJS))

build:

%.dep:



-include arduino_macros.mk
-include codertarget_assembly_flags.mk
-include *.dep


###########################################################################
## PHONY TARGETS
###########################################################################

.PHONY : all build buildobj clean info prebuild postbuild download execute


all : build postbuild
	echo "### Successfully generated all binary outputs."


build : prebuild $(PRODUCT)


buildobj : prebuild $(OBJS) $(PREBUILT_OBJS) $(LIBS)
	echo "### Successfully generated all binary outputs."


prebuild : 


postbuild : $(PRODUCT)
	echo "### Invoking postbuild tool "Binary Converter" ..."
	$(ESPTOOL) $(ESPTOOLFLAGS_BIN)
	echo "### Done invoking postbuild tool."
	echo "### Invoking postbuild tool "Partition Generator" ..."
	$(GENPART) $(GENPARTFLAGS_HEX)
	echo "### Done invoking postbuild tool."
	echo "### Invoking postbuild tool "Create Bootloader Image" ..."
	$(ESPTOOL) $(DEF)
	echo "### Done invoking postbuild tool."


download : postbuild


execute : download
	echo "### Invoking postbuild tool "Execute" ..."
	$(EXECUTE) $(EXECUTE_FLAGS)
	echo "### Done invoking postbuild tool."


###########################################################################
## FINAL TARGET
###########################################################################

#-------------------------------------------
# Create a standalone executable            
#-------------------------------------------

$(PRODUCT) : $(OBJS) $(PREBUILT_OBJS) $(LIBS) $(MAIN_OBJ)
	echo "### Creating standalone executable "$(PRODUCT)" ..."
	$(CPP_LD) $(CPP_LDFLAGS) -o $(PRODUCT) $(OBJS) $(MAIN_OBJ) $(LIBS) $(SYSTEM_LIBS) $(TOOLCHAIN_LIBS)
	echo "### Created: $(PRODUCT)"


###########################################################################
## INTERMEDIATE TARGETS
###########################################################################

#---------------------
# SOURCE-TO-OBJECT
#---------------------

%.o : %.c
	$(CC) $(CFLAGS) -o "$@" "$<"


%.S.o : %.s
	$(AS) $(ASFLAGS) -o "$@" "$<"


%.S.o : %.S
	$(AS) $(ASFLAGS) -o "$@" "$<"


%.o : %.cpp
	$(CPP) $(CPPFLAGS) -o "$@" "$<"


%.o : $(RELATIVE_PATH_TO_ANCHOR)/%.c
	$(CC) $(CFLAGS) -o "$@" "$<"


%.S.o : $(RELATIVE_PATH_TO_ANCHOR)/%.s
	$(AS) $(ASFLAGS) -o "$@" "$<"


%.S.o : $(RELATIVE_PATH_TO_ANCHOR)/%.S
	$(AS) $(ASFLAGS) -o "$@" "$<"


%.o : $(RELATIVE_PATH_TO_ANCHOR)/%.cpp
	$(CPP) $(CPPFLAGS) -o "$@" "$<"


%.o : $(START_DIR)/%.c
	$(CC) $(CFLAGS) -o "$@" "$<"


%.S.o : $(START_DIR)/%.s
	$(AS) $(ASFLAGS) -o "$@" "$<"


%.S.o : $(START_DIR)/%.S
	$(AS) $(ASFLAGS) -o "$@" "$<"


%.o : $(START_DIR)/%.cpp
	$(CPP) $(CPPFLAGS) -o "$@" "$<"


%.o : C:/ProgramData/MATLAB/SupportPackages/R2024a/toolbox/target/supportpackages/arduinobase/src/%.c
	$(CC) $(CFLAGS) -o "$@" "$<"


%.S.o : C:/ProgramData/MATLAB/SupportPackages/R2024a/toolbox/target/supportpackages/arduinobase/src/%.s
	$(AS) $(ASFLAGS) -o "$@" "$<"


%.S.o : C:/ProgramData/MATLAB/SupportPackages/R2024a/toolbox/target/supportpackages/arduinobase/src/%.S
	$(AS) $(ASFLAGS) -o "$@" "$<"


%.o : C:/ProgramData/MATLAB/SupportPackages/R2024a/toolbox/target/supportpackages/arduinobase/src/%.cpp
	$(CPP) $(CPPFLAGS) -o "$@" "$<"


%.o : $(START_DIR)/untitled_ert_rtw/%.c
	$(CC) $(CFLAGS) -o "$@" "$<"


%.S.o : $(START_DIR)/untitled_ert_rtw/%.s
	$(AS) $(ASFLAGS) -o "$@" "$<"


%.S.o : $(START_DIR)/untitled_ert_rtw/%.S
	$(AS) $(ASFLAGS) -o "$@" "$<"


%.o : $(START_DIR)/untitled_ert_rtw/%.cpp
	$(CPP) $(CPPFLAGS) -o "$@" "$<"


%.o : $(MATLAB_ROOT)/rtw/c/src/%.c
	$(CC) $(CFLAGS) -o "$@" "$<"


%.S.o : $(MATLAB_ROOT)/rtw/c/src/%.s
	$(AS) $(ASFLAGS) -o "$@" "$<"


%.S.o : $(MATLAB_ROOT)/rtw/c/src/%.S
	$(AS) $(ASFLAGS) -o "$@" "$<"


%.o : $(MATLAB_ROOT)/rtw/c/src/%.cpp
	$(CPP) $(CPPFLAGS) -o "$@" "$<"


%.o : $(MATLAB_ROOT)/simulink/src/%.c
	$(CC) $(CFLAGS) -o "$@" "$<"


%.S.o : $(MATLAB_ROOT)/simulink/src/%.s
	$(AS) $(ASFLAGS) -o "$@" "$<"


%.S.o : $(MATLAB_ROOT)/simulink/src/%.S
	$(AS) $(ASFLAGS) -o "$@" "$<"


%.o : $(MATLAB_ROOT)/simulink/src/%.cpp
	$(CPP) $(CPPFLAGS) -o "$@" "$<"


%.o : $(MATLAB_ROOT)/toolbox/simulink/blocks/src/%.c
	$(CC) $(CFLAGS) -o "$@" "$<"


%.S.o : $(MATLAB_ROOT)/toolbox/simulink/blocks/src/%.s
	$(AS) $(ASFLAGS) -o "$@" "$<"


%.S.o : $(MATLAB_ROOT)/toolbox/simulink/blocks/src/%.S
	$(AS) $(ASFLAGS) -o "$@" "$<"


%.o : $(MATLAB_ROOT)/toolbox/simulink/blocks/src/%.cpp
	$(CPP) $(CPPFLAGS) -o "$@" "$<"


MW_arduino_digitalio.o : C:/ProgramData/MATLAB/SupportPackages/R2024a/toolbox/target/supportpackages/arduinobase/src/MW_arduino_digitalio.cpp
	$(CPP) $(CPPFLAGS) -o "$@" "$<"


ert_main.o : $(START_DIR)/untitled_ert_rtw/ert_main.c
	$(CC) $(CFLAGS) -o "$@" "$<"


untitled.o : $(START_DIR)/untitled_ert_rtw/untitled.c
	$(CC) $(CFLAGS) -o "$@" "$<"


untitled_data.o : $(START_DIR)/untitled_ert_rtw/untitled_data.c
	$(CC) $(CFLAGS) -o "$@" "$<"


MW_ArduinoHWInit.o : C:/ProgramData/MATLAB/SupportPackages/R2024a/toolbox/target/supportpackages/arduinotarget/src/MW_ArduinoHWInit.cpp
	$(CPP) $(CPPFLAGS) -o "$@" "$<"


io_wrappers.o : C:/ProgramData/MATLAB/SupportPackages/R2024a/toolbox/target/supportpackages/arduinobase/src/io_wrappers.cpp
	$(CPP) $(CPPFLAGS) -o "$@" "$<"


IPAddress.o : $(ARDUINO_ESP32_ROOT)/hardware/esp32/$(ESP32_LIB_VERSION)/cores/esp32/IPAddress.cpp
	$(CPP) $(CPPFLAGS) -o "$@" "$<"


Print.o : $(ARDUINO_ESP32_ROOT)/hardware/esp32/$(ESP32_LIB_VERSION)/cores/esp32/Print.cpp
	$(CPP) $(CPPFLAGS) -o "$@" "$<"


mw_freertos_init.o : C:/ProgramData/MATLAB/SupportPackages/R2024a/toolbox/target/shared/freertos/src/mw_freertos_init.c
	$(CC) $(CFLAGS) -o "$@" "$<"


mw_thread.o : C:/ProgramData/MATLAB/SupportPackages/R2024a/toolbox/target/shared/freertos/src/mw_thread.c
	$(CC) $(CFLAGS) -o "$@" "$<"


mw_timer.o : C:/ProgramData/MATLAB/SupportPackages/R2024a/toolbox/target/shared/freertos/src/mw_timer.c
	$(CC) $(CFLAGS) -o "$@" "$<"


mw_semaphore.o : C:/ProgramData/MATLAB/SupportPackages/R2024a/toolbox/target/shared/freertos/src/mw_semaphore.c
	$(CC) $(CFLAGS) -o "$@" "$<"


###########################################################################
## DEPENDENCIES
###########################################################################

$(ALL_OBJS) : rtw_proj.tmw $(MAKEFILE)


###########################################################################
## MISCELLANEOUS TARGETS
###########################################################################

info : 
	echo "### PRODUCT = $(PRODUCT)"
	echo "### PRODUCT_TYPE = $(PRODUCT_TYPE)"
	echo "### BUILD_TYPE = $(BUILD_TYPE)"
	echo "### INCLUDES = $(INCLUDES)"
	echo "### DEFINES = $(DEFINES)"
	echo "### ALL_SRCS = $(ALL_SRCS)"
	echo "### ALL_OBJS = $(ALL_OBJS)"
	echo "### LIBS = $(LIBS)"
	echo "### MODELREF_LIBS = $(MODELREF_LIBS)"
	echo "### SYSTEM_LIBS = $(SYSTEM_LIBS)"
	echo "### TOOLCHAIN_LIBS = $(TOOLCHAIN_LIBS)"
	echo "### ASFLAGS = $(ASFLAGS)"
	echo "### CFLAGS = $(CFLAGS)"
	echo "### LDFLAGS = $(LDFLAGS)"
	echo "### SHAREDLIB_LDFLAGS = $(SHAREDLIB_LDFLAGS)"
	echo "### CPPFLAGS = $(CPPFLAGS)"
	echo "### CPP_LDFLAGS = $(CPP_LDFLAGS)"
	echo "### CPP_SHAREDLIB_LDFLAGS = $(CPP_SHAREDLIB_LDFLAGS)"
	echo "### ARFLAGS = $(ARFLAGS)"
	echo "### MEX_CFLAGS = $(MEX_CFLAGS)"
	echo "### MEX_CPPFLAGS = $(MEX_CPPFLAGS)"
	echo "### MEX_LDFLAGS = $(MEX_LDFLAGS)"
	echo "### MEX_CPPLDFLAGS = $(MEX_CPPLDFLAGS)"
	echo "### ESPTOOLFLAGS_BIN = $(ESPTOOLFLAGS_BIN)"
	echo "### GENPARTFLAGS_HEX = $(GENPARTFLAGS_HEX)"
	echo "### DEF = $(DEF)"
	echo "### DOWNLOAD_FLAGS = $(DOWNLOAD_FLAGS)"
	echo "### EXECUTE_FLAGS = $(EXECUTE_FLAGS)"
	echo "### MAKE_FLAGS = $(MAKE_FLAGS)"


clean : 
	$(ECHO) "### Deleting all derived files ..."
	$(RM) $(PRODUCT)
	$(RM) $(ALL_OBJS)
	$(RM) *.dep
	$(ECHO) "### Deleted all derived files."


