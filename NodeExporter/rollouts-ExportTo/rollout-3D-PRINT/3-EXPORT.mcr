
/*==============================================================================

		EXCLUDE EDITTEXT

================================================================================*/

/**
  *
  */
macroscript	_export_export_exclude
category:	"_Export"
buttontext:	"Exclude"
icon:	"control:editText|across:1|offset:[ 0, 4 ]|value:support-source|toolTip:Do not export object, if it`s name match this text"
(
	format "EventFired	= % \n" EventFired
	--(PrinterVolume_v()).createVolume(#box)(EXPORT_SIZE)
)

/*==============================================================================

		BUTTONS

================================================================================*/

/** EXPORT BUTTON
  *
  */
macroscript	_export_print
category:	"_Export"
buttontext:	"Export"
toolTip:	"Export selected nodes to files"
icon:	"height:64|across:3|offset:[ 0, 6 ]"
(
	clearListener(); print("Cleared in:\n"+getSourceFileName())

	/* DEV */
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-nodeExporter\VilTools\rollouts-Tools\rollout-EXPORT\rollouts-ExportTo\rollout-3D-PRINT\Lib\PrintExporter\PrintExporter.ms"

	(ExporterSetup_v(#Print)).export()
	--(PrinterVolume_v()).fixPositionionObjects(EXPORT_SIZE)
)


/** PRINTER DUMMY
  *
  */
macroscript	_export_print_create_plane
category:	"_Export"
buttontext:	"Print Dummy"
toolTip:	"Create\Delete dummy palne of 3D printer plane"
icon:	"height:64|across:3|offset:[ 0, 6 ]"
(

	--format "EventFired	= % \n" EventFired
	clearListener(); print("Cleared in:\n"+getSourceFileName())
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-nodeExporter\VilTools\rollouts-Tools\rollout-EXPORT\rollouts-ExportTo\rollout-3D-PRINT\Lib\PrinterVolume\PrinterVolume.ms"

	(PrinterVolume_v(EXPORT_SIZE)).createVolume(#Rectangle)
)



/** PRINTER DUMMY RIGHTCLICK
  *
  */
macroscript	_export_print_create_volume
category:	"_Export"
buttontext:	"Print Dummy"
toolTip:	"Create\Delete dummy of 3D printer volume"
icon:	"across:3|offset:[ 0, 6 ]"
(
	--format "EventFired	= % \n" EventFired
	(PrinterVolume_v(EXPORT_SIZE)).createVolume(#box)
)

/*------------------------------------------------------------------------------
	OPEN FILE
--------------------------------------------------------------------------------*/

/**
  *
  */
macroscript	_export_print_open_exported_files
category:	"_Export"
buttontext:	"Open Files"
toolTip:	"Open exported files of selected nodes"
icon:	"height:64|across:3|offset:[ 0, 6 ]"
(
	--format "EventFired	= % \n" EventFired
	--(PrinterVolume_v()).createVolume(#Rectangle)(EXPORT_SIZE)

	selected_nodes = ((NodeList_v(DIALOG_nodeexporter.ML_nodes)).getSelectedNodesInList())

	PrintExporter = PrintExporter_v()

	PrintExporter.params[#OPEN_IN]	= DIALOG_nodeexporter.ExportTo.ROLLOUT_3d_print.RB_open_in_program.state
	PrintExporter.params[#SUBDIR_BY_NODE]	= DIALOG_nodeexporter.CBX_sub_directory_by_node_name.checked


	if selected_nodes.count > 0 then
	(
		export_paths	= for selected_node in selected_nodes collect PrintExporter.getExportFilePath (selected_node)
		format "export_paths	= % \n" export_paths
		PrintExporter.openInProgram(export_paths)
	)

)
