filein( getFilenamePath(getSourceFileName()) + "/Lib/whenExportNodeSelected/whenExportNodeSelected.ms" )	--"./Lib/whenExportNodeSelected/whenExportNodeSelected.ms"

filein( getFilenamePath(getSourceFileName()) + "/Lib/NodeList/NodeList.ms" )	-- "./Lib/NodeList/NodeList.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/ExportNode/ExportNode.ms" )	-- "./Lib/ExportNode/ExportNode.ms"


filein( getFilenamePath(getSourceFileName()) + "/Lib/ExporterSetup/ExporterSetup.ms" )	-- "./Lib/ExporterSetup/ExporterSetup.ms"

filein( getFilenamePath(getSourceFileName()) + "/Lib/LayersVisibility/LayersVisibility.ms" )	--"./Lib/LayersVisibility/LayersVisibility.ms"

/*==============================================================================

	NODES CONTROL

================================================================================*/
global NODE_GROUP_NAME_ROLLOUT

/**  CREATE EXPORT NODE


  TODO:
	Groups are attached into objects if their name IS NOT UPPERCASE

 */
macroscript	_ExportNodePlugin_create
category:	"_Export"
buttontext:	"Create"
toolTip:	"Create Export Node\n\nNode name is exported filename\n\nSelected objects will be linked to new node"
icon:	"across:3|width:64|height:48|pos:[ 184, 24 ]"
--icon:	"across:5|width:64|height:48"
(
	--format "eventFired.control	= % \n" eventFired.control
	--format "eventFired	= % \n" eventFired
	undo "Create Export Node" on
	(
		-- format "classOf ExportNodePlugin A: %\n" (classOf ExportNodePlugin)

		ExportNode 	= ExportNode_v()

		-- format "classOf ExportNodePlugin B: %\n" (classOf ExportNodePlugin)

		ExportNodePluginx = ExportNode.create()
		
		-- format "ExportNodePluginx: %\n" ExportNodePluginx
		--resizeNodeByChildren($ExportNodePlugin)
	)
)

/**  LINK TO NODE
 */
macroscript	_ExportNodePlugin_link_selection
category:	"_Export"
buttontext:	"Link"
toolTip:	"LINK TO NODE:\n(link selected obgjects to selcted node)"
icon:	"pos:[ 250, 24 ]"
(

	/** Get selection without members of closed group
	 */
	function getSelectionWithouGroupMembers =
	(
		mapped function getAllChildren node &children = (if isValidNode node and isKindOf children Array do join children node.children)

		children = #()

		groups_closed = for o in ( _selection = selection as Array ) where isGroupHead o and isOpenGroupHead o == false and findItem _selection o.parent == 0 collect o

		getAllChildren groups_closed &children

		for o in selection where findItem children o == 0 collect o --return
	)


	on execute do
		undo "Link to node" on
		(
			_nodes =  ((NodeList_v(DIALOG_nodeexporter.ML_nodes)).getSelectedNodesInList())

			if( _nodes.count > 0 ) then
			(
				_node = _nodes[1]
				
				objects_to_link = getSelectionWithouGroupMembers()

				for obj in objects_to_link do obj.parent = _node

				object_names = ""

				for obj in objects_to_link do object_names += "\n" + obj.name

				if objects_to_link.count < 200 then
					messageBox ("OBJECTS: "+object_names+"\n\nNODE:\n" + _node.name ) title:"LINK TO NODE"  beep:false
				else
					messageBox ( objects_to_link.count as string + " OBJECTS HAS BEEN LINKED TO NODE:\n" + _nodes[1].name ) title:"LINK TO NODE"  beep:false
					
				_node.resizeNodeByChildren()
			)
		)
)

/**  LOAD
 */
macroscript	_ExportNodePlugin_load
category:	"_Export"
buttontext:	"Refresh"
toolTip:	"Refresh nodes in list"
icon:	"pos:[ 316, 24 ]"

(
	--format "eventFired	= % \n" eventFired
	(NodeList_v()).refreshNodeList()


)


/**  GROUP NODES
 */
