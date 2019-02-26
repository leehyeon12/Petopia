<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<style type="text/css">
	.joinSelectDiv {
		height: 400px;
		padding: 1%;
	}
	
	.joinSelect {
		background-color: #d9d9d9;
		height: 100%;
		padding-top: 150px;
	}
	
	.changColor {
		background-color: rgb(252, 118, 106);
	}
	
	.joinChangeDiv {
		height: 200px;
		padding: 1%;
	}
	
	.joinChange {
		background-color: #d9d9d9;
		height: 100%;
		padding-top: 40px;
	}
</style>

<script type="text/javascript">
	
	$(document).ready(function(){
		
		$(".joinSelect").hover(function(){
				$(this).addClass("changColor");
			}, function(){
				$(this).removeClass("changColor");
		}); // $(".joinSelect").hover();
		
		if($(window).width() < 753) {
	    	$('.joinSelectDiv').addClass("joinChangeDiv");
	    	$('.joinSelect').addClass("joinChange");
		}
	    
		$(window).resize(function() { 
			//alert($(window).width());
			if($(window).width() < 753) {
		    	$('.joinSelectDiv').addClass("joinChangeDiv");
		    	$('.joinSelect').addClass("joinChange");
			} else if($(window).width() >= 753) {
				$('.joinSelectDiv').removeClass("joinChangeDiv");
		    	$('.joinSelect').removeClass("joinChange");
			}
	    }); 
		
		$(".joinChange").hover(function(){
				$(this).addClass("changColor");
			}, function(){
				$(this).removeClass("changColor");
		}); // $(".joinSelect").hover();
		
	}); // end of $(document).ready()
	
</script>

<div class="col-sm-12" style="margin-top: 10%; margin-bottom: 10%">
	<div class="col-sm-offset-2 col-sm-8" style="background-color: #f2f2f2"> <!-- 색 : rgb(252, 118, 106) -->
		<div class="col-sm-12" align="center">
			<h2>가입하기</h2>
		</div>
		
		<div class="col-sm-12" style="margin-bottom: 20px;">
			<div class="col-sm-offset-2 col-sm-8">
				<div class="col-sm-6 joinSelectDiv" align="center" onclick="javascript:location.href='<%=request.getContextPath()%>/joinBizMember.pet'">
					<div class="joinSelect">
						<div class="row">
							<img src="<%=request.getContextPath() %>/resources/img/memberIcon/hospital.png">
							<img src="<%=request.getContextPath() %>/resources/img/memberIcon/drugstore.png">
						</div>
						
						<div class="row">
							<h4 style="color: white; font-weight: bolder;">병원/약국 회원</h4>
							<h4 style="color: white; font-weight: bolder;">(기업회원)</h4>
						</div>
					</div>
				</div>
				
				<div class="col-sm-6 joinSelectDiv" align="center" onclick="javascript:location.href='<%=request.getContextPath()%>/joinMember.pet'">
					<div class="joinSelect">
						<img src="<%=request.getContextPath() %>/resources/img/memberIcon/pet.png">
						<h4 style="color: white; font-weight: bolder;">일반 회원</h4>
					</div>
				</div>
			</div>
		</div>
		
	</div>
</div>