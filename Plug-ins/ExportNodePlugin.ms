
plugin shape ExportNodePlugin

name:	"Export Node"
extends:	text
classID:	#(0x133067, 0x54375)
version:	1.1
category:	"Splines"
replaceUI:	true
(
	/*------------------------------------------------------------------------------
		METHODS
	--------------------------------------------------------------------------------*/

	/** Get animation keys of node
	  *
	  * @param name controller_type #position|#rotation|#scale
	  *
	  * @return array of used frames
	 */
	function getAnimationKeys controller_type =
	(
		--format "\n"; print ".getAnimationKeys()"
		_ExportNodePlugin = this._getNodeObejct()


		controller	= case controller_type of
		(
			#position:	_ExportNodePlugin.position.controller
			#rotation:	_ExportNodePlugin.rotation.controller
			#scale:	_ExportNodePlugin.scale.controller
			default:	return false
		)

		anim_keys = #()

		if (num_keys = numKeys controller ) > 0 then
			anim_keys = for i = 1 to num_keys collect ((getKeyTime controller i) as string ) as integer

		anim_keys --return
	)


	/** Get all nested node children
	 */
	function getAllChildren =
	(
		--mapped function _getAllChildren _node &children = ( join children _node.children;	if _node.children.count > 0 then _getAllChildren _node.children &children )

		--format "\n"; print "NodeList_v.selectChildNodes()"
		all_children	= #()

		this._getAllChildren #( this._getNodeObejct() ) ( all_children )

		--all_children += this._getAllChildren(this._getNodeObejct())

		all_children --return
	)
	
	/** Resize export node by its children along X axis of export node
			
		max size of node is twice size of childre on axis z
		
	 */
	function resizeNodeByChildren = 
	(
		clearListener(); print("Cleared in:\n"+getSourceFileName())
	
		/* 
		Get bounding box XY size
		Returns Point2(x_size, y_size) of combined bounding box of given objects.
		*/
		function getBoundingBoxXYSize _objects =
		(
			if _objects.count > 0 then
			(
				first_obj = _objects[1]
				bb_min = [first_obj.min.x, first_obj.min.y, first_obj.min.z]
				bb_max = [first_obj.max.x, first_obj.max.y, first_obj.max.z]
		
				for i = 2 to _objects.count do
				(
					obj = _objects[i]
		
					bb_min.x = amin bb_min.x obj.min.x
					bb_min.y = amin bb_min.y obj.min.y
					bb_min.z = amin bb_min.z obj.min.z
		
					bb_max.x = amax bb_max.x obj.max.x
					bb_max.y = amax bb_max.y obj.max.y
					bb_max.z = amax bb_max.z obj.max.z
				)
		
				x_size = bb_max.x - bb_min.x
				y_size = bb_max.y - bb_min.y
		
				[x_size, y_size] -- return
			)
			else
				undefined -- return
		)
	
		/*
		Return size in X and Y axes from given bounding box in local space
		*/
		function _getXYSizeFromBoundingBox bbox =
		(
			if bbox == undefined then return undefined  -- return
		
			min_pt = bbox[1]
			max_pt = bbox[2]
		
			size_x = max_pt.x - min_pt.x
			size_y = max_pt.y - min_pt.y
		
			[size_x, size_y]  -- return
		)
		
		_node = this._getNodeObejct()
		
		--children = _node.getAllChildren()
		children = this.getAllChildren()
	
		if children.count > 0 then
		(
			children_size = getBoundingBoxXYSize children
	
			_node_bbox	= nodeGetBoundingBox _node _node.transform -- return array of min\max positions E.G.: bbox[1].z | bbox[2].z
			_node_size = _getXYSizeFromBoundingBox _node_bbox
			
			ratio = _node_size.x / children_size.x 
			format "ratio: %\n" ratio
	
			increment = if ratio > 2 then -1 else 1
			-- format "increment: %\n" increment
			
			while ratio > 2 or ratio < 0.5 do
			(
				new_node_size = _node.size + increment
		
				if new_node_size < 1 then
					exit
	
				_node.size = new_node_size
	
				_node_bbox	= nodeGetBoundingBox _node _node.transform -- return array of min\max positions E.G.: bbox[1].z | bbox[2].z
				
				_node_size = _getXYSizeFromBoundingBox _node_bbox
		
				ratio = _node_size.x / children_size.x
			)
		)
	
	)
	
	/*------------------------------------------------------------------------------
		PARAMETERS
	--------------------------------------------------------------------------------*/

	parameters export_name rollout:export_name_rollout
	(
		text  type:#string default:"Export Node"	ui:node_name

		on text set val do
			if val != undefined and val != "" then
			(
				Delegate.text = val

				if ( _node =  this._getNodeObejct()) != undefined then
					_node.name = val
			)
	)

	parameters export_dir_params rollout:export_dir_rollout
	(
		export_dir  type:#string default:""	ui:edit_export_path
	)

	parameters main rollout:params
	(
		size  type:#integer default:100 ui:node_size align:#left

		on size set val do
			Delegate.size = val
	)

	/*------------------------------------------------------------------------------
		ROLLOUTS
	--------------------------------------------------------------------------------*/

	rollout export_name_rollout "Display Text" rolledUp:false
	(
		edittext node_name ""
	)

	rollout export_dir_rollout "Export Directory" rolledUp:false
	(
		edittext edit_export_path ""
	)

	rollout params "Parameters"
	(
		spinner node_size	"Size" range:[0,999,20] type:#integer offset:[ -32 , 8 ]
		
		button autosize_node "Auto size" height:32 width:96 offset:[ 0 , 8 ]
		
		on autosize_node pressed do
			if queryBox ("Resize node by it`s children ?\n\nNODE: "+ this.text ) title:"RESIZE NODE"  beep:false then
				resizeNodeByChildren()
		
	)

	on create do
	(
  		--format "\n"; print ".onCreate()"
		Delegate.size = this.size
		--this._getNodeObejct() --return
		this -- return
	)

	on attachedToNode _node  do
	(
		_node.name = "Export Node"
	)

	on load  do
	(
		Delegate.render_useViewportSettings = false
		Delegate.render_displayRenderMesh  = false
	)


	/*------------------------------------------------------------------------------

		PRIVATE

	--------------------------------------------------------------------------------*/

	/** Get node obejct
	 */
	function _getNodeObejct =
	(
		--format "\n"; print "._getNodeObejct()"
		nodes = for o in refs.dependents this where isvalidnode o collect o

		nodes[1] --return
	)

	/**  Get all nested children
	  */
	mapped function _getAllChildren _node &children = ( join children _node.children;	if _node.children.count > 0 then this._getAllChildren _node.children &children )

)