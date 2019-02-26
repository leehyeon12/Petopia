package com.final2.petopia.controller;

import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class CommonController {
	
	@RequestMapping(value="/index.pet", method= {RequestMethod.GET})
	public String index(HttpServletRequest req) {
		
		return "main/index.tiles2";
	}
	
	@RequestMapping(value="/home.pet", method= {RequestMethod.GET})
	public String home(HttpServletRequest req) {
		
		return "home/index.tiles1";
	}
	
	
}