macroscript	_export_group_nodes
category:	"_Export"
buttontext:	"Group"
toolTip:	"Group selected nodes"
icon:	"pos:[ 184, 72]"
(
	function arrayToString arr delimeter = ( _string = ""; for item in arr do _string += item as string  + delimeter; substring _string 1 (_string.count-delimeter.count))
	
	_nodes =  (NodeList_v(DIALOG_nodeexporter.ML_nodes)).getSelectedNodesInList()

	_node_names = for _node in _nodes collect _node.name
	
	group_name = ""
	
	group_name = if( _nodes.count > 0 ) then
		arrayToString _node_names "_"
	else
		_nodes[1].name
	--isGroupHead

	/** Ask name dialog
	 */
	function _createGroupDialog =
	(
		try(destroyDialog NODE_GROUP_NAME_ROLLOUT) catch()

		rollout NODE_GROUP_NAME_ROLLOUT "Set export node name"
		(
			dotNetControl TextBox "TextBox"

			on NODE_GROUP_NAME_ROLLOUT open do
			(
				TextBox.Text	= toUpper group_name
				TextBox.BackColor	= ( dotNetClass "System.Drawing.Color").FromArgb 180 180 180
			)

			on TextBox KeyUp s e do
			(
				if e.KeyCode == e.KeyCode.Enter then
				(
					-- format "GROUP NAME	= % \n" TextBox.Text
					_group = group _nodes name:TextBox.Text select:true

					_nodes[1].layer.addnode _group

					destroyDialog NODE_GROUP_NAME_ROLLOUT
					
					macros.run "_Export" "_ExportNodePlugin_load"
				)
				else if e.KeyCode == e.KeyCode.Escape then
					destroyDialog NODE_GROUP_NAME_ROLLOUT
			)
		)

		CreateDialog NODE_GROUP_NAME_ROLLOUT width:256 height:40

		setFocus NODE_GROUP_NAME_ROLLOUT.TextBox
	)

	-- format "_nodes.count: %\n" _nodes.count
	if _nodes.count > 0 then
		_createGroupDialog()
)

/**  Unify
 */
macroscript	_ExportNodePlugin_unify
category:	"_Export"
buttontext:	"Unify"
toolTip:	"Set size and path of selected export nodes\n\n1st selected node is source object"
icon:	"pos:[ 250, 72]"
(
	_nodes = ((NodeList_v(DIALOG_nodeexporter.ML_nodes)).getSelectedNodesInList())

	if( _nodes.count >= 2 and queryBox "Set size and export path to selected nodes by first selected node ?" title:"Unify node settings" ) then	--ExportNode 	= ExportNode_v()
	(

		master_node = _nodes[1]
		other_nodes = deleteItem _nodes 1
		--format "master_node	= % \n" master_node
		--format "other_nodes	= % \n" other_nodes
		for _node in other_nodes do
		(
			_node.size	= master_node.size
			_node.export_dir	= master_node.export_dir

		)

	)
)





/*==============================================================================

		EXPORT NODE LIST

================================================================================*/



/**  NODE LIST
 */
macroscript	_ExportNodePlugins_list
category:	"_Export"
buttontext:	"Nodes"
toolTip:	"Nodes to export"
icon:	"control:multilistbox|across:2|event:#selectionEnd|height:19|width:160|offset:[ 0, -120]"
--icon:	"control:multilistbox|across:2|height:20|width:160|offset:[ 0, -96]"
--icon:	"control:multilistbox|across:2"
--icon:	"control:multilistbox|across:2|items:#('1','2')" -- DEV
(
	----clearListener(); print("Cleared in:\n"+getSourceFileName())
	--filein @"c:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-nodeExporter\VilTools\rollouts-Tools\rollout-EXPORT\1-[Export-Nodes].mcr"
	--print "SELECTED"
	--format "eventFired	= % \n" eventFired

	whenExportNodeSelectedStop()

	clearSelection()
	
	NodeList = NodeList_v(DIALOG_nodeexporter.ML_nodes)
	
	selected_nodes = NodeList.getSelectedNodesInList()

	-- format "\n-----------\nARRAY:selected_nodes:\n";  for selected_node in selected_nodes do format "selected_node:	%\n" selected_node.name

	/* OPEN PARENT GROUPS OF SELECTEDS NODES */
	for selected_node in selected_nodes where selected_node.parent != undefined and isGroupHead selected_node.parent do setGroupOpen selected_node.parent true
	
	DIALOG_nodeexporter.BP_export_path.text = NodeList.getExportPathText(selected_nodes)

	select selected_nodes

	whenExportNodeSelectedStart()

	
	/*------------------------------------------------------------------------------
		DEPRECATED FOR UNREAL

	--/** Fillpaths
	-- */
	--function fillpaths _control prop_name =
	--(
	--	--format "\n"; print ".fillpaths()"
	--	paths = for _node in selected_nodes where ( export_dir = getUserProp _node prop_name) != undefined collect export_dir
	--	--format "paths[1]	= % \n" paths[1]
	--	if( paths[1] != undefined ) then
	--		_control.text = paths[1]
	--
	--	else	if( ( export_dir = _control.text ) != "" ) then
	--		for _node in selected_nodes do setUserProp _node prop_name  export_dir
	--)
	--
	--fillpaths EventFired.Roll.export_Dir	"export-dir"
	--fillpaths EventFired.Roll.materials_Dir	"materials-dir"
	--
	--macros.run "_Export" "_load_materials"
	--
	--select selected_nodes

	--------------------------------------------------------------------------------*/
)


