<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"  %>    
    
<%
	String ctxPath = request.getContextPath();
%>    
<html>
<head>
<title>펫토피아 PETOPIA</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
	<!--<script src="https://use.fontawesome.com/971fd786d6.js"></script>-->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
	<link href="https://fonts.googleapis.com/css?family=Montserrat" rel="stylesheet">

	<link rel="stylesheet" href="http://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css" type="text/css" />
	<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.9.0/fullcalendar.min.css">
	<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar-scheduler/1.9.4/scheduler.css">
	  
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" defer="defer"></script> 
	<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.22.1/moment.min.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script src="http://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
	<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.9.0/fullcalendar.min.js"></script>
	<script type="text/javascript" src="https://fullcalendar.io/releases/fullcalendar-scheduler/1.9.4/scheduler.min.js"></script>
<style>
* {box-sizing: border-box;}

body { 
  margin: 0;
  font-family: Montserrat, Arial, Helvetica, sans-serif;

}

/* 최상단 헤더 css */
.header {
  overflow: hidden;
  background-color: #ff6e60;
  padding: 20px 10px;
  color: white;
}

.header a {
  float: left;
  color: white;
  text-align: center;
  padding: 12px;
  text-decoration: none;
  font-size: 12px; 
  line-height: 15px;
  border-radius: 50px;
}

.header a.logo {
  font-size: 30px;
  font-weight: bold;
  margin-left: 2.5%;
}

.header a:hover {
  background-color: white ;
  border-radius: 50px ;
  color: #ff6e60 ;
}

.header btn.active {
  background-color: white ;
  color: #ff6e60 ;
}

.header-right {
  float: right ;
  padding-right: 5% ;
  margin-top: 0.5% ;
}
.btnmenu {
  	border: solid 1px white ;
    background-color: #ff6e60 ;
    color: white ;
    text-align: center ;
  	padding: 7px ;
  	text-decoration: none ;
    cursor: pointer ;
 }
  
  .btn:hover {
  	background-color: white ;
    color: #ff6e60 ;
    
  }
  .btn-rounder {
    border: solid 1px white ;
    border-radius: 50px ;
    background-color: #ff6e60 ;
    padding: 3px ;
    padding-left: 10px ;
    padding-right: 10px ;
    color: white ;
  }


/* 드롭다운 메뉴 css */
.navbar1 {
  float: both;
  overflow: hidden ; 
  background-color: white ;
  font-family: Arial, Helvetica, sans-serif ;
  border-radius: 0px;
}

.navbar1 a {
  float: left ;
  font-size: 16px ;
  color: black ;
  text-align: center ;
  padding: 14px 16px ;
  text-decoration: none ;
}

.dropdown1 {
  float: both ;
  overflow: hidden ;
  border-radius: 0px;
}

.dropdown1 .dropbtn {
  font-size: 16px ;  
  border: none ;
  outline: none ;
  color: black ;
  padding: 14px 16px ;
  background-color: inherit ;
  font: inherit ;
  width: 10% ;
  margin: 0 ;
  margin-left: 1% ;
  margin-right: 1% ;
}

.navbar1 a:hover, .dropbtn:hover {
  background-color: #ff6e60 ;
  color: white ;
}

.dropdown-content {
  display: none ;
  position: absolute ;
  background-color: #f9f9f9 ;
  padding-left: 0px ;
  width: 100% ;
  left: 0 ;
  box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2) ;
  z-index: 1 ;
}

.dropdown-content{
  background: white ;
  padding-left: 0px ;
  color: black ;
}

.dropdown1:hover .dropdown-content {
  display: block ;
  padding-left: 0px ;
}

/* Create three equal columns that floats next to each other */
.column {
  float: left ;
  text-align: center ;
  width: 10% ;
  background-color: white ;
  height: 250px ;
  padding: 0px ;
    
  margin-left: 1% ;
  margin-right: 1% ;
}

.column a {
  float: none ;
  color: black ;
  text-decoration: none ;
  width: 100% ;
  display: block ;
}

.column a:hover {
  background-color: #ddd ; 
}

/* Clear floats after the columns */
.row:after {
  content: "" ;
  display: table ;
  clear: both ;
}

    
@media screen and (max-width: 600px) {
  .header a {
    float: none ;
    display: block ;
    text-align: left ;
  }
  
  .header-right {
    float: none ;
  }
  
  .column {
    width: 100% ;
    height: auto ;
  }
}
/* Responsive layout - when the screen is less than 700px wide, make the two columns stack on top of each other instead of next to each other */
@media screen and (max-width: 700px) {
  .row {   
    flex-direction: column ;
  }
}

/* Column container */
.row {  
  display: -ms-flexbox ; /* IE10 */
  display: flex ;
  -ms-flex-wrap: wrap ; /* IE10 */
  flex-wrap: wrap ;
}

/* Main column */
.main {   
  -ms-flex: 98%; /* IE10 */
  flex: 98%;
  background-color: white;
  padding: 20px;
}
    
/* 하단바 */
.footer {
  padding: 20px; /* Some padding */
  text-align: center; /* Center text*/
 /*  background: #ddd; */ /* Grey background */
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