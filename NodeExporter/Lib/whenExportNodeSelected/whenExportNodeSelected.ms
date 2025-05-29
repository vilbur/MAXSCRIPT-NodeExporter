global WHEN_ExportNodePlugin_SELECTED = #()

/** When attribute change https://help.autodesk.com/view/MAXDEV/2024/ENU/?guid=GUID-513285B3-DBF6-471E-B587-B5BE14D4D875
 * 
 *  whenExportNodeSelected( selection as Array )
 * 
 */
function whenExportNodeSelected objs =
(
	 --format "\n"; print "whenExportNodeSelected()"

	if classOf objs == Array then
		join WHEN_ExportNodePlugin_SELECTED objs

	else
		append WHEN_ExportNodePlugin_SELECTED objs

	deleteAllChangeHandlers id:#WHEN_ExportNodePlugin_SELECTED

	
	WHEN_ExportNodePlugin_SELECTED = makeUniqueArray WHEN_ExportNodePlugin_SELECTED
	
	WHEN_ExportNodePlugin_SELECTED = for ExportNodePlugin in WHEN_ExportNodePlugin_SELECTED where isValidNode ExportNodePlugin collect ExportNodePlugin

	--format "WHEN_ExportNodePlugin_SELECTED.count: %\n" WHEN_ExportNodePlugin_SELECTED.count
	
	when select WHEN_ExportNodePlugin_SELECTED changes id:#WHEN_ExportNodePlugin_SELECTED obj do
	(

		if obj.isSelected then
		(
			format "WHEN_ExportNodePlugin_SELECTED: %\n" obj
			
			NodeList = NodeList_v(DIALOG_nodeexporter.ML_nodes)
			
			/* GET SELECTED NODES IN SCENE */ 
			selected_nodes = NodeList.getSelectedNodesInScene()
			--format "selected_nodes: %\n" selected_nodes
			/* SELECT ITEMS IN LIST */ 
			NodeList.selectNodesInList(selected_nodes)
			
			DIALOG_nodeexporter.BP_export_path.text = NodeList.getExportPathText(selected_nodes)
	
			DIALOG_nodeexporter.ML_node_groups.items = sort (makeUniqueArray(for obj in shapes where classOf obj == ExportNodePlugin and obj.parent != undefined and isGroupHead obj.parent collect obj.parent.name))
		)
		else
			DIALOG_nodeexporter.BP_export_path.text = ""
	)
)


/** Start events
 */
function whenExportNodeSelectedStart =
(
	-- format "\n"; print whenExportNodeSelectedStart()"
	whenExportNodeSelected(WHEN_ExportNodePlugin_SELECTED)
)

/** Stop events
 */
function whenExportNodeSelectedStop =
(
	-- format "\n"; print whenExportNodeSelectedStop()"
	deleteAllChangeHandlers id:#WHEN_ExportNodePlugin_SELECTED
)