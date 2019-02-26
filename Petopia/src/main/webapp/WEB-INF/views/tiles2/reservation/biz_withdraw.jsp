<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<% String ctxPath = request.getContextPath(); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예치금 출금하기</title>

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link href="https://fonts.googleapis.com/css?family=Montserrat" rel="stylesheet">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" defer="defer"></script> 
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.22.1/moment.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="http://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
<!-- iamport.payment.js -->
<script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.1.5.js"></script>

<style>
body { 
  margin: 0;
  font-family: Montserrat, Arial, Helvetica, sans-serif;

}
.deposit-header {
  padding: 2px 16px;
  background-color: #ff6e60;
  color: white;
  position: fixed;
  top: 0;
  z-index: 1;
  width: 100%;
}

.deposit-body {
	padding: 2px 16px;
	height: 500px;
	padding: 100px 0;
	margin: 50px auto 0 auto;
	width: 80%;

}

.deposit-footer {
  padding: 2px 16px;
  background-color: #ff6e60;
  color: white;
  height: 15%;
}

.subject{
	font-weight: bold;
	font-size: 12pt;
	border-radius: 3%;
	border-bottom: 1px solid #ff6e60;
	width: 15%;
	margin-bottom: 5%;
}
.underline {
	border-bottom: 1px solid #ff6e60;
}
.progress-container {
  width: 100%;
  height: 8px;
  background: #ff6e60;
}

.progress-bar {
  height: 8px;
  background: white;
  width: 0%;
}
label {
	font-weight: normal;
}

.btn-rounder {
	width: 80px;
	font-size: 10px;
	color: white;
	text-align: center;
	background: gray;
	border-radius: 30px;
}
.selected {
	width: 80px;
	font-size: 10px;
	color: white;
	text-align: center;
	background: rgb(252, 118, 106);
	border-radius: 30px;
}

.error{
	color: red;
	font-weight: bold;
}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		$(".depositType").click(function(){
			$(".depositType").removeClass("selected");
			$("#depositType").val($(this).val());
			$(this).addClass("selected");
		});
		
		$("#depositCoin").blur(function() {
		     var dcoin = $("#depositCoin").val();
		     var sumcoin = ${depositAmount};
		     
		     if(dcoin>sumcoin){
		    	 alert("출금금액은 예치금잔액을 초과할 수 없습니다.");
		    	 $("#depositCoin").val(0).focus();
		    	 return false;
		     }
		     else if(dcoin<0){
		    	 alert("출금금액은 0이상이어야 합니다.");
		    	 $("#depositCoin").val(0).focus();
		    	 return false;
		     }
		});
		
		$("#accountNumber").blur(function() {
			var regexp = /^[0-9]*$/
			var v = $(this).val();
			if( !regexp.test(v) ) {
				$("#notice1").addClass('error');
				$(this).val(v.replace(regexp,''));
				$(this).focus();
			}
			else {
				$("#notice1").remove('error');
			}
		});
	});
	function numberWithCommas(x) {
	    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
	
	function withdrawForBizEnd(){
		
		var frm = document.withdrawFrm;
		var bool = confirm("예치금 "+numberWithCommas(frm.depositCoin.value)+"원을 출금하시겠습니까?");
		if(bool){
			frm.method="POST";
			frm.action="withdrawForBizEnd.pet";
			frm.submit();
		}
		else{
			return false;
		}
	}

</script>

</head>


<body>
 <div class="deposit-header">
	<h2>Withdraw Deposit</h2>
    <div class="progress-container">
    <div class="progress-bar" id="myBar"></div>
  </div> 
  </div>
  <form name="withdrawFrm">
  <div class="deposit-body">
   	<div class="row">
    	<div class="col-md-3">회원번호: ${idx}</div>
    	<input type="hidden" name="idx" value="${idx}"/>
		<div class="col-md-3">예치금잔액: <fmt:formatNumber pattern="##,###">${depositAmount}</fmt:formatNumber>원</div>
   	</div>
   	<hr style="border-top: 0px solid gray;">
   	<div class="subject">출금금액</div>
   	<div class="row">
   		<div class="col-md-8">
    		<input type="number" class="form-control"name="depositCoin" id="depositCoin" value="0"/>
   		</div>
   	</div>
   	<hr style="border-top: 0px solid gray;">
   	<div class="subject">출금계좌</div>
   	<div class="row">
   		<div class="col-md-8">
    		<button type="button" class="btn btn-rounder depositType" value="신한">신한</button>&nbsp;
    		<button type="button" class="btn btn-rounder depositType" value="농협">농협</button>
    		<button type="button" class="btn btn-rounder depositType" value="우리">우리</button>&nbsp;
    		<button type="button" class="btn btn-rounder depositType" value="하나">하나</button>
   			<input type="hidden" id="depositType" name="depositType" value="withdraw"/>
   		</div>
   	</div>
   	<div class="row" style="margin-top: 5%; margin-bottom: 5%;">
   		<div class="col-md-6" id="notice1">'-' 없이 숫자만 입력하세요.</div>
   	</div>
   	<div class="row">
   		<div class="col-md-6">
   			<input type="text" class="form-control"name="accountNumber" id="accountNumber" value="0"/>
   		</div>
   	</div>
  </div>
  </form>
  <div class="deposit-footer text-center">
      <button type="button" class="btn btn-default" onClick="withdrawForBizEnd();">출금하기</button>
      <button type="button" class="btn btn-default" onClick="javascript:self.close();">취소</button>
  </div>
</body>
<%-- [190209] 끝 --%>
<script>
// When the user scrolls the page, execute myFunction 
window.onscroll = function() {myFunction()};

function myFunction() {
  var winScroll = document.body.scrollTop || document.documentElement.scrollTop;
  var height = document.documentElement.scrollHeight - document.documentElement.clientHeight;
  var scrolled = (winScroll / height) * 100;
  document.getElementById("myBar").style.width = scrolled + "%";
}
</script>
</html>