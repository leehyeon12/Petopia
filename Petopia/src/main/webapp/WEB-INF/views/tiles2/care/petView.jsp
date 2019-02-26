<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.highcharts.com/modules/exporting.js"></script>
<script src="https://code.highcharts.com/modules/export-data.js"></script>


<style type="text/css">
   
   .pointer {
      cursor: pointer;
   }
   
   .in {
      display: inline-block;
   }
   
   .out {
      width: 100%;
      text-align: center;
   }
   
   ul {
      padding: 0px;
   }
   
   .profileimg {
      border-radius: 100%;
      width: 150px;
      height: 150px;
   }
   
   .alarm {
      background-color: #f2f2f2;
      height: 50px;
      padding: 7px;
      margin-top: 3%;
      text-align: left;
   }
   
</style>

<script type="text/javascript">

   $(document).ready(function () {
      getWeight();
      getChart(); 
      initButton();
      initDatePick();
   }); // end of ready()-------------------------------------------
   
   function initDatePick(){
      $("input.date").datepicker({
            dateFormat:"yy/mm/dd",
            dayNamesMin:["일", "월", "화", "수", "목", "금", "토"],
            monthNames:["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
            onSelect:function( d ){
                var arr = d.split("/");
               $("#datepicker").text(arr[0]);
               $("#datepicker").append(arr[1]);
               $("#datepicker").append(arr[2]);
            }            
       });
   }
   
   function initButton(){
       
      // 체중 Ajax 
      $("#changepet").click(function() {
         
         getWeight();
         getChart();
         initButton();
         
      });
      
      // 체중 추가 버튼
      $("#addWeight").click(function() {
         updateWeight();
         
        /*  var url = "addWeight.pet?pet_UID=${pet_UID}";            
         window.open(url, "addWeight"
                      , "left=500px, top=100px, width=500px, height=230px"); */
         
      });
      
   } // end of function initButton()-------------------------------------------
   
   function getWeight() {
      
      var form_data = {pet_UID : "${pet_UID}"};
      
       $.ajax({
         
         url : "getWeight.pet",   
         type : "GET",                               
         data : form_data,   
         dataType : "JSON",
         success : function(json) {
            $("#table_weight").empty();
            $("#graph").empty();
         
            var html = "<form name='weightFrm' id='weightFrm'>"
                  + "<input type='hidden' name='pet_UID' value='${pet_UID}'>"
                  + "<table class='table table-hover'>"
                   + "   <thead>"
                   + "      <tr>"      
                   + "         <th>기록일</th>"
                   + "         <th>현재체중</th>"
                   + "         <th>목표체중</th>"
                   + "      </tr>"
                   + "   </thead>"
                   + "   <tbody>";
                   
            if(json == '') {
               html += "      <tr>"
                    + "         <td colspan='3' align='center'>기록이 없습니다.</td>"
                    + "      </tr>";
            }
                  
            var i = 0;
               
            $.each(json, function(entryIndex, entry) {
               
               i++;
               
                  html += "      <tr>"
                       + "         <td>" + entry.PETWEIGHT_DATE + "</td>"
                       + "         <td>" + entry.PETWEIGHT_PAST + "kg </td>"
                       + "         <td>" + entry.PETWEIGHT_TARGETED+ "kg </td>"
                       + "      </tr>";      
               
               if(i == 1){
                  $("#weight_targeted").html(entry.PETWEIGHT_TARGETED);   
               }        
                       
            });
            
               html += "   <tr>"
                     + "         <td><input type='date' id='datepicker' class='form-control input-md' name='petweight_date' autocomplete='off' /></td>"
                     + "         <td><input type='text' id='weight' name='petweight_past' /> kg</td>"
                     + "         <td><input type='text' id='weight_targerted' name='petweight_targeted' /> kg</td>"
                    + "      </tr>"
                     + "   </tbody>"
                    + "</table></form>";
                 
            $("#table_weight").append(html);

            var resultArr1 = [];
            var resultArr2 = [];
            var resultArr3 = [];
            
            if(json != ''){
            
               for(var i=(json.length-1); i>=0; i--){
                    var obj1 = Number(json[i].PETWEIGHT_PAST);   // 퍼센트 계산을 위해 반드시 Number로 변환
                    var obj2 = Number(json[i].PETWEIGHT_TARGETED);
                    var obj3 = json[i].PETWEIGHT_DATE;
                    
                    console.log(i+":"+obj1 +", "+ obj2+", "+obj3); 
                    
                    resultArr1.push(obj1);
                    resultArr2.push(obj2);
                    resultArr3.push(obj3);
                 }
            
               // Highcharts 시작 //
               Highcharts.chart('graph', {
                   chart: {
                       type: 'line'
                   },
                   title: {
                       text: '체중 그래프'
                   },
/*
                    subtitle: {
                       text: 'Source: WorldClimate.com'
                   }, 
*/                
                   xAxis: {
                       categories: resultArr3 
                   }, 
/*                  
                   yAxis: {
                       title: {
                           text: 'Temperature (°C)'
                       }
                   },
*/
                   plotOptions: {
                       line: {
                           dataLabels: {
                               enabled: true
                           },
                           enableMouseTracking: false
                       }
                   },
                   series: [{
                       name: '현재 체중',
                       data: resultArr1
                   }, { 
                       name: '목표 체중',
                       data: resultArr2 
                   }]
                
               });
               // Highcharts 끝 //
               
            }

         },
         error: function(request, status, error){
            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
         }      
      
       });
      
   } // end of function getWeight()-------------------------------------------
   
   function getChart() {
      
      var form_data = {pet_UID : "${pet_UID}"};
   
       $.ajax({
         
         url : "getChart.pet",   
         type : "GET",                               
         data : form_data,   
         dataType : "JSON",
         success : function(json) {
            $("#table_chart").empty();
            
            var html = "<table class='table table-hover'>"
                   + "   <thead>"
                   + "      <tr>"      
                   + "         <th>No.</th>"
                   + "         <th>병원</th>"
                   + "         <th>날짜</th>"
                   + "      </tr>"
                   + "   </thead>"
                   + "   <tbody>";
            
            if(json == ''){
               html += "      <tr>"
                    + "         <td colspan='3' align='center'>기록이 없습니다.</td>"
                    + "      </tr>";
            }
                   
            $.each(json, function(entryIndex, entry) {
               html += "      <tr>"
                    + "         <td>" + entry.CHART_UID + "</td>"
                    + "         <td>" + entry.BIZ_NAME + "</td>"
                    + "         <td>" + entry.RESERVATION_DATE + "</td>"
                    + "      </tr>";      
            });
            
               html += "   </tbody>"
                    + "</table>";

            $("#table_chart").append(html);
         },
         error: function(request, status, error){
            alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
         }      
      });
      
   } // end of function getChart()-------------------------------------------
   
   function updateWeight() {
      
      var weightFrm = document.weightFrm;
      weightFrm.action = "addWeightEnd.pet"
      weightFrm.method = "POST";
      weightFrm.submit();

   }// end of function updateWeight()-------------------------------------------
   
</script>
<style type="text/css">
   #weightFrm input[type="text"]{
      width:45%;
   }
