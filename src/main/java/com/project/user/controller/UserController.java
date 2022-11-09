package com.project.user.controller;
import com.project.user.service.UserService;
import com.project.user.vo.UserVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;

@org.springframework.stereotype.Controller
public class UserController {

    @Autowired
    private UserService userService;

    @RequestMapping("/")
    public String index() {
        return "home";
    }

    @RequestMapping("/login")
    public String login(){
        return "users/login";
    }

    @RequestMapping("/writeForm")
    public String writeForm(){
        return "users/write";
    }
    @RequestMapping("/findUserid")
    public String findUserid(){return "users/findUserid";}

    @RequestMapping("/write")
    public String write(UserVo vo){
        this.userService.userInsert(vo);
        return "redirect:/login";
    }

    @RequestMapping("/loginProcess")
    public String loginProcess(HttpSession httpSession,
                             @RequestParam HashMap<String, Object> map){

        String returnURL = "";
        if(httpSession.getAttribute("login") != null){
            httpSession.removeAttribute("login");
        }
        UserVo vo = this.userService.login(map);

        if(vo != null) {
            httpSession.setAttribute("login", vo);
            returnURL = "boards/requestList";
        }else{
            returnURL = "redirect:/login";
        }
        return returnURL;

    }

    @RequestMapping("/getUser")
    public ModelAndView userInformation(HttpSession httpSession){
        ModelAndView mv = new ModelAndView();
        Object getUser = this.userService.getUser(httpSession.getAttribute("login"));

        mv.addObject(getUser);
        mv.setViewName("users/getUser");
        return mv;
    }

    @RequestMapping("/updateForm")
    public ModelAndView updateForm(HttpSession httpSession){
        ModelAndView mv = new ModelAndView();
        Object getUser = this.userService.getUser(httpSession.getAttribute("login"));
        mv.addObject(getUser);
        mv.setViewName("users/update");
        return mv;
    }

    @RequestMapping("/update")
    public String update (UserVo userVo){
        System.out.println(userVo);
        this.userService.userUpdate(userVo);
        return "users/getUser";
    }

    @RequestMapping("/delete")
    public String delete (HttpSession httpSession) {
        UserVo userVo = (UserVo) httpSession.getAttribute("login");
        this.userService.userDelete(userVo);

        return "users/login";
    }

    @RequestMapping(value = "/logout", method= RequestMethod.GET)
    public String logout(HttpServletRequest request){
        HttpSession httpSession = request.getSession();
        httpSession.invalidate();
        return "redirect:/login";
    }
}
