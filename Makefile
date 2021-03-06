# basic
TARGET		= test
SOURCES		= main.cpp

# directories
SOURCE_DIR	= demo/
INCLUDE_DIR	= include/signal/
OBJECT_DIR	= objs/
DEPENDENCY_DIR	= dep/

# compiler & flags
COMPILER	= clang++
LINKER		= clang++

COMMON_FLAGS	= -O2 -std=c++11 -Wall -g -I$(INCLUDE_DIR)
COMPILE_FLAGS	= $(COMMON_FLAGS) -c
LINK_FLAGS	= $(COMMON_FLAGS) -g
DEP_FLAGS	= $(COMMON_FLAGS) -MM -MF $(DEPENDENCY_DIR)$$(addsuffix .d,$$(basename $$(subst /,-,$$<)))

# Don't change lines below
COMPILE_CMD	= $(COMPILER) $(COMPILE_FLAGS) -o $$@ $$<
LINK_CMD	= $(LINKER) $(LINK_FLAGS) -o $@ $^
DEP_CMD		= $(COMPILER) $(DEP_FLAGS) $$<

BASENAME	= $(basename $(SOURCES))
OBJECTS		= $(addsuffix .o, $(addprefix $(OBJECT_DIR),$(subst /,-,$(BASENAME))))

$(TARGET) 	: $(OBJECTS)
	$(LINK_CMD)

define COMPILE_MACRO
$(OBJECT_DIR)$(subst /,-,$(basename $(1)).o) 	: $(SOURCE_DIR)$(1)
	$(COMPILE_CMD)
	@$(DEP_CMD)
	@sed -e 's#\s*[a-zA-Z/]*\.o#$$@#g'\
		< $(DEPENDENCY_DIR)$$(addsuffix .d,$$(basename $$(subst /,-,$$<))) \
	   	> $(DEPENDENCY_DIR)$$(addsuffix .P,$$(basename $$(subst /,-,$$<)))
endef

$(foreach i,$(SOURCES),$(eval $(call COMPILE_MACRO,$(i))))

-include $(DEPENDENCY_DIR)*.P

.PHONY	: clean prepare

clean 	:
	rm -rf $(TARGET) $(OBJECTS) $(DEPENDENCY_DIR)*.d $(DEPENDENCY_DIR)*.P

prepare:
	mkdir -p $(SOURCE_DIR) $(INCLUDE_DIR) $(OBJECT_DIR) $(DEPENDENCY_DIR)

