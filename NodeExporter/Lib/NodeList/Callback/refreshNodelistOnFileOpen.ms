/**
 * https://help.autodesk.com/view/3DSMAX/2015/ENU/?guid=__files_GUID_C1F6495F_5831_4FC8_A00C_667C5F2EAE36_htm
 */
function refreshyNodeListOnFileOpenStart =
(
	print "refreshyNodeListOnFileOpenStart()"
	try( callbacks.removeScripts #filePostOpen id:#refreshyNodeListOnFileOpen )catch()
	try( callbacks.addScript #filePostOpen "refreshyNodeListOnFileOpen()" id:#refreshyNodeListOnFileOpen )catch()
)


/** 
 */
function refreshyNodeListOnFileOpenKill =
(
	print "refreshyNodeListOnFileOpenKill()"
	try( callbacks.removeScripts #filePostOpen id:#refreshyNodeListOnFileOpen )catch()
)


/** 
 */
function refreshyNodeListOnFileOpen =
(
	print "refreshyNodeListOnFileOpen()"
	
	if NodeList_v != undefined then 
		(NodeList_v()).refreshNodeList()
)