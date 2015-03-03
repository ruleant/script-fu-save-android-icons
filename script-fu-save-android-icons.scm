; --------------------------------------------------------------------------
; Save Android Icons 
; Copyright (C) 2011 Goran Siric ( http://www.izvornikod.com )
; Copyright (C) 2013 Dieter Adriaenssens <ruleant@users.sourceforge.net>
; All rights reserved
;
; Based on script "Phoca Save Icons" maded by Jan Pavelka ( http://www.phoca.cz )

; This script is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 3 of the License, or
; (at your option) any later version.
;
; The GNU General Public License can be found at
; http://www.gnu.org/copyleft/gpl.html.
; --------------------------------------------------------------------------

; Update 06.02.2012 (by Goran Siric)
; - added support for XHDPI screens
; - added support for action bar icons 
; - added support for custom icon sizes

; Update 13.12.2013 (by Dieter Adriaenssens)
; - added support for XXHDPI and XXXHDPI screens

(define (script-fu-save-android-icons 
		iconType 
		customW_mdpi
		customH_mdpi
		saveMode
		useNamingConvention 
		image 
		folder 
		name 
		interpolation 
		interlace 
		compression 
		bKGD 
		gAMA 
		oFFs 
		pHYs 
		tIME 
		comment 
		svtrans)

(let* (
	(newImage 0)
	(newDraw 0)
	(newName "")
	(rawName "")
	(y 0)
	(partName "")
	(stdFolderName "")
	(formatsW (cons-array 6 'byte))
	(formatsH (cons-array 6 'byte))
	(namePrefix "")
	(useNamePrefix "")
	(fS 0)
	(customW_ldpi (round (* customW_mdpi 0.75) ))
	(customW_hdpi (round (* customW_mdpi 1.5) ))
	(customW_xhdpi (round (* customW_mdpi 2.0) ))
	(customW_xxhdpi (round (* customW_mdpi 3.0) ))
	(customW_xxxhdpi (round (* customW_mdpi 4.0) ))
	(customH_ldpi (round (* customH_mdpi 0.75) ))
	(customH_hdpi (round (* customH_mdpi 1.5) ))
	(customH_xhdpi (round (* customH_mdpi 2.0) ))
	(customH_xxhdpi (round (* customH_mdpi 3.0) ))
	(customH_xxxhdpi (round (* customH_mdpi 4.0) ))
)

;	"Android icons type"		'("Launcher Icons 36/48/72/96/144/192" "Menu Icons" "Status Bar Icons" "Tab Icons" "Dialog Icons" "List View Icons")
;	"Android icons type"		'("Launcher Icons" "Menu Icons" "Action Bar Icons" "Status Bar Icons" "Tab Icons" "Dialog Icons" "List View Icons")

; "Launcher Icons" "Menu Icons"
(cond ( 
	(or (= iconType 0) (= iconType 1) )
	(aset formatsW 0 36)
	(aset formatsW 1 48)
	(aset formatsW 2 72)
	(aset formatsW 3 96)
	(aset formatsW 4 144)
	(aset formatsW 5 192)
	(aset formatsH 0 36)
	(aset formatsH 1 48)
	(aset formatsH 2 72)
	(aset formatsH 3 96)
	(aset formatsH 4 144)
	(aset formatsH 5 192)
	)
)

(cond (
	( or (= iconType 2) (= iconType 3) )
	(aset formatsW 0 18)
	(aset formatsW 1 24)
	(aset formatsW 2 36)
	(aset formatsW 3 48)
	(aset formatsW 4 72)
	(aset formatsW 5 96)
	(aset formatsH 0 18)
	(aset formatsH 1 24)
	(aset formatsH 2 36)
	(aset formatsH 3 48)
	(aset formatsH 4 72)
	(aset formatsH 5 96)
	)
)

(cond ( 
	(or (= iconType 4) (or (= iconType 5) (= iconType 6) ) )
	(aset formatsW 0 24)
	(aset formatsW 1 32)
	(aset formatsW 2 48)
	(aset formatsW 3 64)
	(aset formatsW 4 96)
	(aset formatsW 5 128)
	(aset formatsH 0 24)
	(aset formatsH 1 32)
	(aset formatsH 2 48)
	(aset formatsH 3 64)
	(aset formatsH 4 96)
	(aset formatsH 5 128)
	)
)

; if custom icon type is selected
(cond ( (= iconType 7)
	(aset formatsW 0 customW_ldpi)
	(aset formatsW 1 customW_mdpi)
	(aset formatsW 2 customW_hdpi)
	(aset formatsW 3 customW_xhdpi)
	(aset formatsW 4 customW_xxhdpi)
	(aset formatsW 5 customW_xxxhdpi)
	(aset formatsH 0 customH_ldpi)
	(aset formatsH 1 customH_mdpi)
	(aset formatsH 2 customH_hdpi)
	(aset formatsH 3 customH_xhdpi)
	(aset formatsH 4 customH_xxhdpi)
	(aset formatsH 5 customH_xxxhdpi)
 )
)

( cond ((= iconType 0 ) (set! namePrefix "ic_launcher_")) )
( cond ((= iconType 1 ) (set! namePrefix "ic_menu_")) )
( cond ((= iconType 2 ) (set! namePrefix "ic_menu_")) )
( cond ((= iconType 3 ) (set! namePrefix "ic_stat_notify_")) )
( cond ((= iconType 4 ) (set! namePrefix "ic_tab_")) )
( cond ((= iconType 5 ) (set! namePrefix "ic_dialog_")) )
( cond ((= iconType 6 ) (set! namePrefix "ic_")) )
( cond ((= iconType 7 ) (set! namePrefix "custom_")) )


(cond ( (= useNamingConvention TRUE) (set! useNamePrefix namePrefix) ))



(while (< y 6)

	( cond ( (= y 0) (set! stdFolderName "drawable-ldpi" )))
	( cond ( (= y 1) (set! stdFolderName "drawable-mdpi" )))
	( cond ( (= y 2) (set! stdFolderName "drawable-hdpi" )))
	( cond ( (= y 3) (set! stdFolderName "drawable-xhdpi" )))
	( cond ( (= y 4) (set! stdFolderName "drawable-xxhdpi" )))
	( cond ( (= y 5) (set! stdFolderName "drawable-xxxhdpi" )))
	
	(set! newImage (car (gimp-image-duplicate image)))
	; set that all layers have same size as image
	(map (lambda (x) (gimp-layer-resize-to-image-size x)) (vector->list (cadr (gimp-image-get-layers newImage))))
	
	(gimp-image-merge-visible-layers newImage 0)
	(gimp-image-scale-full newImage (aref formatsW y) (aref formatsH y) interpolation)
	(set! newDraw (car (gimp-image-get-active-drawable newImage)))
		
	(cond ( (= saveMode 0)
		(set! newName (string-append folder DIR-SEPARATOR stdFolderName DIR-SEPARATOR useNamePrefix name  ".png"))
		(set! rawName (string-append useNamePrefix name "-" partName "0.png"))
		)
	)
	
	(cond ( (= saveMode 1)
		(set! partName (string-append (number->string (aref formatsW y)) "x" (number->string (aref formatsH y)) ))
		(set! newName (string-append folder DIR-SEPARATOR useNamePrefix name "_" partName ".png"))
		(set! rawName (string-append useNamePrefix name  ".png"))
		)
	)
	
	; Thanks to http://stackoverflow.com/a/11526313
	(define (string-replace strIn strReplace strReplaceWith)
		(let*
			(
				(curIndex 0)
				(replaceLen (string-length strReplace))
				(replaceWithLen (string-length strReplaceWith))
				(inLen (string-length strIn))
				(result strIn)
			)
			;loop through the main string searching for the substring
			(while (<= (+ curIndex replaceLen) inLen)
				;check to see if the substring is a match
				(if (substring-equal? strReplace result curIndex (+ curIndex replaceLen))
					(begin
						;create the result string
						(set! result (string-append (substring result 0 curIndex) strReplaceWith (substring result (+ curIndex replaceLen) inLen)))
						;now set the current index to the end of the replacement. it will get incremented below so take 1 away so we don't miss anything
						(set! curIndex (-(+ curIndex replaceWithLen) 1))
						;set new length for inLen so we can accurately grab what we need
						(set! inLen (string-length result))
					)
				)
				(set! curIndex (+ curIndex 1))
			)
		   (string-append result "")
		)
	)

	(python-fu-eval 
		RUN-NONINTERACTIVE 
		(string-append 
			"import os\nimport errno\nimport sys\ntry:\n\tos.makedirs(os.path.dirname('" 
			(string-replace newName DIR-SEPARATOR "/") 
			"'.encode(sys.getfilesystemencoding())))\nexcept OSError as exception:\n\tif exception.errno != errno.EEXIST:\n\t\traise"))

	(file-png-save2 1 newImage newDraw newName rawName interlace compression bKGD gAMA oFFs pHYs tIME comment svtrans)

	(gimp-image-delete newImage)
	
	(set! y (+ y 1))
)


)
)

(script-fu-register	"script-fu-save-android-icons"
					"<Image>/Script-Fu/Android/Save Android Icons ..."
					"Save Icons For Android Platorm"
					"(c) Goran Siric ( http://www.izvornikod.com ) 2011"
					"License GPLv3"
					"22 September 2011"
					"RGB* GRAY* INDEXED*"
					SF-OPTION	"Android icons type"		'("Launcher Icons (36x36 48x48 72x72 96x96i 144x144 192x192)" "Menu Icons  (36x36 48x48 72x72 96x96 144x144 192x192)" "Action Bar Icons (18x18 24x24 36x36 48x48 72x72 96x96)" "Status Bar Icons (18x18 24x24 36x36 48x48 72x72 96x96)" "Tab Icons (24x24 32x32 48x48 64x64 96x96 128x128)" "Dialog Icons (24x24 32x32 48x48 64x64 96x96 128x128)" "List View Icons (24x24 32x32 48x48 64x64 96x96 128x128)" "Custom Icon  mdpi=baseline ldpi=0.75x hdpi=1.5x xhdpi=2x xxhdpi=3x xxxhdpi=4x")
					SF-ADJUSTMENT	"Custom Icon - mdpi width "			'(48 0 99999 1 10 0 1)
					SF-ADJUSTMENT	"Custom Icon - mdpi height"			'(48 0 99999 1 10 0 1)
					SF-OPTION	"Save mode"		'("Save to drawable-ldpi,mdpi,hdpi,xhdpi,xxhdpi,xxxhdpi folders below Root folder" "Append resolution to file name")
					SF-TOGGLE	"Use android naming convention"					TRUE
					SF-IMAGE 	"Image"				0
					SF-DIRNAME	"Root folder"		""
					SF-STRING 	"Name" 				""
					SF-ENUM 	"Interpolation" 	'("InterpolationType" "cubic")
					SF-TOGGLE		"Use Adam7 interlacing"				FALSE
					SF-ADJUSTMENT	"Deflate Compression factor (0-9)"  	'(9 0 9 1 10 0 0)
					SF-TOGGLE		"Write bKGD chunk"						TRUE
					SF-TOGGLE		"Write gAMA chunk"						FALSE
					SF-TOGGLE		"Write oFFs chunk"						FALSE
					SF-TOGGLE		"Write pHYs chunk"						TRUE
					SF-TOGGLE		"Write tIME chunk"						TRUE
					SF-TOGGLE		"Write comment"						TRUE
					SF-TOGGLE		"Preserve color of transparent pixels" TRUE
					
)
