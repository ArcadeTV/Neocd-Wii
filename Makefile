#---------------------------------------------------------------------------------
# Clear the implicit built in rules
#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------
ifeq ($(strip $(DEVKITPPC)),)
$(error "Please set DEVKITPPC in your environment. export DEVKITPPC=<path to>devkitPPC)
endif

include $(DEVKITPPC)/wii_rules

#---------------------------------------------------------------------------------
# TARGET is the name of the output
# BUILD is the directory where object files & intermediate files will be placed
# SOURCES is a list of directories containing source code
# INCLUDES is a list of directories containing extra header files
#---------------------------------------------------------------------------------
TARGET		:=	redux_wii
BUILD		:=	build_wii
SOURCES		:=	src/fileio src src/cdaudio src/cdrom src/z80i \
			src/memory src/pd4990a src/cpu src/input src/video \
			src/mcard src/sound src/tffs src/utils

INCLUDES	:=	src/z80 src/m68000 src/cpu src/fileio src \
			src/bin src/cdaudio src/cdrom src/memory src/z80i \
			src/video src/pd4990a src/input src/mcard \
			src/sound src/tffs

#---------------------------------------------------------------------------------
# options for code generation
#---------------------------------------------------------------------------------

CFLAGS	= -O3 -fomit-frame-pointer -mrvl -Wall -Wno-strict-aliasing $(MACHDEP) $(INCLUDE) -DUSESD
CXXFLAGS	=	$(CFLAGS)

LDFLAGS	=	$(MACHDEP) -Wl,-Map,$(notdir $@).map

#---------------------------------------------------------------------------------
# any extra libraries we wish to link with the project
#---------------------------------------------------------------------------------
LIBS	:=	-ldi -lfat -lwiiuse -lbte -logc -lm -lz -lmad -L. -lz80 -lmc68000 -lmxml

#---------------------------------------------------------------------------------
# list of directories containing libraries, this must be the top level containing
# include and lib
#---------------------------------------------------------------------------------
LIBDIRS	:=

#---------------------------------------------------------------------------------
# no real need to edit anything past this point unless you need to add additional
# rules for different file extensions
#---------------------------------------------------------------------------------
ifneq ($(BUILD),$(notdir $(CURDIR)))
#---------------------------------------------------------------------------------

export OUTPUT	:=	$(CURDIR)/$(TARGET)

export VPATH	:=	$(foreach dir,$(SOURCES),$(CURDIR)/$(dir)) \
			$(foreach dir,$(DATA),$(CURDIR)/$(dir))

export DEPSDIR	:=	$(CURDIR)/$(BUILD)

#---------------------------------------------------------------------------------
# automatically build a list of object files for our project
#---------------------------------------------------------------------------------
CFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.c)))
CPPFILES	:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.cpp)))
sFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.s)))
SFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.S)))
BINFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.*)))
PNGFILES	:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.png)))
PCMFILES	:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.pcm)))
OGGFILES	:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.ogg)))

#---------------------------------------------------------------------------------
# use CXX for linking C++ projects, CC for standard C
#---------------------------------------------------------------------------------
ifeq ($(strip $(CPPFILES)),)
	export LD	:=	$(CC)
else
	export LD	:=	$(CXX)
endif

export OFILES	:=	$(addsuffix .o,$(BINFILES)) \
			$(PNGFILES:.png=.png.o) $(PCMFILES:.pcm=.pcm.o) $(OGGFILES:.ogg=.ogg.o) \
			$(CPPFILES:.cpp=.o) $(CFILES:.c=.o) \
			$(sFILES:.s=.o) $(SFILES:.S=.o) $(CURDIR)/src/utils/ehcmodule.elf.o 

#---------------------------------------------------------------------------------
# build a list of include paths
#---------------------------------------------------------------------------------
export INCLUDE	:=	$(foreach dir,$(INCLUDES),-I$(CURDIR)/$(dir)) \
			$(foreach dir,$(LIBDIRS),-I$(dir)/include) \
			-I$(CURDIR)/$(BUILD) \
			-I$(LIBOGC_INC)

#---------------------------------------------------------------------------------
# build a list of library paths
#---------------------------------------------------------------------------------
export LIBPATHS	:=	$(foreach dir,$(LIBDIRS),-L$(dir)/lib) \
					-L$(LIBOGC_LIB)

export OUTPUT	:=	$(CURDIR)/$(TARGET)
.PHONY: $(BUILD) clean

#---------------------------------------------------------------------------------
$(BUILD):
	@[ -d $@ ] || mkdir $@
	@cd src/m68000 && $(MAKE)
	@cp src/m68000/libmc68000.a $(BUILD)
	@cd src/z80 && $(MAKE)
	@cp src/z80/libz80.a $(BUILD)
	@echo ""
	@echo "*** NeoCD Redux 0.1.52A ****************************************************"
	@make --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile
	
	@cp $(OUTPUT).dol boot.dol
	@echo "*************************************************************** Yay! \o/ ***"

#---------------------------------------------------------------------------------
clean:
	@echo clean ...
	@rm -fr $(BUILD) $(OUTPUT).elf $(OUTPUT).dol
	@cd src/m68000 && $(MAKE) clean
	@cd src/z80 && $(MAKE) clean


#---------------------------------------------------------------------------------
else

DEPENDS	:=	$(OFILES:.o=.d)

#---------------------------------------------------------------------------------
# main targets
#---------------------------------------------------------------------------------
$(OUTPUT).dol: $(OUTPUT).elf
$(OUTPUT).elf: $(OFILES)

#---------------------------------------------------------------------------------
# This rule links in binary data with the various extension
#---------------------------------------------------------------------------------
%.jpg.o	:	%.jpg
	@echo $(notdir $<)
	$(bin2o)

%.png.o	:	%.png
	@echo $(notdir $<)
	$(bin2o)

%.pcm.o	:	%.pcm
	@echo $(notdir $<)
	$(bin2o)

%.ogg.o	:	%.ogg
	@echo $(notdir $<)
	$(bin2o)

-include $(DEPENDS)

#---------------------------------------------------------------------------------
endif
#---------------------------------------------------------------------------------
