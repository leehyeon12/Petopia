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


/* [190131] 모달 css 추가 */
/* The Modal (background) */
.modal {
  display: none; /* Hidden by default */
  position: fixed; /* Stay in place */
  z-index: 1; /* Sit on top */
  padding-top: 100px; /* Location of the box */
  left: 0;
  top: 0;
  width: 100%; /* Full width */
  height: 100%; /* Full height */
  overflow: auto; /* Enable scroll if needed */
  background-color: rgb(0,0,0); /* Fallback color */
  background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
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
		// [190208] 변수로 수정
		var sumDeposit = ${sumDeposit};
		var sumPoint = ${sumPoint};
		$("#sumDeposit").text(numberWithCommas(sumDeposit));
		$("#sumPoint").text(numberWithCommas(sumPoint));
		
		all("1");
		
		$("#all").click(function(){
			all("1");
		});
		
		$("#charged").click(function(){
			charged("1");
		});
		
		$("#used").click(function(){
			used("1");	// [190129] 함수 수정
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
					html += "<tr><td>"+entry.deposit_UID+"</td>"+
							"<td>"+entry.depositcoin+"</td>"+
							"<td>"+entry.deposit_date+"</td>"+
							"<td>"+entry.showDepositStatus+"</td>"+
							"<td>";
					if(entry.deposit_status=="1"){
						html += "<button type='button' class='btn btn-danger' onClick='goCancleDeposit("+entry.deposit_UID+");'>충전취소</button>";
					}
					else if(entry.deposit_status=="0"){ // [190129] 상태 숫자 변경
						html += "<button type='button' class='btn btn-default' onClick='goRvDetail("+entry.fk_payment_UID+");'>예약상세</button>";
					}
					else if(entry.deposit_status=="2"){	// [190129] 상태 숫자 변경
						html += "<span style='text-align: center;'>차액환불</span>";
					}
					else if(entry.deposit_status=="-1"){ // [190129] 상태 숫자 변경 // [190211] 변경
						html += "<button type='button' class='btn btn-warning' onClick='showDirectAccountView("+entry.deposit_UID+");'>입금정보</button>";
					}
					else if(entry.deposit_status=="3"){
						html += "<span style='text-align: center;'>출금완료</span>";
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
					html += "<tr><td>"+entry.deposit_UID+"</td>"+
							"<td>"+entry.depositcoin+"</td>"+
							"<td>"+entry.deposit_date+"</td>"+
							"<td>";
					if(entry.deposit_status=="1"){
						html += "<button type='button' class='btn btn-danger' onClick='goCancleDeposit("+entry.deposit_UID+");'>충전취소</button>";
					}
					else if(entry.deposit_status=="2"){
						html += "<span style='text-align: center;'>환불(예치금차액)</span>";
					}
					else if(entry.deposit_status=="-1"){
						html += "<button type='button' class='btn btn-warning' onClick='showDirectAccountView("+entry.deposit_UID+");'>입금정보</button>";
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
						, "type": "3,0"};	// [190129] 타입 숫자 변경
		
		$.ajax({
			url: "<%= ctxPath %>/depositHistory.pet",
			data: form_data,
			type: "GET",
			dataType: "JSON",
			success : function(json){
				var html = "";
				$.each(json, function(entryIndex, entry){
					html += "<tr><td>"+entry.deposit_UID+"</td>"+
							"<td>"+entry.depositcoin+"</td>"+
							"<td>"+entry.deposit_date+"</td>"+
							"<td>";
							if(entry.deposit_status=="0"){
								html += "<button type='button' class='btn btn-default' onClick='goRvDetail("+entry.fk_payment_UID+")'>예약상세</button>";
							}
							else if(entry.deposit_status=="3"){
								html += "<span style='text-align: center;'>출금완료</span>";
							}
							"</td></tr>";		
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
				$("#modal_reservation_date").html(json.reservation_DATE);	// [190131] reservation_date -> reservation_DATE
				$("#modal_bookingdate").html(json.bookingdate);
				if(json.reservation_status=="2"){
					$("#modal_reservation_status").html("예약완료");
				}
				else if(json.reservation_status=="1"){
					$("#modal_reservation_status").html("미결제");
				}
				$("#modal_payment_date").html(json.payment_date);
				$("#modal_payment_point").html(numberWithCommas(json.payment_point)+"point");	//[190131] 금액타입 콤마 찍기
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
	
//	[190208] 예치금충전하기
	function goChargeDeposit(idx){
		var url = "chargeDeposit.pet?idx="+idx;
		window.open(url, "예치금 충전하기", "left=350px, top=100px, width=650px, height=570px");
	}
	
//	[190211] 무통장입금 계좌정보 조회하기
	function showDirectAccountView(deposit_UID){
		var form_data ={"deposit_UID":deposit_UID};
		
		$.ajax({
			url: "selectDirectAccountView.pet",
			type: "GET",
			data: form_data,
			dataType: "JSON",
			success: function(json){
				$("#modal_deposit_account").html("신한은행 "+json.deposit_account);
				$("#modal_deposit_date").html(json.deposit_date);
				$("#modal_depositcoin").html(numberWithCommas(json.depositcoin)+"원");
			},// end of success
			error: function(request, status, error){
				if(request.readyState == 0 || request.status == 0) return;
				else alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		});// end of $.ajax
		document.getElementById('id02').style.display='block';
	}
	function goExcelDownload(){
		var frm = document.excelForm;
		frm.submit();
	}
	function goExcelUpload(idx){
		var url = "<%=ctxPath%>/excelUploadCare.pet?idx="+idx;
		window.open(url, "엑셀파일 업로드", "left=350px, top=100px, width=650px, height=570px");
	}
</script>	    
<div class="container" style="margin-bottom: 8%;">
<%-- [190206] 예치금 잔액 추가 --%>
	<div class="row" style="margin-top: 8%;">
		<div class="col-md-3">
	  		<h2>Deposit History</h2>
	  		<p>예치금 사용내역을 확인할 수 있습니다.</p>
		</div>
		<div class="col-md-9 text-right" style="margin-top: 5%;">
			<span style="font-weight: bold; font-size: 15px;">포인트: <span id="sumPoint"></span>point</span>&nbsp;/&nbsp;
			<span style="font-weight: bold; font-size: 15px;">예치금 잔액: <span id="sumDeposit"></span>원</span>&nbsp;&nbsp;
			<button type="button" class="btn btn-rounder btnmenu" onClick="goChargeDeposit(${sessionScope.loginuser.idx})">예치금충전</button>
		</div>
		<div>
		  <form id="excelForm" name="excelForm" method="post" action="<%= ctxPath %>/ExcelPoi.pet">
		    <input type="text" name="fileName" />
		    <input type="hidden" name="type" value="deposit"/>
		    <input type="hidden" name="idx" value="${sessionScope.loginuser.idx}"/>
		    <button type="button" class="btn btn-default" onClick="goExcelDownload();">xls파일로 받기</button>
		  </form>
		</div>
		<%-- <div>
			<a href="<%= request.getContextPath() %>/downCareFile.pet">양식다운로드</a>
		    <button type="button" class="btn btn-default" onClick="goExcelUpload(${sessionScope.loginuser.idx});">xls파일 업로드</button>
		</div> --%>
	</div>
<%-- 190206 끝 --%>
  <ul class="nav nav-tabs">
    <li class="active"><a data-toggle="tab" id="all" href="#home">전체</a></li>
    <li><a data-toggle="tab" id="charged" href="#menu1">충전내역</a></li>
    <li><a data-toggle="tab" id="used" href="#menu2">사용내역</a></li>
  </ul>

  <div class="tab-content">
    <div id="home" class="tab-pane fade in active">
      <h3>전체 사용 내역</h3>
      	<div class="table-responsive">
      	<table class="table">
      		<thead>
      		<tr>
      			<th>NO</th>
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
      <h3>충전내역</h3>
      <div class="table-responsive">
      	<table class="table">
      		<thead>
      		<tr>
      			<th>NO</th>
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
      <h3>사용내역</h3>
      <div class="table-responsive">
      	<table class="table">
      		<thead>
      		<tr>
      			<th>NO</th>
      			<th>금액</th>
      			<th>사용일</th>
      			<th>예약상태</th>
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
    		<div class="col-md-8" id="modal_biz_name"></div>
    	</div>
    	<div class="row tblrow">
    		<div class="col-md-3 col1">연락처</div>
    		<div class="col-md-8" id="modal_phone"></div>
    	</div>
    	<div class="row tblrow">
    		<div class="col-md-3 col1">진료과</div>
    		<div class="col-md-8" id="modal_pet_type"></div>
    	</div>
    	<div class="row tblrow">
    		<div class="col-md-3 col1">반려동물명</div>
    		<div class="col-md-8" id="modal_pet_name"></div>
    	</div>
    	<div class="row tblrow">
    		<div class="col-md-3 col1">진료타입</div>
    		<div class="col-md-8" id="modal_rv_type"></div>
    	</div>
    	<div class="row tblrow">
    		<div class="col-md-3 col1">진료일시</div>
    		<div class="col-md-8" id="modal_reservation_date"></div>
    	</div>
    	<div class="row tblrow">
    		<div class="col-md-3 col1">예약일시</div>
    		<div class="col-md-8" id="modal_bookingdate"></div>
    	</div>
    	<div class="row tblrow">
    		<div class="col-md-3 col1">예약상태</div>
    		<div class="col-md-8" id="modal_reservation_status"></div>
    	</div>
    	<div class="row tblrow">
    		<div class="col-md-3 col1">결제일시</div>
    		<div class="col-md-8" id="modal_payment_date"></div>
    	</div>
    	<div class="row tblrow">
    		<div class="col-md-3 col1">결제포인트</div>
    		<div class="col-md-8" id="modal_payment_point"></div>
    	</div>
    	<div class="row tblrow">
    		<div class="col-md-3 col1">실 결제금액</div>
    		<div class="col-md-8" id="modal_payment_pay"></div>
    	</div>
    	<div class="row tblrow" style="border-bottom: 0px solid gray;">
    		<div class="col-md-3 col1">총 결제금액</div>
    		<div class="col-md-8" id="modal_payment_total"></div>
    	</div>
    </div>
    <div class="modal-footer">
    	<span onclick="document.getElementById('id01').style.display='none'" class="btn">close</span>
    </div>
  </div>
</div>


<%-- [190211] 모달 추가 --%>
<div id="id02" class="modal">
  	<div class="modal-content" style="height: 42.4%; width: 35%;">
	    <div class="modal-header">
	      <span onclick="document.getElementById('id02').style.display='none'" class="close" title="Close Modal">&times;</span>
	      <h2>무통장입금 정보</h2>
	    </div>
    <div class="modal-body">
      	<div class="row tblrow text-center">
    		<h3><span id="modal_deposit_date"></span>까지 입금 바랍니다.</h3>
    	</div>
    	<div class="row tblrow">
    		<div class="col-md-3 col1">계좌정보</div>
    		<div class="col-md-8" id="modal_deposit_account"></div>
    	</div>
    	<div class="row tblrow">
    		<div class="col-md-3 col1">입금예정금액</div>
    		<div class="col-md-8" id="modal_depositcoin"></div>
    	</div>
    </div>
    <div class="modal-footer">
    	<span onclick="document.getElementById('id02').style.display='none'" class="btn">close</span>
    </div>
  </div>
</div>
<script>
// Get the modal
var modal = document.getElementById('id01');
var modal2 = document.getElementById('id02');

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
    if (event.target == modal) {
        modal.style.display = "none";
    }
    else if (event.target == modal2) {
        modal2.style.display = "none";
    }
}
</script>