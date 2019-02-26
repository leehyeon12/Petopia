<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
	String cxtPath = request.getContextPath();
%>

<style type="text/css">
	
	.jumbotron {
    	min-height: 450px;
	}
	
	.bg-grey {
	    background-color: #f6f6f6;
	}

	.container-fluid {
	  padding: 60px 50px;
	}
	
	.logo {
	  font-size: 200px;
	}
	
	@media screen and (max-width: 768px) {
	  .col-sm-4 {
	    text-align: center;
	    margin: 25px 0;
	  }
	}
	
	/* Add an pink color to all icons and set the font-size */
	.logo-small {
	  color: rgb(252,118,106);
	  font-size: 50px;
	}
	
	.logo {
	  color: rgb(252,118,106);
	  font-size: 200px;
	}
	
	.carousel-control.right, .carousel-control.left {
	  background-image: none;
	  color: rgb(252,118,106);
	}
	
	.carousel-indicators li {
	  border-color: rgb(252,118,106);
	}
	
	.carousel-indicators li.active {
	  background-color: rgb(252,118,106);
	}
	
	.item h4 {
	  font-size: 19px;
	  line-height: 1.375em;
	  font-weight: 400;
	  font-style: italic;
	  margin: 70px 0;
	}
	
	.item span {
	  font-style: normal;
	}
	
	.thumbnail {
	  padding: 0 0 15px 0;
	  border: 1px dotted #d9d9d9;
	  border-radius: 0;
	}
	
	.thumbnail img {
	  width: 100%;
	  margin-bottom: 10px;
	}

	.slideanim {visibility:hidden;}
	.slide {
	  /* The name of the animation */
	  animation-name: slide;
	  -webkit-animation-name: slide; 
	  /* The duration of the animation */
	  animation-duration: 1s; 
	  -webkit-animation-duration: 1s;
	  /* Make the element visible */
	  visibility: visible; 
	}
	
	/* Go from 0% to 100% opacity (see-through) and specify the percentage from when to slide in the element along the Y-axis */
	@keyframes slide {
	  0% {
	    opacity: 0;
	    transform: translateY(70%);
	  } 
	  100% {
	    opacity: 1;
	    transform: translateY(0%);
	  } 
	}
	@-webkit-keyframes slide {
	  0% {
	    opacity: 0;
	    -webkit-transform: translateY(70%);
	  } 
	  100% {
	    opacity: 1;
	    -webkit-transform: translateY(0%);
	  }
	}

	#about {
		margin-left: 10%;
	}
	
	.glyphicon-globe {
		margin-left: 30%;
	}
	
	.search  {
		margin-top: 3%;
  	}
  	
  	.list-group {
  		margin-top: 1%;
  	}
  	
  	#myList {
  		color: black;
  	}
  	

</style>

<script type="text/javascript">


	/* 아이콘 애니메이션 효과 */
	$(window).scroll(function() {
	  $(".slideanim").each(function(){
	    var pos = $(this).offset().top;
	
	    var winTop = $(window).scrollTop();
	    if (pos < winTop + 600) {
	      $(this).addClass("slide");
	    }
	  });
	});

</script>




<div id="portfolio" class="container-fluid text-center">
  <h2>SERVICES</h2>
  <h4>What we offer</h4>
  <div class="row text-center">
    <div class="col-sm-4">
      <div class="thumbnail" onclick="javascript:location.href='<%= cxtPath %>/chat.pet'">
        <img src="<%= cxtPath %>/resources/img/homeheader/catkissing.jpg" alt="Paris">
        <p><strong>수의사 상담</strong></p>
        <p>실시간 수의사 채팅 서비스를 제공합니다.</p>
      </div>
    </div>
    <div class="col-sm-4">
      <div class="thumbnail" onclick="javascript:location.href='<%= cxtPath %>/consultList.pet'">
        <img src="<%= cxtPath %>/resources/img/homeheader/sleepingcat.jpg" alt="New York">
        <p><strong>화상진료</strong></p>
        <p>간단한 외상의 경우 화상진료가 가능합니다.</p>
      </div>
    </div>
    <div class="col-sm-4">
      <div class="thumbnail" onclick="javascript:location.href='<%= cxtPath %>/careCalendar.pet'">
        <img src="<%= cxtPath %>/resources/img/homeheader/cutecat.jpg" alt="San Francisco">
        <p><strong>반려동물 케어수첩</strong></p>
        <p>당신의 반려동물에 대한 모든 정보를 담으세요.</p>
      </div>
    </div>
	</div>
</div>