/*
	NODELIST DOUBLE CLICK

*/
macroscript	_export_isolate_node_objects
category:	"_Export"
buttontext:	"Nodes"
toolTip:	"Isolate node children\n\nCtrl+LMB: Select node children."
icon:	"control:multilistbox|across:2|event:#doubleClicked"
(
	clearListener(); print("Cleared in:\n"+getSourceFileName())
	-- format "EventFired	= % \n" EventFired
	
	function isSelectionLocked =
	(
		currentSel = getCurrentSelection()

		deselect selection

		newSel = getCurrentSelection()
		locked = currentSel as string == newSel as string -- Compare if selection changed
		
		if not locked then -- If it wasn't locked, reselect what was originally selected
			select currentSel

		locked --return 
	)
	
	--filein @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-NodeExporter\NodeExporter\1-[Export-Nodes-Lists].mcr"
	--filein( getFilenamePath(getSourceFileName()) + "/Lib/LayersVisibility/LayersVisibility.ms" )	--"./Lib/LayersVisibility/LayersVisibility.ms"

	LayersVisibility 	= LayersVisibility_v()
	
	/* CLOSE LAYER MANAGER BEFORE SELECTION */
	--if LayerManager.isDialogOpen() then
		--is_manager_open = LayerManager.closeDialog()

	all_children	= #()
	default_Layer	= LayerManager.getLayerFromName "0"

	/* DISABLE CALLBACK */
	whenExportNodeSelectedStop()

	if (is_selection_locked = isSelectionLocked())then
		actionMan.executeAction 0 "59231"  -- Selection: Selection Lock Toggle
	
	
	selected_nodes = for obj in selection where classOf obj == ExportNodePlugin collect obj
	-- format "selected_nodes.count: %\n" selected_nodes.count
	-- format "selected_nodes: %\n" selected_nodes
	/* OPEN PARENT GROUPS OF SELECTEDS NODES */
	for selected_node in selected_nodes where selected_node.parent != undefined and isGroupHead selected_node.parent do setGroupOpen selected_node.parent true

	/* GET ALL CHILDREN OF NODES */
	for selected_node in selected_nodes do all_children += (selected_node.getAllChildren())
	--format "\n-----------\nARRAY:selected_nodes:\n";  for selected_node in selected_nodes do format "selected_node:	%\n" selected_node.name


	nodes_and_children = makeUniqueArray (all_children + selected_nodes )
	
	if ( printer_volume = $'PRINT DUMMY VOLUME' ) != undefined then 
		append nodes_and_children printer_volume
	
	
	IsolateSelection.ExitIsolateSelectionMode()
	
	LayersVisibility.showOnly nodes_and_children ISOLATE:true
	
	--select all_children
	clearSelection()

	max tool zoomextents all

	
	select selected_nodes
	
	
	/* REOPEN LAYER MANAGER */
	--if is_manager_open != undefined then
		--LayerManager.editLayerByName ""
		
	/* ENABLE CALLBACK */
	whenExportNodeSelectedStart()

)


/*==============================================================================

		EXPORT GROUP LIST

================================================================================*/




