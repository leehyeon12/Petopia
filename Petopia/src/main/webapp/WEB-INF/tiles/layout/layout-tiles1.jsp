<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- ======= #22. tiles 를 사용하는 레이아웃1 페이지 만들기  ======= --%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"  %>    
    
<%
	String ctxPath = request.getContextPath();
%>    
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>PETOPIA(펫토피아)</title>

	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"> 
	<link href="https://fonts.googleapis.com/css?family=Montserrat" rel="stylesheet">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

<style type="text/css">

	body { 
	  margin: 0;
	  font-family: Montserrat, Arial, Helvetica, sans-serif;
	
	}

	.jumbotron {
    	background-color: rgb(252,118,106);
    	color: #ffffff;
  	}
	
	.navbar {
	  margin-bottom: 0;
	  background-color: rgb(252, 118, 106);
	  z-index: 9999;
	  border: 0;
	  font-size: 12px !important;
	  line-height: 1.42857143 !important;
	  letter-spacing: 4px;
	  border-radius: 0;
	}
	
	.header a.logo {
	  font-size: 18px;
	  font-weight: bold;
	  margin-left: 2.5%;
	}
	
	.navbar li a, .navbar .navbar-brand {
	  color: white;
	}
	
	.navbar-nav li a:hover, .navbar-nav li.active a {
	  font-weight: bold;
	}
	
	.navbar-default .navbar-toggle {
	  border-color: transparent;
	  color: #fff !important;
	}
	    
	.navbar-default .navbar-nav .dropdown .dropdown-toggle:focus,
    .navbar-default .navbar-nav .dropdown .dropdown-toggle:hover
     {
        color: #fff;
        background-color: rgb(252, 118, 106);
     }
	
	 /*-- change navbar dropdown color --*/
  	.navbar-default .navbar-nav .open .dropdown-menu>li>a,.navbar-default .navbar-nav .open .dropdown-menu {
    	background-color: #fff !important;
    	color: rgb(252, 118, 106) !important;
  	}
  	
  	
	h2 {
	  font-size: 24px;
	  text-transform: uppercase;
	  /* color: #303030; */
	  font-weight: 600;
	  margin-bottom: 30px;
	}
	
	h4 {
	  font-size: 19px;
	  line-height: 1.375em;
	  color: #303030;
	  font-weight: 400;
	  margin-bottom: 30px;
	}
	
  	
  	
  	
</style>

</head>

<body>
	<div id="mycontainer">
		<div id="myheader">
			<tiles:insertAttribute name="header" />
		</div>
	
		<div id="mycontent">
			<tiles:insertAttribute name="content" />
		</div>
		
		<div id="myfooter">
			<tiles:insertAttribute name="footer" />
		</div>
	</div>
</body>
</html>