<!-- Container (About Section) -->
<div id="about" class="container-fluid">
  <div class="row">
    <div class="col-sm-8">
      <h2>반려동물과 사람이 행복하게 공존하는 세상을 만듭니다.</h2><br>
      <h4>반려동물 케어 서비스, 실시간 수의사 상담서비스, 그리고 보호자와 반려동물 교육까지 펫토피아는 반려동물과의 행복한 공존을 위한 다양한 방식을 고민합니다.</h4><br>
      <p>반려동물 케어 서비스, 실시간 수의사 상담서비스, 그리고 보호자와 반려동물 교육까지 펫토피아는 반려동물과의 행복한 공존을 위한 다양한 방식을 고민합니다.반려동물 케어 서비스, 실시간 수의사 상담서비스, 그리고 보호자와 반려동물 교육까지 펫토피아는 반려동물과의 행복한 공존을 위한 다양한 방식을 고민합니다.반려동물 케어 서비스, 실시간 수의사 상담서비스, 그리고 보호자와 반려동물 교육까지 펫토피아는 반려동물과의 행복한 공존을 위한 다양한 방식을 고민합니다.반려동물 케어 서비스, 실시간 수의사 상담서비스, 그리고 보호자와 반려동물 교육까지 펫토피아는 반려동물과의 행복한 공존을 위한 다양한 방식을 고민합니다.</p>
    </div>
    <div class="col-sm-4">
      <span class="glyphicon glyphicon-signal logo slideanim"></span>
    </div>
  </div>
</div>


<!-- Container (Services Section) -->
<div id="services" class="container-fluid text-center bg-grey">
  <h2>MORE SERVICES</h2>
  <h4>Everything you care about</h4>
  <br>
  <div class="row">
  	<div class="col-sm-4">
      <span class="glyphicon glyphicon-search logo-small slideanim" onclick="javascript:location.href='<%= cxtPath %>/search.pet'"></span>
      <h4>SEARCH</h4>
      <p>동물병원/약국 맞춤 추천 서비스를 제공합니다.</p>
    </div>
    <div class="col-sm-4">
      <span class="glyphicon glyphicon-pencil logo-small slideanim" onclick="javascript:location.href='<%= cxtPath %>/allReviewList.pet'"></span>
      <h4>REVIEW</h4>
      <p>동물병원/약국을 실제로 이용하신 분들의 후기를 확인해보세요.</p>
    </div>
    <div class="col-sm-4">
      <span class="glyphicon glyphicon-facetime-video logo-small slideanim" onclick="javascript:location.href='<%= cxtPath %>/chat.pet'"></span>
      <h4>CHATTING</h4>
      <p>수의사와 상담을 진행해보세요.</p>
    </div>
  </div>
  <br><br>
  <div class="row">
    <div class="col-sm-4">
      <span class="glyphicon glyphicon-bell logo-small slideanim"></span>
      <h4>ALARM</h4>
      <p>진료예약이 다가올때 미리 알려드려요.</p>
    </div>
    <div class="col-sm-4">
      <span class="glyphicon glyphicon-usd logo-small slideanim"></span>
      <h4>PAYMENT</h4>
      <p>병원 진료 예약/결제도 가능합니다.</p>
    </div>
    <div class="col-sm-4">
      <span class="glyphicon glyphicon-heart logo-small slideanim"></span>
      <h4>LOVE</h4>
      <p>모든 기능에 반려동물에 대한 사랑을 담았습니다.</p>
    </div>
  </div>
</div>


<!-- Container (review section) -->
<div class="container-fluid text-center">
  <h2>100% 리얼 고객님의 병원이용후기</h2>
  <div id="myCarousel" class="carousel slide text-center" data-ride="carousel">
    <!-- Indicators -->
    <ol class="carousel-indicators">
      <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
      <li data-target="#myCarousel" data-slide-to="1"></li>
      <li data-target="#myCarousel" data-slide-to="2"></li>
    </ol>

    <!-- Wrapper for slides -->
    <div class="carousel-inner" role="listbox">
      <div class="item active">
        <h4>"대전 케나인 동물병원 의사선생님 정말 친절하시고 카운터 간호사 언니도 참 친절하셨어요."<br><span>콩이맘</span></h4>
      </div>
      <div class="item">
        <h4>"그냥 최고! 말이 필요 없습니다. "<br><span>초코맘</span></h4>
      </div>
      <div class="item">
        <h4>"깨끗한 시설이 참 마음에 들었어요. "<br><span>별이맘</span></h4>
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


<!-- Container (Contact Section) -->
<div id="contact" class="container-fluid bg-grey">
  <h2 class="text-center">제휴사를 찾습니다</h2>
  <div class="row">
    <div class="col-sm-5" id="ctact-text" align="center">
      <p>펫토피아와 함께 성장할 동물병원/약국을 찾습니다.</p>
      <p><span class="glyphicon glyphicon-map-marker"></span> 서울특별시 중구 남대문로 120 대일빌딩 2F</p>
      <p><span class="glyphicon glyphicon-phone"></span> +00 1515151515</p>
      <p><span class="glyphicon glyphicon-envelope"></span> myemail@something.com</p>
    </div>
    <div class="col-sm-7">
      <div class="row">
        <div class="col-sm-6 form-group">
          <input class="form-control" id="name" name="name" placeholder="Name" type="text" required>
        </div>
        <div class="col-sm-6 form-group">
          <input class="form-control" id="email" name="email" placeholder="Email" type="email" required>
        </div>
      </div>
      <textarea class="form-control" id="comments" name="comments" placeholder="Comment" rows="5"></textarea><br>
      <div class="row">
        <div class="col-sm-12 form-group">
          <button class="btn btn-default pull-right" type="submit">Send</button>
        </div>
      </div>
    </div>
  </div>
</div>
