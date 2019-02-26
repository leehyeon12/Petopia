package com.final2.petopia.aop;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.final2.petopia.model.MemberVO;

@Component
public class LoginCheckInterceptor extends HandlerInterceptorAdapter{
	 
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception{
        boolean result = false;
        String webRoot = request.getContextPath();
         
        try {
         MemberVO loginuser = (MemberVO) request.getSession().getAttribute("loginuser");
            if(loginuser == null ){
                if(isAjaxRequest(request)){
                    response.sendError(400);
                    return false;
                }else{
                    response.sendRedirect(webRoot + "/login.pet");  
                    result =  false;
                }
            }else{
                result =  true;
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println(e.getMessage());
            return false;
        }
        return result;
    }
     
    private boolean isAjaxRequest(HttpServletRequest req) {
        String header = req.getHeader("AJAX");
        if ("true".equals(header)){
         return true;
        }else{
         return false;
        }
    }
}