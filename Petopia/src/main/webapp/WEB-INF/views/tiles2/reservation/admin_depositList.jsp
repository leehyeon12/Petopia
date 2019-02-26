<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>
<style>
/* [190130] 페이지바 css 추가 */
.pagination {
    display: block;
    padding-left: 0;
    margin: 20px 0;
    border-radius: 4px;
}

.pagination a {
  color: black;
  padding: 8px 16px;
  text-decoration: none;
  transition: background-color .3s;
}

.pagination a.active_p {
  background-color: rgb(255, 110, 96);
  color: white;
  pointer-events: none;
  cursor: default;
}

/* The Modal (background) */
.modal {
  display: none;
  position: fixed;
  z-index: 1;
  padding-top: 100px;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  overflow: auto;
  background-color: rgb(0,0,0);
  background-color: rgba(0,0,0,0.4);
}

/* Modal Content */
.modal-content {
  position: relative;
  background-color: #fefefe;
  margin: auto;
  padding: 0;
  border: 1px solid #888;
  width: 40%;
  height: 70%;
  overflow: auto;
  box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2),0 6px 20px 0 rgba(0,0,0,0.19);
  -webkit-animation-name: animatetop;
  -webkit-animation-duration: 0.4s;
  animation-name: animatetop;
  animation-duration: 0.4s
}

/* Add Animation */
@-webkit-keyframes animatetop {
  from {top:-300px; opacity:0} 
  to {top:0; opacity:1}
}

@keyframes animatetop {
  from {top:-300px; opacity:0}
  to {top:0; opacity:1}
}

/* The Close Button */
.close {
  color: white;
  float: right;
  font-size: 28px;
  font-weight: bold;
}

.close:hover,
.close:focus {
  color: #000;
  text-decoration: none;
  cursor: pointer;
}

.modal-header {
  padding: 2px 16px;
  background-color: #ff6e60;
  color: white;
}

.modal-body {
	padding: 3% 10% 3% 10%;
}

.modal-footer {
  padding: 2px 16px;
  background-color: #ff6e60;
  color: white;
}

