<%@ Language=VBScript %>
<%
On Error Resume Next

Dim objDocument
%>
<html>
	<head>
	<STYLE TYPE="text/css">
	<!--
		.node { color: black;
			font-family : "Helvetica", "Arial", "MS Sans Serif", sans-serif;
			font-size : 9pt;}
		.node A:link { color: black; text-decoration: none; }
		.node A:visited { color: black; text-decoration: none; }
		.node A:active { color: black; text-decoration: none; }
		.node A:hover { color: black; text-decoration: none; }
	-->
	</STYLE>
	</head>
	<body>
<%
On Error Resume Next
dim sXMLSourceFile
dim iTotal, sLeftIndent, bLoaded
	
iTotal = 0
sLeftIndent = ""
sXMLSourceFile = "menuitems.xml"

'Create instance of XML document object that we can manipulate
Set objDocument = Server.CreateObject("MSXML2.FreeThreadedDOMDocument.3.0")
if objDocument is nothing then
	Response.Write "objDocument object not created<br>"
else
	If Err Then 
		Response.Write "XML DomDocument Object Creation Error - <BR>"
		Response.write Err.Description
	else
		'Load up the XML document into the XML object
		objDocument.async = false
		bLoaded = objDocument.load(Server.MapPath(sXMLSourceFile))
			
		if (bLoaded = False) then
			sbShowXMLParseError objDocument 
		else
			'Set some folders to open by default.
			dim arArray(3)
			arArray(0) = objDocument.firstChild.getAttribute("value") 'Root value in our tree should be open by default
			arArray(1) = "History"
			
			'Start building the menu table structure
			%><table border="0" cellspacing="0" cellpadding="0" width="100%">
				<tr>
					<td>
			<%
			'This subroutine generates the HTML for the menu based on
			'data loaded into the XML object
			DisplayNode objDocument.childNodes, iTotal, sLeftIndent, arArray
			%>
					</td>
				</tr>
			</table><%
		end if
	end if
end if
	
%>
<SCRIPT LANGUAGE="Javascript">
	<!--
		//These two arrays work with each other to identify the menu element that should
		//be hidden or made visible.  There is a one-to-one relationship between
		//the rows of each array.  For example arClickedElementID(0) contains the
		//ID to access the element ID stored in arAffectedMenuItemID(0).
			
		//Note: The value of the ASP variable iTotal used below represents the
		//total number of items and subitems in the menu.  The value is set by
		//reference in the DisplayNode() subroutine call
		var arClickedElementID = new Array(<% for i = 1 to iTotal %> "<%=i%>"<%if i < iTotal then%>,<%end if%> <%next%>);
		var arAffectedMenuItemID = new Array(<% for i = 1 to iTotal %> "<%=i+1%>"<%if i < iTotal then%>,<%end if%> <%next%>);
			
		//This function queries the arClickedElementID[] and arAffectedMenuItemID[] arrays
		//to get an object reference to the appropriate menu element to show or hide.
		function fnLookupElementRef(sID)
		{
			var i;
			for (i=0;i<arClickedElementID.length;i++)
				if (arClickedElementID[i] == sID)
					return document.all(arAffectedMenuItemID[i]);
						
			return null;
		}
			
		//This function is responsible for showing/hiding the menu items.  It
		//also switches the images accordingly
		function doChangeTree()
		{
			var targetID, srcElement, targetElement;
			srcElement = window.event.srcElement;
				
			//Only work with elements that have LEVEL in the classname
			if(srcElement.className.substr(0,5) == "LEVEL") 
			{
				//Using the ID of the item that was clicked, we look up
				//and retrieve an object reference to the menu item that
				//should be shown or hidden
				targetElement = fnLookupElementRef(srcElement.id)		
					
				if (targetElement != null)
				{
					//First find out if the current folder is empty
					//We find out based on the name of the image used
					var sImageSource = srcElement.src;
					if (sImageSource.indexOf("empty") == -1)
					{
						if (targetElement.style.display == "none")
						{
							//Our menu item is currently hidden, so display it
							targetElement.style.display = "";
								
							if (srcElement.className == "LEVEL1")
								//Set a special open-folder graphic for the root folder
								srcElement.src = "images/minusonly.gif";
							else
								//Otherwise, just show the open folder icon
								srcElement.src = "images/folderopen.gif";
						}
						else
						{
							//Our menu item is currently visible, so hide it
							targetElement.style.display = "none";
								
							if (srcElement.className == "LEVEL1")
								//Set a special closed-folder graphic for the root folder
								srcElement.src = "images/plusonly.gif";
							else
								//Otherwise, just show the closed folder icon
								srcElement.src = "images/folderclosed.gif";
						}
					} 
				}
			}
		}	
			
		//Capture user clicks on the web page and 
		//call the doChangeTree() function to 
		//handle the event
		document.onclick = doChangeTree;
	-->
	</SCRIPT>
