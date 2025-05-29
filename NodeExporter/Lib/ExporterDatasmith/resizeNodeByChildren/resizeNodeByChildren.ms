
/** Resize export node by its children along X axis of export node
  
  resizeNodeByChildren($ExportNodePlugin)
  
 */
function resizeNodeByChildren _node = 
(
	clearListener(); print("Cleared in:\n"+getSourceFileName())

	--/*
	--Get bounding box of given nodes in the coordinate system of a reference node
	--*/
	--function _getBoundingBoxInNodeSpace nodes reference_node =
	--(
	--	if nodes.count == 0 then return undefined  -- return
	--
	--	ref_tm_inv = inverse reference_node.transform
	--
	--	all_corners = #()
	--
	--	for n in nodes where isvalidnode n do
	--	(
	--		-- Get bounding box in world coordinates
	--		local_bb = nodeGetBoundingBox n n.transform
	--		bb_min = local_bb[1]
	--		bb_max = local_bb[2]
	--
	--		-- 8 corners of the bounding box
	--		corners = 
	--		#(
	--			[bb_min.x, bb_min.y, bb_min.z],
	--			[bb_max.x, bb_min.y, bb_min.z],
	--			[bb_min.x, bb_max.y, bb_min.z],
	--			[bb_max.x, bb_max.y, bb_min.z],
	--			[bb_min.x, bb_min.y, bb_max.z],
	--			[bb_max.x, bb_min.y, bb_max.z],
	--			[bb_min.x, bb_max.y, bb_max.z],
	--			[bb_max.x, bb_max.y, bb_max.z]
	--		)
	--
	--		for pt in corners do
	--		(
	--			-- pt already in world coords, transform to reference node space
	--			local_pt = pt * ref_tm_inv
	--			append all_corners local_pt
	--		)
	--	)
	--
	--	bb_min = all_corners[1]
	--	bb_max = all_corners[1]
	--
	--	for pt in all_corners do
	--	(
	--		bb_min = [amin bb_min.x pt.x, amin bb_min.y pt.y, amin bb_min.z pt.z]
	--		bb_max = [amax bb_max.x pt.x, amax bb_max.y pt.y, amax bb_max.z pt.z]
	--	)
	--
	--	#(bb_min, bb_max)  -- return
	--)
	
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
	
	children = _node.getAllChildren()

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

--resizeNodeByChildren( selection[1] )
