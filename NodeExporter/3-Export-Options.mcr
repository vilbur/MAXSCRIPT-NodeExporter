/** SET EXPORT_SIZE
  
	GLOBAL VARIABLE EXPORT_SIZE IS SHARED WITH MaxSlicer: https://github.com/vilbur/MAXSCRIPT-MaxSlicer
  
  
  
 */
macroscript	_export_settings_set_size
category:	"_Export"
buttontext:	"EXPORT SIZE       "
toolTip:	"Export size"
icon:	"Control:spinner|id:SPIN_export_size|range:[0,100,1]|offset:[16,0]|across:1|align:#left|width:96"
(
	format "\n!!!!!!!!!!!!!!!!!!! SET EXPORT SIZE\n"
	format "eventFired	= % \n" eventFired
	format "EXPORT_SIZE: %\n" EXPORT_SIZE
	
	this_control = DIALOG_nodeexporter.SPIN_export_size.value
	
	/* FIRED BY MAXSCRIPT ON STARTUP */ 
	if eventFired == undefined then
	(
		if EXPORT_SIZE == undefined then 
			EXPORT_SIZE = DIALOG_nodeexporter.SPIN_export_size.value
		else
			DIALOG_nodeexporter.SPIN_export_size.value = EXPORT_SIZE
	)
	/* FIRED BY CONTROL EVENT  */ 
	else
		EXPORT_SIZE = eventFired.val

	/* SYNC WITH MaxSlicer */ 
	if DIALOG_maxslicer != undefined then 
		DIALOG_maxslicer.SPIN_export_size.value = DIALOG_nodeexporter.SPIN_export_size.value

)
