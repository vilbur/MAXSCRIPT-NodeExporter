
/**
 */
macroscript	_export_settings_export_animation_keep_exported_objects
category:	"_Export"
buttontext:	"KEEP EXPORTED"
toolTip:	"Keep exported exported obejcts"
icon:	"Control:checkbox|offset:[ 16, 0 ]|ACROSS:2"
(
	--format "Export size set to % \n" EventFired.val
	on execute do
	(
		--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-NodeExporter\NodeExporter\rollouts-ExportTo\rollout-3D-PRINT\03-KEEP EXPORTED OBJECTS.mcr"
		format "EventFired: %\n" EventFired
		
		state_ctrl = if EventFired != undefined then EventFired.val else ROLLOUT_3d_print.CBX_keep_exported.state
		
		this_rollout_ctrls = #( #CBX_layer_by_obj, #CBX_unsmooth_vertex_color, #CBX_inner_black, #ET_exported_suffix )
		
		for ctrl in ROLLOUT_3d_print.controls where ctrl.name  != undefined and  findItem this_rollout_ctrls ( ctrl.name as name ) > 0 do
			ctrl.enabled = state_ctrl
		
	)
)
/**
 */
macroscript	_export_settings_export_keep_exported_custom_layer
category:	"_Export"
buttontext:	"Layer by obj"
toolTip:	"Keep exported exported obejcts"
icon:	"Control:checkbox|offset:[ 16, 0 ]"
(
	format "EventFired: %\n" EventFired
	--format "Export size set to % \n" EventFired.val
	--on execute do
		--ROLLOUT_3d_print.CBX_unsmooth_vertex_color.enabled = EventFired.val

)

/**
 */
macroscript	_export_settings_export_unsmooth_vertex_color
category:	"_Export"
buttontext:	"Unsmooth Vertex Color"
toolTip:	"DO NOT SMOOTH VERTEX COLORS"
icon:	"Control:checkbox|offset:[ 16, 0]"
(
	format "EventFired: %\n" EventFired
	format "Export size set to % \n" EventFired.val
	
)

/**
 */
macroscript	_export_settings_export_inner_verts_to_black
category:	"_Export"
buttontext:	"Inner Black"
toolTip:	"Set vertex color of inner verts as black"
icon:	"Control:checkbox|offset:[ 16, 0]"
(
	format "EventFired: %\n" EventFired
)




/** SUFFIX
  */
macroscript	_export_settings_export_keep_exported_objects_suffix
category:	"_Export"
buttontext:	"Suffix"
icon:	"control:editText|id:ET_exported_suffix|across:1|offset:[ 0, 6 ]|value:supports-source"
(
	format "EventFired	= % \n" EventFired
	--(PrinterVolume_v()).createVolume(#box)(EXPORT_SIZE)
)