<%
'Release memory
Set objDocument	= Nothing

if err <> 0 then
	'We got an error, so display the message
	Response.Write err.description
end if
%>
	</body>
</html>

<%
'This subroutine is the workhorse of our menu page.  It is responsible for 
'traversing the XML tree to display each menu item.  The routine calls itself
'recursively and generates an HTML page containing javascript that handles
'showing/hiding menu items.
'[Parameters]
'--------------------
'objNodes :	The root XML node to traverse
'iElement :	Passed by reference, this value increments twice each time we add
'			a new menu item.  The first time it increments, the value is to identify the 
'			menu item.  The value is immediately incremented and this time is used to
'			identify the element that will be shown/hidden
'sLeftIndent :	Passed by reference, this string accumulates the <td> and <img> tags necessary
'				to display empty space and dotted lines to the left of the menu item as
'				the item gets indented in the list.
'arOpenFolders :	This array contains string values that tell the subroutine
'					which folders should be displayed as "open" by default.
Sub DisplayNode(ByVal objNodes, ByRef iElement, ByRef sLeftIndent, byVal arOpenFolders)
	on error resume next
	
	Dim oNode, sAttrValue, sNodeType, sURL
	Dim NODE_ELEMENT
	dim sTempLeft, bHasChildren, bForceOpen, bIsLast
	  
	NODE_ELEMENT = 1
	iElement = iElement + 1
	
	For Each oNode In objNodes
		'Find out if current node has children
		bHasChildren = oNode.hasChildNodes
		
		'Find out if the current node is the last member
		'in the list or not
		if not(oNode.nextSibling is nothing) then
			bIsLast = false
		else
			bIsLast = true
		end if
			
		'Ignore NODE_TEXT node types
		if oNode.nodeType = NODE_ELEMENT Then
			sAttrValue = oNode.getAttribute("value")			'Get the display value of the current node
			sNodeType = lcase(oNode.getAttribute("type"))		'Get the type of the current node Folder/Document
			bForceOpen = fnInArray(sAttrValue, arOpenFolders)	'Determine if folder is open by default
			sURL = oNode.getAttribute("url")
			if (sNodeType = "document") then%>
				<table border="0" cellspacing="0" cellpadding="0" width="100%">
					<tr valign="bottom">
						<%
						'Display the proper indentation formatting
						Response.write sLeftIndent
						
						'Now display the document
						%>
						<td width="31"><img src="images/<%=fnChooseIcon(bIsLast, sNodeType, bHasChildren, bForceOpen)%>" width="31" height="16" border="0"></td>
						<td nowrap class="node">&nbsp;<a href="<%=sURL%>" target="basefrm"><%=sAttrValue%></a></td>
					</tr>
				</table>
<%			'Otherwise this is a folder
			else%>
				<table border="0" cellspacing="0" cellpadding="0" width="100%">
					<tr valign="bottom">
						<%
						'Display the proper indentation formatting
						Response.write sLeftIndent
							
						'Now display the folder
						%>
						<td width="31"><img class="LEVEL<%=iElement%>" src="images/<%=fnChooseIcon(bIsLast, sNodeType, bHasChildren, bForceOpen)%>" id="<%=iElement%>" width="31" height="16" border="0"></td>
						<td nowrap class="node">&nbsp;<a href="<%=sURL%>" target="basefrm"><%=sAttrValue%></a></td>
					</tr>
				</table>
				<%
				'After displaying the folder, let's see
				'if it contains any submenu items	      
				If bHasChildren Then
					'Increment the element ID so that the child will have an
					'ID that is different from the parent 
					iElement = iElement + 1
					%>
					<table border="0" cellspacing="0" cellpadding="0" width="100%">
						<tr valign="bottom" class="LEVEL<%=iElement%>" id="<%=iElement%>" style="display:<%if ( fnInArray(sAttrValue, arOpenFolders) = false ) then%>none<%end if%>">
							<td>
					<%
							'First store the indentation code
							sTempLeft = sLeftIndent
						
							'We don't want to indent the first node on our tree
							'so only generate indent code if this not the root menu item
							if (iElement > 1) then
								sLeftIndent = fnBuildLeftIndent(oNode, bIsLast, sLeftIndent)
							end if
							
							'Call this subroutine again to process the submenu item
							DisplayNode oNode.childNodes, iElement, sLeftIndent, arOpenFolders
						
							'We're popping the stack, so reset the value of sLeftIndent
							'to what it was before we went into the DisplayNode() subroutine above
							sLeftIndent = sTempLeft
					%>	
							</td>
						</tr>
					</table>
					<%
				End If
			end if
		End If
	Next

	'Display any error messages encountered while executing this subroutine
	if err <> 0 then
		Response.Write err.description & "<br>"
	end if
