package com.project.menus.service.impl;

import com.project.menus.dao.impl.MenuDao;
import com.project.menus.service.MenuService;
import com.project.menus.vo.MenuVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;


@Service("menuService")
public class MenuServiceImpl implements MenuService {

    @Autowired
    MenuDao menuDao;

    public List<MenuVo> getmenulist() {

        List<MenuVo> menulist = menuDao.getmenulist();
        return menulist;
    }
}
