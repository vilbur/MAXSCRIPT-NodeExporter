
global CBX_FIX_POSITION_TRISTATE = 0

/**
  *
  */
macroscript	_export_fixed_position
category:	"_Export"
buttontext:	"Fix Position"
toolTip:	"For objects to keep position on export\n\n(Create boxes in corners of print plane to keep exported position)"
icon:	"control:checkbox|across:2|offset:[ 16, 0 ]"
(
	format "EventFired	= % \n" EventFired
	--format "EventFired.Control.triState	= % \n" EventFired.Control.triState
	----format "CBX_FIX_POSITION_TRISTATE	= % \n" CBX_FIX_POSITION_TRISTATE
	----(PrinterVolume_v()).createVolume(#box)(EXPORT_SIZE)
	--if EventFired.val == false and CBX_FIX_POSITION_TRISTATE != 2 then
	--	EventFired.Control.triState = CBX_FIX_POSITION_TRISTATE = 2
	--else
	--	CBX_FIX_POSITION_TRISTATE = 0

)

/**
  *
  */
macroscript	_export_turn_on_meshmooth
category:	"_Export"
buttontext:	"Meshsmooth"
toolTip:	"Auto turn on first Meshmooth modifier on exported object.\n\nMeshmooth is ONLY ENABLED, NOT ADDED."
icon:	"control:checkbox|across:2|offset:[ 0, 0 ]"
(
	format "EventFired	= % \n" EventFired
	--(PrinterVolume_v()).createVolume(#box)(EXPORT_SIZE)
)

/*==============================================================================
	ROW
================================================================================*/


/**
 */
macroscript	_export_settings_export_animation_keep_exported_objects
category:	"_Export"
buttontext:	"KEEP EXP"
toolTip:	"Keep exported exported obejcts"
icon:	"Control:checkbox|offset:[ 16, 0 ]"
(
	--format "EventFired: %\n" EventFired
	--format "Export size set to % \n" eventFired.val
	on execute do
		ROLLOUT_3d_print.CBX_unsmooth_vertex_color.enabled = eventFired.val

)

/**
 */
macroscript	_export_settings_export_animation_unsmooth_vertex_color
category:	"_Export"
buttontext:	"Unsmooth Vertex Color"
toolTip:	"DO NOT SMOOTH VERTEX COLORS"
icon:	"Control:checkbox|offset:[  0, 0]"
(
	format "EventFired: %\n" EventFired
	format "Export size set to % \n" eventFired.val
	
)

/*==============================================================================
	ROW
================================================================================*/

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