End Sub

'This function returns the appropriate icon to be displayed in the menu.  It decides
'which icon to return based on the parameters that are passed in.
'[Parameters]
'--------------------
'bIsLast :		TRUE/FALSE - is this the last child in the current list?
'sNodeType :	String containing "document", "folder", or "root".
'bHasChildren :	TRUE/FALSE - specifies if the current item has any children
'bForceOpen :	TRUE/FALSE - should the folder be open by default?
function fnChooseIcon(byval bIsLast, byval sNodeType, byval bHasChildren, byval bForceOpen)
	dim sIcon
	
	sIcon = ""
	
	if (sNodeType = "document") then  'We always pass an empty value here when setting a document image
		if (bIsLast = false) then
			sIcon = "docjoin.gif"  'This is not the last document in list, so use JOIN graphic
		else
			sIcon = "doc.gif"  'This is the last document on the list so use the DOC angle graphic
		end if
	elseif (bForceOpen = false) then 'This item is not supposed to default to Open
		if  (bHasChildren = true) then
			'Folder has children, so use default folder closed icon
			sIcon = "folderclosed.gif"
		elseif (bHasChildren = false) then
			'Folder does NOT have children, so first check
			'what order it is in the list
			if (bIsLast = false) then
				'Not the last member, so use an empty folder with a line join graphic
				sIcon = "folderclosedjoin-empty.gif"
			else
				'Is the last member, so use an empty folder with a line angle graphic
				sIcon = "folderclosed-empty.gif"
			end if
		end if
	else 'Folder should be displayed as open by default
		if (sNodeType = "root") and (bForceOpen = true) then
			'Root item requires special icon
			sIcon = "minusonly.gif"
		else
			'This is a standard open folder with children
			sIcon = "folderopen.gif"
		end if
	end if
	
	fnChooseIcon = sIcon
end function

'Checks the contents of an array for a specific item.  If it is
'found, the function returns TRUE, otherwise it returns FALSE.
'[Parameters]
'--------------------
'sSearchItem :	String to search for
'arArray :	A single column array containing strings
function fnInArray(sSearchItem, arArray)
	for i = 0 to ubound(arArray)
		if ( lcase(sSearchItem) = lCase(arArray(i)) ) then
			fnInArray = true
			exit function
		end if
	next
	
	fnInArray = false
end function

'This function builds the html code necessary for indenting the menu
'item.  This includes any graphics that may be necessary for showing
'a continuation of a dotted line.  The new string is returned by the function.
'[Parameters]
'--------------------
'oNode :	Object reference for a node
'bIsLast :	TRUE/FALSE - Is this the last child in the list?
'sLeftIndent :	String containing the html code for indenting the item
function fnBuildLeftIndent(byval oNode, byval bIsLast, byVal sLeftIndent)
	
	'Now we check to see if this node is the last on the 
	'list or if it has more siblings.  We set up our indent
	'accordingly.  We need to set this up before displaying
	'any of the node's children.
	if (bIsLast = false) then
		'This node is not the last on the list, so we need to create
		'an indent that contains a dotted line.
		sLeftIndent = sLeftIndent & "<td width=""18""><img src=""images/line.gif"" width=""18"" height=""16""></td>"
	else
		'Otherwise it is the last on the list so we just need to
		'display a blank space
		sLeftIndent = sLeftIndent & "<td width='20'><img src=""images/pixel.gif"" width='20' height=""1"" border=""0""></td>"
	end if
	
	fnBuildLeftIndent = sLeftIndent
end function

'This subroutine takes the document object containing the parse error
'and displays a descriptive message explaining the source of the error.
sub sbShowXMLParseError(byVal objDocument)
	dim objParseError
	Set objParseError = objDocument.parseError
				
	Response.Write "XML File failed to load<BR>"
	Response.Write "---------------------------<BR>"
				
	Response.Write "Error: " & objParseError.reason & "<BR>"
    Response.Write "Line: " & objParseError.Line & "<BR>"
    Response.Write "Line Position: " & objParseError.linepos & "<BR>"
    Response.Write "Position In File: " & objParseError.filepos & "<BR>"
    Response.Write "Source Text: " & objParseError.srcText & "<BR>"
    Response.Write "Document URL: " & objParseError.url & "<BR>"
    
    set objParseError = nothing
end sub
%>