</style>

<div class="container" style="margin-top: 10px;">
   
   <div class="col-sm-12">
      <div class="row">
         <div class="out" style="margin-left: 22%;">
         
            <div class="in col-sm- col-sm-3">
               <ul style="list-style-type: none;">
               <c:if test="${petInfo.PREVIOUSPET_UID > 0}">
                  <li><span class="pointer changepet" onclick="javascript:location.href='petView.pet?pet_UID=${petInfo.PREVIOUSPET_UID}'">${petInfo.PREVIOUSPET_NAME}</span></li>
                  <li><span class="pointer changepet" onclick="javascript:location.href='petView.pet?pet_UID=${petInfo.PREVIOUSPET_UID}'"><i class="fa fa-angle-double-left" style="font-size: 30pt;"></i></span></li>
               </c:if> 
               </ul>
            </div>
            <div class="pointer in col-sm-3" onclick=window.open("careCalendar.pet?pet_UID=${pet_UID}","_self")>
               <img src="resources/img/care/${petInfo.PET_PROFILEIMG}" class="profileimg">   
               <ul style="list-style-type: none;">
                  <li>${petInfo.PET_NAME}</li>
                  <li>${petInfo.PET_BIRTHDAY}</li>
                  <li>${petInfo.PET_GENDER}</li>
                  <li>${petInfo.PET_TYPE}</li>
               </ul>
            </div>
            
            <div class="in">

            </div>
            <div class="in col-sm-3">
               <ul style="list-style-type: none;">
               <c:if test="${petInfo.NEXTPET_UID > 0}">
                  <li><span class="pointer changepet" onclick="javascript:location.href='petView.pet?pet_UID=${petInfo.NEXTPET_UID}'">${petInfo.NEXTPET_NAME}</span></li>
                  <li><span class="pointer changepet" onclick="javascript:location.href='petView.pet?pet_UID=${petInfo.NEXTPET_UID}'"><i class="fa fa-angle-double-right" style="font-size: 30pt;"></i></span></li>
               </c:if> 
               </ul>
            </div>
            
         </div>   
      </div>
   </div>
   
   <div class="col-sm-12">
      <div class="row" style="text-align: center; margin-top: 5px; margin-left: 1%;">
         <div style="margin:0 auto;">
                <button type="button" id="btnRegister" class="btn btn-rounder btnmenu">수정하기</button>
                <button type="button" class="btn btn-rounder btnmenu" style="color: white; background-color: gray;" onclick="javascript:history.back();">지우기</button>
         </div>
      </div>
   </div>
   
   <div class="col-sm-12">
      <div class="row" style="margin-top: 8%;">
         <div class="out">
            
            <div class="in col-md-4" >
            
               <div id="graph" style="min-width: 310px; height: 400px; margin: 0 auto">
               
               </div>         
                     
            </div>   
               
            <div class="in col-md-4">
            
               	현재 체중 : ${petInfo.PET_WEIGHT}kg / 목표 체중 : <span id="weight_targeted"></span> kg
            
               <div id="table_weight">
               
               </div>
               
               <div>
                  <button id="addWeight" type="button" class="btn btn-rounder btnmenu">체중 추가</button>      
               </div>   
               
            </div>
            
            <div class="in col-md-4">
            
               최근 진료 기록
               <div id="table_chart">
                  
               </div>
               
            </div>
               
         </div>
      </div>
   </div> 


</div>    