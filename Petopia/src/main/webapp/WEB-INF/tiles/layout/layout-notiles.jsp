<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- ======= #24. tiles 내에 content만 있는 레이아웃3 페이지 만들기  ======= --%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"  %>    

<html>
<head>
<title>펫토피아 PETOPIA</title>
</head>
<body>
<div id="mycontent">
		<tiles:insertAttribute name="content" />
</div>
</body>
</html>