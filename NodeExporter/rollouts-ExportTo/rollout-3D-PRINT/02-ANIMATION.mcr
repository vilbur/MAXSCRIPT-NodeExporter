
/**
 */
macroscript	_export_settings_export_animation
category:	"_Export"
buttontext:	"Animation"
toolTip:	"Export animation\n\nFROM: Current Key\n\nTO: End of animation range"
icon:	"Control:checkbox|id:CBX_export_animation|ACROSS:2|offset:[ 16, 0 ]"
(
	format "EventFired: %\n" EventFired
	format "Export size set to % \n" eventFired.val
	
	on execute do
	(
		
		ROLLOUT_3d_print.CBX_offset.enabled   = eventFired.val
		--ROLLOUT_3d_print.CBX_keep_exp.enabled = eventFired.val
		
	)
	
)

/*==============================================================================
	ROW
================================================================================*/

/**
 */
macroscript	_export_settings_export_animation_offset
category:	"_Export"
buttontext:	"OFFSET"
toolTip:	"Offset objects of each exported animation key\n\nMAKES ANIMATION STRIP FROM OBJECTS"
icon:	"Control:checkbox|offset:[ 0, 0]"
(
	format "EventFired: %\n" EventFired
	format "Export size set to % \n" eventFired.val
)