.tblrow {
	border-bottom: 1px solid gray;
	padding-top: 3%;
	padding-bottom: 3%;
}
.col1 {
	border-right: 1px solid gray;
	font-weight: bold;
}
</style>
<%-- [190126] 일반회원 예치금 목록 --%>
<script type="text/javascript">
	$(document).ready(function(){
		all("1");
		
		$("#all").click(function(){
			all("1");
		});
		
		$("#charged").click(function(){
			charged("1");
		});
		
		$("#used").click(function(){
			used("1");
		});
		
	});
	
	function numberWithCommas(x) {
	    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
	
	function all(currentShowPageNo){
		var form_data = {"currentShowPageNo":currentShowPageNo
						, "type": "-10"};
		
		$.ajax({
			url: "<%= ctxPath %>/depositHistory.pet",
			data: form_data,
			type: "GET",
			dataType: "JSON",
			success : function(json){
				var html = "";
				$.each(json, function(entryIndex, entry){
					html += "<tr><td>"+entry.deposit_UID+"</td>";
							if(entry.membertype=="1"){
								html+= "<td><span class='label label-primary' style='background-color: #ff6e60;'>일반회원("+entry.fk_idx+")</span></td>";
							}
							else if(entry.membertype=="2"){
								html+= "<td><span class='label label-default'>기업회원("+entry.fk_idx+")</span></td>";
							}
							html+="<td>"+entry.depositcoin+"</td>"+
							"<td>"+entry.deposit_date+"</td>"+
							"<td>"+entry.showDepositStatus+"</td>"+
							"<td>";
					if(entry.deposit_status=="1"){
						html += "<span class='text-center' style='text-align: center; font-size: 10pt;'>충전완료</span>";
					}
					else if(entry.deposit_status=="3"){
						html += "<span class='text-center' style='text-align: center; font-size: 10pt;'>"+entry.deposit_type+"</span>"; // [190213] 버튼 삭제하고 type으로 수정
					}
					else if(entry.deposit_status=="2"){
						html += "<span class='text-center' style='text-align: center; font-size: 10pt;'>환불완료</span>";
					}
					else if(entry.deposit_status=="-1"){
						html += "<button type='button' class='btn btn-warning' onClick='goUpdateDepositStatus("+entry.deposit_UID+");'>입금확인</button>";
					}
					else if(entry.deposit_status=="0"){
						html += "<span class='text-center' style='text-align: center; font-size: 10pt;'>사용완료</span>";
					}
					html += "</td></tr>";		
				}); // end of each
				$("#allContents").empty().html(html);
				makePageBar(currentShowPageNo, "-10");

			},
			error: function(request, status, error){
				if(request.readyState == 0 || request.status == 0) return;
				else alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}

		}); // end of ajax
	}
	
	
	function charged(currentShowPageNo){
		var form_data = {"currentShowPageNo":currentShowPageNo
						, "type": "1,2,-1"};
		
		$.ajax({
			url: "<%= ctxPath %>/depositHistory.pet",
			data: form_data,
			type: "GET",
			dataType: "JSON",
			success : function(json){
				var html = "";
				$.each(json, function(entryIndex, entry){
					html += "<tr><td>"+entry.deposit_UID+"</td>";
							if(entry.membertype=="1"){
								html+= "<td><span class='label label-primary' style='background-color: #ff6e60;'>일반회원("+entry.fk_idx+")</span></td>";
							}
							else if(entry.membertype=="2"){
								html+= "<td><span class='label label-default'>기업회원("+entry.fk_idx+")</span></td>";
							}
							html+="<td>"+entry.depositcoin+"</td>"+
							"<td>"+entry.deposit_date+"</td>"+
							"<td>";
					if(entry.deposit_status=="1"){
						html += "<span class='text-center' style='text-align: center; font-size: 10pt;'>충전완료</span>";
					}
					else if(entry.deposit_status=="3"){
						html += "<span class='text-center' style='text-align: center; font-size: 10pt;'>"+entry.deposit_type+"</span>"; // [190213] 버튼 삭제하고 type으로 수정
					}
					else if(entry.deposit_status=="2"){
						html += "<span class='text-center' style='text-align: center; font-size: 10pt;'>환불완료</span>";
					}
					else if(entry.deposit_status=="-1"){
						html += "<button type='button' class='btn btn-warning' onClick='goUpdateDepositStatus("+entry.deposit_UID+");'>입금확인</button>";
					}
					else if(entry.deposit_status=="0"){
						html += "<span class='text-center' style='text-align: center; font-size: 10pt;'>사용완료</span>";
					}
					html += "</td></tr>";		
				}); // end of each
				$("#chargedContents").empty().html(html);
				makePageBar(currentShowPageNo, "1,2,-1");

			},
			error: function(request, status, error){
				if(request.readyState == 0 || request.status == 0) return;
				else alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}

		}); // end of ajax
	}
	

	function used(currentShowPageNo){
		var form_data = {"currentShowPageNo":currentShowPageNo
						, "type": "3"};	// [190129] 타입 숫자 변경
		
		$.ajax({
			url: "<%= ctxPath %>/depositHistory.pet",
			data: form_data,
			type: "GET",
			dataType: "JSON",
			success : function(json){
				var html = "";
				$.each(json, function(entryIndex, entry){
					html += "<tr><td>"+entry.deposit_UID+"</td>";
							if(entry.membertype=="1"){
								html+= "<td><span class='label label-primary' style='background-color: #ff6e60;'>일반회원("+entry.fk_idx+")</span></td>";
							}
							else if(entry.membertype=="2"){
								html+= "<td><span class='label label-default'>기업회원("+entry.fk_idx+")</span></td>";
							}
							html+="<td>"+entry.depositcoin+"</td>"+
							"<td>"+entry.deposit_date+"</td>"+
							"<td>";
					if(entry.deposit_status=="1"){
						html += "<span class='text-center' style='text-align: center; font-size: 10pt;'>충전완료</span>";
					}
					else if(entry.deposit_status=="3"){
						html += "<span class='text-center' style='text-align: center; font-size: 10pt;'>"+entry.deposit_type+"</span>"; // [190213] 버튼 삭제하고 type으로 수정
					}
					else if(entry.deposit_status=="2"){
						html += "<span class='text-center' style='text-align: center; font-size: 10pt;'>환불완료</span>";
					}
					else if(entry.deposit_status=="-1"){
						html += "<button type='button' class='btn btn-warning' onClick='goUpdateDepositStatus("+entry.deposit_UID+");'>입금확인</button>";
					}
					else if(entry.deposit_status=="0"){
						html += "<span class='text-center' style='text-align: center; font-size: 10pt;'>사용완료</span>";
					}
					html += "</td></tr>";
				}); // end of each
				$("#usedContents").empty().html(html);
				makePageBar(currentShowPageNo, "3,0");

			},
			error: function(request, status, error){
				if(request.readyState == 0 || request.status == 0) return;
				else alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}

		}); // end of ajax
	}
	
	// [190130] 수정
	function makePageBar(currentShowPageNo, type){
		var form_data = {sizePerPage:"10",
						type: type};
		$.ajax({
			url: "<%= request.getContextPath()%>/depositHistoryPageBar.pet",
			data: form_data,
			type:"GET",
			dataType:"JSON",
			success: function(json){
				
				if(json.totalPage > 0){
					var totalPage = json.totalPage;
					var pageBarHTML = "";
					var blockSize = 10;
					
					var loop = 1; 
					
					var pageNo = Math.floor((currentShowPageNo-1)/blockSize)*blockSize+1;
					if(json.type==-10){
						if( pageNo!= 1){
							pageBarHTML += "&nbsp;<a href='javascript:all(\""+(pageNo-1)+"\");'>&laquo;</a>&nbsp;";
						}
						while(!(loop>blockSize || pageNo > totalPage)){
							if(pageNo == currentShowPageNo){
								pageBarHTML += "&nbsp;<a class='active_p'>"+pageNo+"</a>&nbsp;";
							}
							else{
								pageBarHTML += "&nbsp;<a href='javascript:all(\""+pageNo+"\");'>"+pageNo+"</a>&nbsp;";
							}
							
							loop++;
							pageNo++;
						}
						
						if( !(pageNo>totalPage)){
							pageBarHTML += "&nbsp;<a href='javascript:all(\""+pageNo+"\");'>&raquo;</a>&nbsp;";
						}
						
						$("#pageBarAll").empty().html(pageBarHTML);
					}
					else if(json.type==1){
						if(pageNo!= 1){
							pageBarHTML += "&nbsp;<a href='javascript:charged(\""+(pageNo-1)+"\");'>&laquo;</a>&nbsp;";
						}
						while(!(loop>blockSize || pageNo > totalPage)){
							if(pageNo == currentShowPageNo){
								pageBarHTML += "&nbsp;<a class='active_p'>"+pageNo+"</a>&nbsp;";
							}
							else{
								pageBarHTML += "&nbsp;<a href='javascript:charged(\""+pageNo+"\");'>"+pageNo+"</a>&nbsp;";
							}
							
							loop++;
							pageNo++;
						}
						
						if( !(pageNo>totalPage)){
							pageBarHTML += "&nbsp;<a href='javascript:charged(\""+pageNo+"\");'>&raquo;</a>&nbsp;";
						}
						
						$("#pageBarCharged").empty().html(pageBarHTML);
					}
					else if(json.type==3){
						if( pageNo!= 1){
							pageBarHTML += "&nbsp;<a href='javascript:used(\""+(pageNo-1)+"\");'>&laquo;</a>&nbsp;";
						}
						while(!(loop>blockSize || pageNo > totalPage)){
							if(pageNo == currentShowPageNo){
								pageBarHTML += "&nbsp;<a class='active_p'>"+pageNo+"</a>&nbsp;";
							}
							else{
								pageBarHTML += "&nbsp;<a href='javascript:used(\""+pageNo+"\");'>"+pageNo+"</a>&nbsp;";
							}
							
							loop++;
							pageNo++;
						}
						if( !(pageNo>totalPage)){
							pageBarHTML += "&nbsp;<a href='javascript:used(\""+pageNo+"\");'>&raquo;</a>&nbsp;";
						}
						$("#pageBarUsed").empty().html(pageBarHTML);
					}
					
				}
				else{
					if(json.type==-10){
						$("#pageBarAll").empty();
					}
					else if(json.type==1){
						$("#pageBarCharged").empty();
					}
					else if(json.type==3){
						$("#pageBarUsed").empty();
					}
					pageBarHTML = "";
				}
			},
			error: function(request, status, error){
				if(request.readyState == 0 || request.status == 0) return;
				else alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
			
		});
		
	} // end of makeCommentPageBar
	
	function goRvDetail(payment_UID){
		var form_data = {"payment_UID": payment_UID};
		
		$.ajax({
			url: "reservationDetail.pet",
			type: "GET",
			data: form_data,
			dataType: "JSON",
			success: function(json){
				$("#modal_reservation_UID").html(json.reservation_UID);
				$("#modal_biz_name").html(json.name);
				$("#modal_phone").html(json.phone);
				$("#modal_pet_type").html(json.pet_type);
				$("#modal_pet_name").html(json.pet_name);
				$("#modal_rv_type").html(json.rv_type);
				$("#modal_reservation_date").html(json.reservation_DATE);
				$("#modal_bookingdate").html(json.bookingdate);
				if(json.reservation_status=="2"){
					$("#modal_reservation_status").html("예약완료");
				}
				else if(json.reservation_status=="1"){
					$("#modal_reservation_status").html("미결제");
				}
				$("#modal_payment_date").html(json.payment_date);
				$("#modal_payment_point").html(numberWithCommas(json.payment_point)+"point");
				$("#modal_payment_pay").html(numberWithCommas(json.payment_pay)+"원");
				$("#modal_payment_total").html(numberWithCommas(json.payment_total)+"원");
			},// end of success
			error: function(request, status, error){
				if(request.readyState == 0 || request.status == 0) return;
				else alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		});// end of $.ajax
		document.getElementById('id01').style.display='block';

	}

//	#무통장입금 확인
	function goUpdateDepositStatus(deposit_UID){
		var bool = confirm("입금완료상태로 변경하시겠습니까?");
		if(bool){
			location.href="<%= ctxPath %>/goUpdateDepositStatus.pet?deposit_UID="+deposit_UID;
		}
		else {
			return false;
		}
	}
</script>	    
<div class="container" style="margin-bottom: 8%;">
<%-- [190206] 예치금 잔액 추가 --%>
	<div class="row" style="margin-top: 8%;">
		<div class="col-md-8">
	  		<h2>Member Deposit History</h2>
	  		<p>회원 예치금 내역을 확인할 수 있습니다.</p>
		</div>
	</div>
<%-- 190206 끝 --%>
<%-- [190213] 탭 이름 수정 --%>
  <ul class="nav nav-tabs">
    <li class="active"><a data-toggle="tab" id="all" href="#home">전체</a></li>
    <li><a data-toggle="tab" id="charged" href="#menu1">입금내역</a></li>
    <li><a data-toggle="tab" id="used" href="#menu2">출금내역</a></li>
  </ul>

  <div class="tab-content">
    <div id="home" class="tab-pane fade in active">
      <h3>전체 사용 내역</h3>
      	<div class="table-responsive">
      	<table class="table">
      		<thead>
      		<tr>
      			<th>NO</th>
      			<th>회원번호</th>
      			<th>금액</th>
      			<th>충전/사용일</th>
      			<th>상태</th>
      			<th>변경</th>
      		</tr>
      		</thead>
      		<tbody id="allContents">
      		</tbody>
      	</table>
      	<div id="pageBarAll" class="text-center pagination"></div>
      	</div>
    </div>
    <div id="menu1" class="tab-pane fade">
      <h3>일반회원 입금내역</h3>
      <div class="table-responsive">
      	<table class="table">
      		<thead>
      		<tr>
      			<th>NO</th>
      			<th>회원번호</th>
      			<th>금액</th>
      			<th>충전일</th>
      			<th>취소/환불</th>
      		</tr>
      		</thead>
      		<tbody id="chargedContents">
      		</tbody>
      	</table>
      	<div id="pageBarCharged" class="text-center pagination"></div>
      	</div>
    </div>
    <div id="menu2" class="tab-pane fade">
      <h3>기업회원 출금내역</h3>
      <div class="table-responsive">
      	<table class="table">
      		<thead>
      		<tr>
      			<th>NO</th>
      			<th>회원번호</th>
      			<th>금액</th>
      			<th>출금신청일</th>
      			<th>상태</th>
      		</tr>
      		</thead>
      		<tbody id="usedContents">
      		</tbody>
      	</table>
      	<div id="pageBarUsed" class="text-center pagination"></div>
      	</div>
    </div>
  </div>
</div>

<%-- [190130] 모달창, 자바스크립트 추가 --%>
<%-- [190131] 모달창 내용 변경 --%>
<div id="id01" class="modal">
  	<div class="modal-content">
	    <div class="modal-header">
	      <span onclick="document.getElementById('id01').style.display='none'" class="close" title="Close Modal">&times;</span>
	      <h2>예약 상세</h2>
	    </div>
    <div class="modal-body">
      	<div class="row tblrow">
    		<div class="col-md-3 col1">예약번호</div>
    		<div class="col-md-4" id="modal_reservation_UID"></div>
    	</div>
    	<div class="row tblrow">
    		<div class="col-md-3 col1">병원명</div>
    		<div class="col-md-4" id="modal_biz_name"></div>
    	</div>
    	<div class="row tblrow">
    		<div class="col-md-3 col1">연락처</div>
    		<div class="col-md-4" id="modal_phone"></div>
    	</div>
    	<div class="row tblrow">
    		<div class="col-md-3 col1">진료과</div>
    		<div class="col-md-4" id="modal_pet_type"></div>
    	</div>
    	<div class="row tblrow">
    		<div class="col-md-3 col1">반려동물명</div>
    		<div class="col-md-4" id="modal_pet_name"></div>
    	</div>
    	<div class="row tblrow">
    		<div class="col-md-3 col1">진료타입</div>
    		<div class="col-md-4" id="modal_rv_type"></div>
    	</div>
    	<div class="row tblrow">
    		<div class="col-md-3 col1">진료일시</div>
    		<div class="col-md-4" id="modal_reservation_date"></div>
    	</div>
    	<div class="row tblrow">
    		<div class="col-md-3 col1">예약일시</div>
    		<div class="col-md-4" id="modal_bookingdate"></div>
    	</div>
    	<div class="row tblrow">
    		<div class="col-md-3 col1">예약상태</div>
    		<div class="col-md-4" id="modal_reservation_status"></div>
    	</div>
    	<div class="row tblrow">
    		<div class="col-md-3 col1">결제일시</div>
    		<div class="col-md-4" id="modal_payment_date"></div>
    	</div>
    	<div class="row tblrow">
    		<div class="col-md-3 col1">결제포인트</div>
    		<div class="col-md-4" id="modal_payment_point"></div>
    	</div>
    	<div class="row tblrow">
    		<div class="col-md-3 col1">실 결제금액</div>
    		<div class="col-md-4" id="modal_payment_pay"></div>
    	</div>
    	<div class="row tblrow" style="border-bottom: 0px solid gray;">
    		<div class="col-md-3 col1">총 결제금액</div>
    		<div class="col-md-4" id="modal_payment_total"></div>
    	</div>
    </div>
    <div class="modal-footer">
    	<span onclick="document.getElementById('id01').style.display='none'" class="btn">close</span>
    </div>
  </div>
</div>

<script>
// Get the modal
var modal = document.getElementById('id01');

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
    if (event.target == modal) {
        modal.style.display = "none";
    }
}
</script>