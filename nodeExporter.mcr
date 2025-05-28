macroscript nodeExporter_open
category:	"_nodeExporter"
buttontext:	"Exporter"
toolTip:	"Open nodeExporter"
(
-- 	filein @"$userscripts\nodeExporter\nodeExporter-import-scripts.ms"
	--filein @"$userscripts\nodeExporter\includes.ms"
	
	if DIALOG_nodeexporter != undefined and not keyboard.controlPressed then 
		NodeExporter.create()

	else
		filein @"$userscripts\MAXSCRIPT-nodeExporter\nodeExporter.ms"
	
)