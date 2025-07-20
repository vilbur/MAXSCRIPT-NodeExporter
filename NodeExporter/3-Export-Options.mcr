/** SET EXPORT_SIZE
  
	GLOBAL VARIABLE EXPORT_SIZE IS SHARED WITH MaxSlicer: https://github.com/vilbur/MAXSCRIPT-MaxSlicer
  
  
  
 */
macroscript	_export_settings_set_size
category:	"_Export"
buttontext:	"Export Size"
toolTip:	"Export size"
icon:	"Control:spinner|range:[0,100,1]|offset:[16,0]|across:1|align:#left|width:96"
(
	format "\n!!!!!!!!!!!!!!!!!!! SET EXPORT SIZE\n"
	format "eventFired	= % \n" eventFired
	format "EXPORT_SIZE: %\n" EXPORT_SIZE
	
	this_control = DIALOG_nodeexporter.SPIN_export_size.value
	
	/* FIRED BY MAXSCRIPT ON STARTUP */ 
	if eventFired == undefined then
	(
		if EXPORT_SIZE == undefined then 
			EXPORT_SIZE = DIALOG_nodeexporter.SPIN_export_size.value
		else
			DIALOG_nodeexporter.SPIN_export_size.value = EXPORT_SIZE
	)
	/* FIRED BY CONTROL EVENT  */ 
	else
		EXPORT_SIZE = eventFired.val

	/* SYNC WITH MaxSlicer */ 
	if DIALOG_maxslicer != undefined then 
		DIALOG_maxslicer.SPIN_export_size.value = DIALOG_nodeexporter.SPIN_export_size.value

)

/**
 */
macroscript	_export_settings_export_animation
category:	"_Export"
buttontext:	"EXPORT ANIMATION"
toolTip:	"Export animation\n\nFROM: Current Key\n\nTO: End of animation range"
icon:	"Control:checkbox|ACROSS:3"
(
	format "EventFired: %\n" EventFired
	format "Export size set to % \n" eventFired.val
	
	on execute do
	(
		
		DIALOG_nodeexporter.CBX_offset.enabled   = eventFired.val
		----DIALOG_nodeexporter.CBX_keep_exp.enabled = eventFired.val
		
	)
	
)

/**
 */
macroscript	_export_settings_export_animation_offset
category:	"_Export"
buttontext:	"OFFSET"
toolTip:	"Offset objects of each exported animation key\n\nMAKES ANIMATION STRIP FROM OBJECTS"
icon:	"Control:checkbox|offset:[ 16, 0]"
(
	format "EventFired: %\n" EventFired
	format "Export size set to % \n" eventFired.val
)

/**
 */
macroscript	_export_settings_export_animation_keep_exported_objects
category:	"_Export"
buttontext:	"KEEP EXP"
toolTip:	"Keep exported exported obejcts"
icon:	"Control:checkbox|offset:[ -16, 0]"
(
	format "EventFired: %\n" EventFired
	format "Export size set to % \n" eventFired.val
)
