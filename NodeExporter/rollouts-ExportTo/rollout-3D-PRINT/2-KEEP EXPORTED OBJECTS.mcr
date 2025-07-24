
/**
 */
macroscript	_export_settings_export_animation_keep_exported_objects
category:	"_Export"
buttontext:	"KEEP EXPORTED"
toolTip:	"Keep exported exported obejcts"
icon:	"Control:checkbox|offset:[ 16, 0 ]|ACROSS:2"
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

/**
 */
macroscript	_export_settings_export_animation_keep_exported_custom_layer
category:	"_Export"
buttontext:	"Layer by obj"
toolTip:	"Keep exported exported obejcts"
icon:	"Control:checkbox|offset:[ 16, 0 ]"
(
	format "EventFired: %\n" EventFired
	--format "Export size set to % \n" eventFired.val
	--on execute do
		--ROLLOUT_3d_print.CBX_unsmooth_vertex_color.enabled = eventFired.val

)

/**
  *
  */
macroscript	_export_settings_export_animation_keep_exported_objects_suffix
category:	"_Export"
buttontext:	"Suffix"
icon:	"control:editText|id:ET_exported_suffix|across:1|offset:[ 0, 4 ]|value:supports-source"
(
	format "EventFired	= % \n" EventFired
	--(PrinterVolume_v()).createVolume(#box)(EXPORT_SIZE)
)

