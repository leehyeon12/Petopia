<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<div class="col-sm-12">
	<div class="col-sm-offset-2 col-md-8">
		<table class="table">
			<thead style="background-color: #f2f2f2;">
				<tr>
					<th></th>
					<th>번호</th>
					<th>이름</th>
					<th>회원등급</th>
					<th>연락처</th>
					<th>대표반려동물명</th>
					<th>no show 경고횟수</th>
					<th>
						
					</th>
				</tr>
			</thead>
			
			<tbody>
				<tr>
					<td><input type="checkbox"/></td>
					<td>1</td>
					<td>홍길동</td>
					<td>1등급</td>
					<td>010-1234-5678</td>
					<td>멍멍</td>
					<td>green(5회)</td>
					<td>
						<img src="<%=request.getContextPath() %>/resources/img/memberIcon/pencil-edit-square.png">
						<img src="<%=request.getContextPath() %>/resources/img/memberIcon/equalizer-music-controller.png">
						<img src="<%=request.getContextPath() %>/resources/img/memberIcon/delete-button.png">
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>