/**  SELECT GROUPS OF NODES
 */
macroscript	_ExportNodePlugins_groups_list_select
category:	"_Export"
buttontext:	"Node Groups"
toolTip:	"Nodes to export"
icon:	"control:multilistbox|across:2|event:#selectionEnd|height:9|width:160|offset:[ 0, 8 ]"
--icon:	"control:multilistbox|across:2|items:#('1','2')" -- DEV
(
	--clearListener(); print("Cleared in:\n"+getSourceFileName())
	-- format "eventFired	= % \n" eventFired
	--format "eventFired.Control.items	= % \n" eventFired.Control.items
	--format "eventFired.Control.selection	= % \n" (eventFired.Control.selection as array )

	selected_groups = #()
	grouped_nodes = #()

	all_groups = makeUniqueArray( for obj in shapes where classOf obj == ExportNodePlugin and obj.parent != undefined and isGroupHead obj.parent collect  obj.parent)
	group_names_in_selection = for index in eventFired.Control.selection as Array collect eventFired.Control.items[index]

	selected_groups = for _group in all_groups where findItem group_names_in_selection _group.name > 0 collect _group

	for selected_group in selected_groups do 
		for export_node in selected_group.children \
			where classOf export_node == ExportNodePlugin do
				append grouped_nodes export_node
				
	--format "grouped_nodes: %\n" grouped_nodes
	
	if grouped_nodes.count > 0 then
		select grouped_nodes
	else
		select selected_groups
)


/**  	GROUP LIST DOUBLE CLICK

 */
macroscript	_ExportNodePlugins_groups_list_isolate
category:	"_Export"
buttontext:	"Node Groups"
toolTip:	"Nodes to export"
icon:	"control:multilistbox|event:#doubleClicked"
(
	selected_groups = #()

	
	
	all_groups = makeUniqueArray( for obj in shapes where classOf obj == ExportNodePlugin and obj.parent != undefined and isGroupHead obj.parent collect obj.parent)
	
	group_names_in_selection = for index in eventFired.Control.selection as Array collect eventFired.Control.items[index]
	
	for _group in all_groups where findItem group_names_in_selection _group.name > 0 do
	(
		selectmore _group
	
		selectmore _group.children
	
		append selected_groups _group
	)

	macros.run "_Export" "_export_isolate_node_objects"

	--select selected_groups
)




--
--/**
-- */
--macroscript	_export_preexport
--category:	"_Export"
--buttontext:	"Pre Export"
--toolTip:	"Save Eported nodes as separated max files in export folder"
----icon:	"Groupbox:Nodes Control"
--(
--	clearListener()
--
--	selected_nodes =  ((NodeList_v(DIALOG_nodeexporter.ML_nodes)).getSelectedNodesInList())
--
--	format "selected_nodes	= % \n" selected_nodes
--
--	if( selected_nodes.count > 0 ) then
--		with redraw off
--			(ExporterDatasmith_v ExportNodePlugins:selected_nodes).export pre_export:true
--	else
--		messageBox "Export node is not selected" title:"Export node error"
--
--
--	redrawViews()
--)
--



--/*------------------------------------------------------------------------------
--	PRE-EXPORT TEST
----------------------------------------------------------------------------------*/
--
--
--/**
-- */
--macroscript	_export_test
--category:	"_Export"
--buttontext:	"Test"
--toolTip:	"Export selected nodes to files"
--icon:	"height:64"
--(
--	--export_dir = execute ("@"+ "\""+EventFired.Roll.BROWSEPATH_Export_Dir.text +"\"")
--	clearListener()
--
--	filein( @"c:\scripts\nodeExporter\Rollouts\rollouts-Unreal-Engine\rollout-UNREAL\Lib\ExporterDatasmith\ExportChecker\ExportChecker.ms" ) -- DEV
--
--	selected_nodes =  ((NodeList_v(DIALOG_nodeexporter.ML_nodes)).getSelectedNodesInList())
--
--	format "selected_nodes	= % \n" selected_nodes
--
--	if( selected_nodes.count > 0 ) then
--		(ExportChecker_v ExportNodePlugins:selected_nodes).test()
--	else
--		messageBox "Export node is not selected" title:"Export node error"
--
--)
