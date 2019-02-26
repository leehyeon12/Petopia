<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>
<style>
.container {
	font-size: 20px;
}
.collapsible {
  background-color: #ff6e60;
  color: white;
  cursor: pointer;
  padding: 18px;
  width: 100%;
  border: none;
  text-align: left;
  outline: none;
  font-size: 15px;
}

.active, .collapsible:hover {
  background-color: #FFF4E0;
  color: black;
}

.content {
  padding: 0 18px;
  max-height: 0;
  overflow: hidden;
  transition: max-height 0.2s ease-out;
  background-color: #f1f1f1;
}
.noneBorderText{
  padding: 3px;
  border: none;
  font-size: 20px;
  height: 13px; 
  border-bottom: 1px solid #A6A6A6;
}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		$(".collapsible").click();	// [190130] 아코디언 펼치기 클릭액션 추가
		
		$('#tooltipbox').hide();
		$("#popOver").click(function() {
	        
	        $('#tooltipbox').toggle('display'); 
	    });
		
		$("#payUseOK").click(function(){
			var val = $("#payPoint_input").val();
			var ablePoint = ${point};
			// [190125] point 계산 제한 추가
			var total = $("#payment_total").val()*1;
			val = val*1;
			if(ablePoint<val){
				val = total;
				alert("보유포인트 이상 사용할 수 없습니다.");
			}
			$("#payPoint_span").text(numberWithCommas(val));
			$("#payment_point").val(val);
			$("#payPoint_input").val("");
			$('#tooltipbox').hide();
			
			var result = total-val;
			
			$("#payment_pay").val(result*-1);
			$("#realPayAmount").text(numberWithCommas(result));
		});
	});
	function numberWithCommas(x) {
	    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
	
	function usePoint(point){
		point = point*1;
		// [190125] point 계산 제한 추가
		var total = $("#payment_total").val()*1;
		if(point>total){
			point = total;
		}
		$("#payPoint_span").text(numberWithCommas(point));
		$("#payment_point").val(point);
		$("#payPoint_input").val("");
		$('#tooltipbox').hide();
		
		var result = total-point;
		
		$("#payment_pay").val(result*-1);
		$("#realPayAmount").text(numberWithCommas(result));
	}
	
	function goPayDepositEnd(){
		var flag = $("input:checkbox[id='ckAgree']").is(":checked");
		
		if(flag){
			var frm = document.payDepositFrm;
			frm.action = "<%=ctxPath%>/goPayDepositEnd.pet";
			frm.method = "POST";
			frm.submit();
		}
		else{
			alert("확인 동의 후 결제가 가능합니다.");
			$("#ckAgree").focus();
			return false;
		}
		
	}
</script>
<div class="container">
	<div class="text-center"  style="margin-top: 8%; margin-bottom: 5%;">
	    <h2>Payment Deposits</h2>
	    <h4>예치금 결제</h4>
	</div>
	<form name="payDepositFrm">
	<button type="button" class="collapsible btn-default">Reservation Info</button>
	<div class="content">
	  <div class="row">
	   <div class="col-md-8 col-md-offset-2" style="padding-top: 3%; padding-bottom: 5%;">
         <p>
         	<label class="label label-info"> 병원명 </label>&nbsp;&nbsp;&nbsp;
         	<span class="noneBorderText">${returnMap.biz_name}</span>
         	<input type="hidden"  name="fk_idx" value="${returnMap.fk_idx}"/>
         </p>
         <p>
         	<label class="label label-info"> 연락처 </label>&nbsp;&nbsp;&nbsp;
         	<span class="noneBorderText">${returnMap.phone}</span>
         </p>
         <p>
         	<label class="label label-info"> 진료과 </label>&nbsp;&nbsp;&nbsp;
         	<span class="noneBorderText">${returnMap.pet_type}</span>
         </p>
         <p>
         	<label class="label label-info">진료타입</label>&nbsp;
         	<span class="noneBorderText">${returnMap.rv_type}</span> <%-- [190130] rv_type으로 변경 --%>
         </p>
         <p>
         	<label class="label label-info">반려동물</label>&nbsp;
         	<span class="noneBorderText">${returnMap.pet_name}</span>
         </p>
         <p>
         	<label class="label label-info"> 진료일 </label>&nbsp;&nbsp;&nbsp;
         	<span class="noneBorderText" id="schedule_date">${returnMap.reservation_DATE}</span>
         	<input type="hidden" name="fk_reservation_UID" value="${returnMap.reservation_UID}"/>
         </p>
	          
	     </div>
	   </div>
	</div>
	<%-- col-md-8 col-md-offset-4 col-sm-8 col-sm-offset-4 col-xs-12" --%>
	<button type="button" class="collapsible btn-default">Payment Info</button>
	<div class="content">
	   <div class="row">
	   <div class="col-md-8 col-md-offset-2" style="padding-top: 3%; padding-bottom: 3%;">
         <p>
         	<label class="label label-warning"> 결제금액 </label>&nbsp;&nbsp;&nbsp;&nbsp;
         	<span class="noneBorderText">100,000</span>원
         	<input type="hidden" id="payment_total" name="payment_total" value="100000"/>
         </p>
         <p>
         	<label class="label label-warning">보유 예치금</label>&nbsp;
         	<span class="noneBorderText"><fmt:formatNumber pattern="###,###">${depositAmount}</fmt:formatNumber></span>원
         </p>
         <div style="margin-top: 2%; margin-bottom: 10px;">
         	<label class="label label-warning">보유 포인트</label>&nbsp;
         	<span class="noneBorderText" id="point"><fmt:formatNumber pattern="###,###">${point}</fmt:formatNumber></span>point&nbsp;
         	<button type="button" class="btn btn-rounder btnmenu" onClick="usePoint('${point}');">전액사용</button>&nbsp;
         	<button type="button" class="btn btn-rounder btnmenu" id="popOver">포인트 입력하기</button> &nbsp;
         	<span class="" id="tooltipbox">
         		<input type="number" id="payPoint_input" class="" value="" style="font-size: 12;"/>&nbsp;
         		<button type="button" class="btn btn-rounder btnmenu" id="payUseOK">확인</button>
        	</span>	
	     </div>
         <p style="margin-bottom: 10px;">
         	<label class="label label-warning">사용 포인트</label>&nbsp;
         	<span class="noneBorderText" id="payPoint_span">0</span>point
         	<input type="hidden" name="payment_point" id="payment_point" value="0" />	
         </p>
         <p>
         	<label class="label label-warning" style="">총 결제금액</label>&nbsp; 
         	<span class="noneBorderText" id="realPayAmount" style="">100,000</span>원
         	<input type="hidden" id="reservation_type" name="reservation_type"/>
         	<input type="hidden" id="payment_pay" name="payment_pay" value="-100000"/>
         </p>
	   </div>
	   </div>
	  <div class="row">
	  <hr style="width: 95%; border: none; border-top: 1px solid #d4d4d4;">
	  <div class="text-right col-md-offset-5 col-md-6" style="padding-bottom: 5%;"> 
	  <p><input type="checkbox" id="ckAgree" name="ckAgree" required /><label for="ckAgree">위의 예약/결제 내역에 동의하십니까?</label></p>
	  <div class="row" style="margin-top: 5%;"> 
	  	<div class="col-md-2 col-md-offset-8"> <%-- col-md-2 col-md-offset-4 col-sm-2 col-sm-offset-4 --%>
	  		<button type="button" class="btn btn-rounder btnmenu" style="padding: 5% 30% 5% 30%;" onClick="goPayDepositEnd();">확인</button>
	  	</div>
	  	<div class="col-md-2 col-sm-2">
	  	<button type="button" class="btn btn-rounder btnmenu" style="padding: 5% 30% 5% 30%; color: #ff6e60; border-color: #ff6e60; background-color: white;" onClick="javascript: location.href='<%=ctxPath%>/reservationList.pet'">취소</button>
	  	</div>
	  </div>
	</div>
	</div>
	</div>
	</form>
</div>
<script>
// 190125 collapse창 오픈하기 추가
var coll = document.getElementsByClassName("collapsible");
var i;

for (i = 0; i < coll.length; i++) {
  coll[i].addEventListener("click", function() {
    this.classList.toggle("active");
    var content = this.nextElementSibling;
    if (content.style.maxHeight){
      content.style.maxHeight = null;
    } else {
      content.style.maxHeight = content.scrollHeight + "px";
    } 
  });
}
</script>