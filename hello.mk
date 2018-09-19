TARGET:= hello
_INSTDIR_ := $(_INSTALL_PREFIX_)/dummy

all: $(_OBJDIR_)/$(TARGET)

$(_OBJDIR_)/$(TARGET):
	#sleep 2
	#false
	touch $@

clean:
	#false
	rm -f $(_OBJDIR_)/$(TARGET)

install: $(_INSTDIR_) $(_INSTDIR_)/$(TARGET)


$(_INSTDIR_):
	install -d $@

$(_INSTDIR_)/$(TARGET): $(_OBJDIR_)/$(TARGET)
	install $(_OBJDIR_)/$(TARGET) $@

