<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script type="text/javascript">
	if("${msg != ''}") {
		alert("${msg}");
	}
	if("${loc != ''}") {
		location.href = "${loc}";
	}
	
	if("${script != ''}") {
		${script}
	}
	
	if("${script1 != ''}") {
		${script1}
	}
</script>