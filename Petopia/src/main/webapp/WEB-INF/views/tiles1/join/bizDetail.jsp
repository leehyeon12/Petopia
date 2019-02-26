<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<style>
	.btn1 {
	   width: 80px;
	   font-size:15px;
	   color: white;
	   text-align: center;
	   background: grey;
	   border: solid 0px grey;
	   border-radius: 30px;
	}
</style>

    
<div align="center" style="margin: 0 auto; /* border: solid red 1px; */">
	
	<div style="width:30%; /* border: solid red 1px; */">
		<div id="myCarousel" class="carousel slide" data-ride="carousel">
		  <!-- Indicators -->
    <ol class="carousel-indicators">
      <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
      <li data-target="#myCarousel" data-slide-to="1"></li>
      <li data-target="#myCarousel" data-slide-to="2"></li>
    </ol>

    <!-- Wrapper for slides -->
    <div class="carousel-inner">
      <div class="item active">
        <img src="<%=request.getContextPath() %>/resources/img/hospitalimg/bbb.jpg" style="width: 100%;">
      </div>
    
      <div class="item">
        <img src="<%=request.getContextPath() %>/resources/img/hospitalimg/ccc.jpg" style="width: 100%;">
      </div>
    </div>
	
	  <!-- Left and right controls -->
		  <a class="left carousel-control" href="#myCarousel" role="button" data-slide="prev">
		    <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
		    <span class="sr-only">Previous</span>
		  </a>
		  <a class="right carousel-control" href="#myCarousel" role="button" data-slide="next">
		    <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
		    <span class="sr-only">Next</span>
		  </a>
		</div>
	</div>
	
	<div class="col-sm-12">
   <div class="col-sm-offset-2 col-sm-8" >
      
      <form name="joinFrm">
         <div class="col-sm-offset-2 col-sm-8 preview-image" style="margin-bottom: 15px;">
         <div class="row">
         
         	<div>
         		<span>다온 동물병원</span>
         	</div>
         	
         	<div align="left">
         		<h4>진료/처방가능 동물</h4>
         		<div style="margin-top: 20px;">
	                  <button type="button" class="btn1">강아지</button>
	                  <button type="button" class="btn1">고양이</button>
	                  <button type="button" class="btn1">소동물</button>
	                  <button type="button" class="btn1">기타</button>
                </div>
         	</div>
         	
     		<hr style="height: 1px; background-color: grey; border: none; margin-bottom: 0px;">
     		
     		<div align="left">
         		<h4>진료시간</h4>
         		<div style="margin-top: 10px;">
	                  <span>월~금</span>
	                  <span>월~금</span>
	                  <span>월~금</span>
	                  <span>월~금</span>
                </div>
         	</div>
         	
         	<div align="left" style="margin-top: 30px;">
         		<h4>연락처</h4>
         		<div style="margin-top: 5px;">
	                  <span>010-1234-5678</span> <span class="glyphicon glyphicon-earphone" style="margin-left: 10px;"></span><button style="background-color: #ff6e60;color: white;margin-left: 10px;border: 0;border-radius: 6px;">예약하기</button>
                </div>
         	</div>
         	
         	<div>
         		<img src="<%=request.getContextPath() %>/resources/img/hospitalimg/aaa.PNG" style="width: 100%; height: 90px;">
         	</div>
         	
         	<div align="left" style="margin-top: 30px;">
         		<h4>병원 특이사항</h4>
         		<div>
         			<img src="<%=request.getContextPath() %>/resources/img/hospitalimg/ddd.PNG" style="height: 90px;">
         		</div>
         	</div>
         	
         	<hr style="height: 1px; background-color: grey; border: none; margin-bottom: 0px;">
         	
         	<div align="left" style="margin-top: 20px;">
         		<h4>위치</h4>
         		<span>서울시 종로구 대일빌딩</span>
         	</div>
         	
         	<div id="map" style="width:500px;height:400px;"></div>
			<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=c6f414ecbfb91419ddf3004d68865a2e"></script>
			<script>
				var container = document.getElementById('map');
				var options = {
					center: new daum.maps.LatLng(33.450701, 126.570667),
					level: 3
				};
		
				var map = new daum.maps.Map(container, options);
			</script>
         	
         </div>
         </div>
      </form>
   </div>
</div>

</div>