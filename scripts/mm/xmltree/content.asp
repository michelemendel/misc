<%@ Language=VBScript %>
<HTML>
<HEAD>
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
</HEAD>
<BODY>

<%
Dim sPage

sPage = Request.QueryString("page")

select case (sPage)
	case "":
	%>Please choose a menu item on the left<%
	case "usa":
	%>United States of America<%
	case "states":
	%>States<%
	case "ca":
	%>California<%
	case "nj":
	%>New Jersey<%
	case "az":
	%>Arizona<%
	case "histfig":
	%>Historical Figures<%
	case "george":
	%>George Washington<%
	case "tom":
	%>Thomas Jefferson<%
	case "history":
	%>History<%
	case "20th":
	%>20th Century<%
	case "inv":
	%>Inventions<%
	case "tec":
	%>Technology<%
	case "radio":
	%>Radio<%
	case "invprof":
	%>Inventor Profile<%
	case "first":
	%>First Uses<%
	case "computers":
	%>Computers<%
	case "begin":
	%>Beginnings<%
	case "sum":
	%>Summary<%
	case "trans":
	%>Transistor<%
	case "inventor":
	%>Inventor<%
	case "app":
	%>Applications<%
	case "wars":
	%>Wars<%
	case "wwi":
	%>World War I<%
	case "wwii":
	%>World War II<%
	case "viet":
	%>Vietnam<%
	case "21st":
	%>21st Century<%
	case else:
	%>Your menu selection is not recognized.<%
end select
%>
</BODY>
</HTML>
