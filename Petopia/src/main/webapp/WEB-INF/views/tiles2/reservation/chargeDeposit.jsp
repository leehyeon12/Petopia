<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<% String ctxPath = request.getContextPath(); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예치금 충전하기</title>

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
	height: 450px;
	padding: 100px 0;
	margin: 50px auto 0 auto;
	width: 80%;

}

.deposit-footer {
  padding: 2px 16px;
  background-color: #ff6e60;
  color: white;
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
</style>
<script type="text/javascript">
	$(document).ready(function(){
	// [190209] selected css 추가 및 jQurey 추가
		$(".depositType").click(function(){
			$(".depositType").removeClass("selected");
			$("#depositType").val($(this).val());
			$(this).addClass("selected");
		});
		
	});
	function numberWithCommas(x) {
	    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
	
	// [190209] 시작
	function goPay(){
		
		var frm = document.chargePayFrm;
		var bool = confirm("예치금 "+numberWithCommas(frm.depositCoin.value)+"원을 충전하시겠습니까?");
		if(bool){
			var url = "chargeDepositEnd.pet?idx="+frm.idx.value+"&depositType="+frm.depositType.value+"&depositCoin="+frm.depositCoin.value;
			window.open(url, "chargeDepositEnd", "left=350px, top=100px, width=900px, height=650px");
		}
		else{
			return false;
		}
	}
	
	function goInsertDeposit(idx, realDeposit, depositType){
		var frm = document.insertDepositFrm;
		frm.idx.value=idx;
		frm.realDeposit.value=realDeposit;
		frm.depositType.value=depositType;			
		frm.method="POST";
		frm.action="insertDeposit.pet";
		frm.submit();
	}
</script>

</head>


<body>
 <div class="deposit-header">
	<h2>Charge for Deposit Coin</h2>
    <div class="progress-container">
    <div class="progress-bar" id="myBar"></div>
  </div> 
  </div>
  <form name="chargePayFrm">
  <div class="deposit-body">
   	<div class="row">
    	<div class="col-md-3">회원번호: ${idx}</div>
    	<input type="hidden" name="idx" value="${idx}"/>
		<div class="col-md-3">예치금잔액: <fmt:formatNumber pattern="##,###">${depositAmount}</fmt:formatNumber>원</div>
   	</div>
   	<hr style="border-top: 0px solid gray;">
   	<div class="subject">충전금액</div>
   	<div class="row">
   		<div class="col-md-8">
    		<input type="radio" name="depositCoin" id="coin1" value="100000"/><label for="coin1">100000원</label>&nbsp;
    		<input type="radio" name="depositCoin" id="coin2" value="200000"/><label for="coin2">200000원</label>&nbsp;
    		<input type="radio" name="depositCoin" id="coin3" value="300000"/><label for="coin3">300000원</label>&nbsp;
    		<input type="radio" name="depositCoin" id="coin4" value="400000"/><label for="coin4">400000원</label>&nbsp;
    		<input type="radio" name="depositCoin" id="coin5" value="500000"/><label for="coin5">500000원</label>
   		</div>
   	</div>
   	<hr style="border-top: 0px solid gray;">
   	<div class="subject">결제방식</div>
   	<div class="row">
   		<div class="col-md-8">
    		<button type="button" class="btn btn-rounder depositType" value="card">카드결제</button>&nbsp;
    		<button type="button" class="btn btn-rounder depositType" value="direct">무통장입금</button>
   			<input type="hidden" id="depositType" name="depositType"/>
   		</div>
   	</div>
  </div>
  </form>
  <div class="deposit-footer text-center">
      <button type="button" class="btn btn-default" onClick="goPay();">확인</button>
      <button type="button" class="btn btn-default" onClick="javascript:self.close();">취소</button>
  </div>
  
  <form name="insertDepositFrm">
  	<input type="hidden" name="idx"/>
  	<input type="hidden" name="realDeposit"/>
  	<input type="hidden" name="depositType"/>
  </form>
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