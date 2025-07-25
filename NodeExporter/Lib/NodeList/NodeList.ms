filein( getFilenamePath(getSourceFileName()) + "/Callback/refreshNodelistOnFileOpen.ms" )	--"./Callback/refreshNodelistOnFileOpen.ms"
/** Methods for Lsitbox DIALOG_nodeexporter.ML_nodes
		
 */
struct NodeList_v
(
	/* construct */
	nodelist_control,

	/* properties  */
	user_prop = "unreal-engine-export-node",

	/** Refresh node list
	 */
	function refreshNodeList =
	(
		--format "\n"; print "NodeList_v.refreshNodeList()"
		all_nodes_in_scene = this.loadNodes()
	
		this.getGroupsOfExportNodes(all_nodes_in_scene)
		
		whenExportNodeSelected(all_nodes_in_scene)
	),
	
	/** Load nodes
	 */
	function loadNodes =
	(
		--print "NodeList_v.loadNodes()"
		--format "this.getAllNodesInScene()	= % \n" (this.getAllNodesInScene())
		--format "this._getNodeNames (this.getAllNodesInScene())	= % \n" (this._getNodeNames (this.getAllNodesInScene()))
		all_nodes_in_scene = this.getAllNodesInScene()
		
		nodelist_control.items = sort(this._getNodeNames (all_nodes_in_scene))
		
		all_nodes_in_scene --return
	),


	/** Select nodes in list
	 */
	function selectNodesInList nodes_to_select =
	(
		--format "\n"; print "NodeList_v.selectNodesInList()"

		nodes_to_select = this._getNodeNames(nodes_to_select)

		selected_indexes = for node_name in nodelist_control.items where findItem nodes_to_select node_name > 0 collect findItem nodelist_control.items node_name

		nodelist_control.selection = selected_indexes
	),

	/** Get selected items
	 */
	function getSelectedNodesInList =
	(
		this._getNodesByName(this.getSelectedNodeNamesInList()) -- return
	),

	/** Get selected items
	 */
	function getSelectedNodeNamesInList =
	(
		selected_index = nodelist_control.selection as Array

		--node_names	= nodelist_control.items

		for index in selected_index collect nodelist_control.items[index] -- return
	),

	/** Filter nodes from selection
	 */
	function getSelectedNodesInScene =
	(
		--print "NodeList_v.getSelectedNodesInScene()"
		--nodes_selected_in_scene = this._getNodesInScene()
		for obj in selection where classOf obj == ExportNodePlugin collect obj
	),

	/** Get all nodes in scene
	 */
	function getAllNodesInScene =
	(
		for obj in shapes where classOf obj == ExportNodePlugin collect obj
	),


	/** Get groups of export nodes
	 */
	function getGroupsOfExportNodes ExportNodePlugins =
	(
		--format "\n"; print "NodeList_v.getGroupsOfExportNodes()"
		groups_in_scene = makeUniqueArray( for obj in ExportNodePlugins where classOf obj == ExportNodePlugin and obj.parent != undefined and isGroupHead obj.parent collect obj.parent )
		
		group_names = for group_in_scene in groups_in_scene collect group_in_scene.name
		
		DIALOG_nodeexporter.ML_Node_Groups.items = group_names
	),

	/** Get export path text
	  * 
	  * @return string text for browse path control
	 */
	function getExportPathText ExportNodePlugins =
	(
		--format "\n"; print "NodeList_v.getExportPathText()"
		export_dirs = for ExportNodePlugin in ExportNodePlugins  collect ExportNodePlugin.export_dir

		case (export_dirs_unique = (makeUniqueArray export_dirs)).count of
			(
				0: ""
				1: export_dirs_unique[1]
				default: "Multiple export paths"
			)
	),

	/** _get node names
	 */
	function _getNodeNames nodes =
	(
		for _node in nodes collect _node.name --return
	),



	/** Select child nodes
	 */
	function getAllChildren ExportNodePlugins =
	(
		--format "\n"; print "NodeList_v.selectChildNodes()"

		all_children	= #()

		for ExportNodePlugin in ExportNodePlugins do
			all_children += this._getAllChildren(ExportNodePlugin)

		all_children --return
	),


	private

	/** Get nodes by name from scene
	 */
	function _getNodesByName node_names =
	(
		--format "\n"; print "NodeList_v.getNodesByName()"

		for obj in shapes where classOf obj == ExportNodePlugin and findItem node_names obj.name collect obj
	),

	/**  Get all nested children
	  */
	function _getAllChildren obj &arr:#() =
	(
		for child in obj.children do
		(
			append arr child

			this._getAllChildren child arr:arr
		)
		arr
	),



	on create do
	(
		--print "NodeList_v.onCreate()"
		--format "nodelist_control	= % \n" nodelist_control
		if nodelist_control == undefined then 
			this.nodelist_control = DIALOG_nodeexporter.ML_nodes
	)
)