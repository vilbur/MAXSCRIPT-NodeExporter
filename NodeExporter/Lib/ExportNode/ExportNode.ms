global NODE_NAME_ROLLOUT


/** export node
 */
struct ExportNode_v
(
	_node,
	--_scene_name	= if( maxFileName != "" ) then ( ( dotNetObject "System.Text.RegularExpressions.Regex" @"[_-]\d+$" ).Replace ( getFilenameFile maxFileName ) "" ) else "UnrealExport",
	--_name	= _scene_name,
	_name,
	_selection,

	layer_name = " ----- EXPORT NODES -----",
	
	/** Create export node with dialog
	 */
	function create =
	(
		print "ExportNode_v.create()"
		global ThisExportNode = this

		this._selection = this._getSelection()
		
		select this._selection
		--format "this._selection	= % \n" this._selection
		this._createNodeDialog()
	),

	/** _add to default layer
	 */
	function _addToLayer =
	(
		/* GET LAYER */ 
		layer = LayerManager.getLayerFromName layer_name

		/* CREATE LAYER */ 
		if layer == undefined then
			layer = LayerManager.newLayerFromName layer_name

		/* ADD NODE */ 
		layer.addnode _node

		/* SET PROPERTIES */ 
		layer.on = true
	),


	/** Ask name dialog
	 */
	function _createNodeDialog =
	(
		try(destroyDialog NODE_NAME_ROLLOUT) catch()

		rollout NODE_NAME_ROLLOUT "Set export node name"
		(
			dotNetControl TextBox "TextBox"

			on NODE_NAME_ROLLOUT open do
			(
				TextBox.Text	= this._getNewNodeName()
				TextBox.BackColor	= ( dotNetClass "System.Drawing.Color").FromArgb 180 180 180
			)

			on TextBox KeyUp s e do
			(
				if e.KeyCode == e.KeyCode.Enter then
				(
					/*------------------------------------------------------------------------------
						CREATE EXPORT NODE
					--------------------------------------------------------------------------------*/
					if ( ExportNodePlugin = ThisExportNode._createNodeObject(TextBox.Text) ) != undefined then
						ExportNodePlugin --return
				)
				else if e.KeyCode == e.KeyCode.Escape then
					destroyDialog NODE_NAME_ROLLOUT
			)
		)

		CreateDialog NODE_NAME_ROLLOUT width:256 height:40

		setFocus NODE_NAME_ROLLOUT.TextBox
	),

	/** Create export node in scene
	 */
	function _createNodeObject _name =
	(
		 format "\n"; print "ExportNode_v._createNodeObject()"
		this._name = _name
			-- format "classOf ExportNode: %\n" (classOf ExportNode)

		format "NODE_EXISTS	= % \n" (this._getNodeByName(_name))
		if( this._getNodeByName(_name) == undefined ) then
		(
			/*------------------------------------------------------------------------------
				CREATE NODE
			--------------------------------------------------------------------------------*/
			this._node = ExportNodePlugin name:_name text:_name export_dir:(this._getExportDir()) size:(this._getNodeSize()) isSelected:on pos:(this._getNewNodePosition())

			this._addToLayer()

			this._linkSelectedObejctsToNode()

			try(destroyDialog NODE_NAME_ROLLOUT) catch()

			ThisExportNode = undefined

			this._node --return
		)
		else
			this._exception() --return
	),

	/** Link selected obejcts to node
	  *
	  * Only objects without parent are linked, hierarchy will be kept
	 */
	function _linkSelectedObejctsToNode =
	(
		-- format "\n"; print "ExportNode_v._linkSelectedObejctsToNode()"

		for obj in this._selection do
			obj.parent = this._node
	),

	/** Throw Eexception
	 */
	function _exception =
	(
		NODE_NAME_ROLLOUT.Title = "! THIS NAME EXISTS ALREADY !"

		setFocus NODE_NAME_ROLLOUT.TextBox

		undefined --return
	),

	/** Get nodes in scene
	 */
	function _getNodesInScene =
	(
		--format "\n"; print "ExportNode_v._getNodesInScene()"
		for obj in shapes where classOf obj == ExportNodePlugin collect obj
	),

	/** Get nodes in scene
	 */
	function _getNodeByName node_name =
	(
		--format "\n"; print "ExportNode_v._getNodesInScene()"
		for obj in shapes where classOf obj == ExportNodePlugin and isValidNode obj  and obj.name == node_name do return obj

		undefined --return
	),

	/** Get export dir path
	  *
	  * @return string
	  * 		1) from other nodes in scene
	  * 		2) Max file path with "\Export" subdir
	 */
	function _getExportDir =
	(
		--format "\n"; print "ExportNode_v._getExportDir()"

		local other_node_path

		for _node in this._getNodesInScene() where _node.export_dir != "" do
			other_node_path = _node.export_dir

		if other_node_path != undefined then other_node_path else ".\Export" -- return
	),


	/** Get
	  *
	  * @return integer
	  * 		1) biggest node size from other nodes in scene
	  * 		2) default
	 */
	function _getNodeSize =
	(
		--format "\n"; print "ExportNode_v._getNodeSize()"
		other_node_size = 0

		for _node in this._getNodesInScene() where _node.size > other_node_size do
			other_node_size = _node.size

		if other_node_size != 0 then other_node_size else 100
	),

	/** Get selected objects without ExportNodePlugins
	 */
	function _getSelection =
	(
		--format "\n"; print "ExportNode_v._removeNodesFromSelection()"
		for obj in selection where obj.parent == undefined and classOf obj != ExportNodePlugin collect obj --return
	),

	/** Center node to xy center of selection, and bottom on z axis
	  *
	  * @return point3 selection bbox center, or [0,0,0] if nothing selected
	 */
	function _getNewNodePosition =
	(
		--format "\n"; print "ExportNode_v._getNewNodePosition()"

		if selection.count > 0 then
		(
			bb_min = selection.min
			bb_max = selection.max
	
			center_x = (bb_min.x + bb_max.x) * 0.5
			center_y = (bb_min.y + bb_max.y) * 0.5
			bottom_z = bb_min.z
	
			[center_x, center_y, bottom_z] -- return
		)
		else
			[0, 0, 0] --return
	),

	/** Get name of new Export node
	  *
	  * @return string
	  *		1) Name of first selected Group, if only single group is selected
	  *		2) Object name if any is selected
	  *		3) Scene name
	  *		4) "ExportNodePlugin" if scene is unsaved
	 */
	function _getNewNodeName =
	(
		--format "\n"; print "ExportNode_v._getNewNodePosition()"
		--local node_name

		--if this._selection.count > 0 then
		--	if (groups_in_selection = for obj in this._selection where isGroupHead obj collect obj).count > 0 then
		--		node_name = groups_in_selection[1].name
		
		--node_name = if selection.count > 0 then selection[1].name
		node_name = case of
		(
			( selection.count > 0): selection[1].name
			( maxFileName != ""): ( dotNetObject "System.Text.RegularExpressions.Regex" @"[_-]\d+$" ).Replace ( getFilenameFile maxFileName ) ""
			
			default: "ExportNodePlugin"
		)

		node_name --return
	),

	on create do
	(
		--print "ExportNode_v.onCreate()"
	)
)
