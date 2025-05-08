package org.controllers;

import org.classFiles.Diet;
import org.classFiles.Services;
import org.classFiles.User;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.stereotype.Controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;


@Controller
public class Controllerr {
    Configuration cfg = new Configuration().configure();
    SessionFactory sf = cfg.buildSessionFactory();
    Session s = sf.openSession();
    Transaction tx = s.beginTransaction();
    @RequestMapping("/dashboard")
    public String dashboard(Model model, HttpSession session) {
        User user = s.get(User.class, 1);
        model.addAttribute("user", user);
        session.setAttribute("user", user);
        return "dashboard";
    }
    @GetMapping("/dietmanager")
    public String dietmanager(@RequestParam(name = "c", required = false, defaultValue = "0") int cValue,
                              Model model,
                              HttpSession session) {
        try {
            if (cValue == 0) {
                // Show diet maker page
                return "dietmaker";
            } else {
                // Verify user is logged in
                User user = (User) session.getAttribute("user");
                if (user == null) {
                    return "redirect:/login";
                }

                // Get all diets and show chooser page
                Services services = new Services();
                List<Diet> diets = services.getAllDiets();
                model.addAttribute("diets", diets);
                return "dietchooser";
            }
        } catch (Exception e) {
            model.addAttribute("error", "Failed to load diets: " + e.getMessage());
            return "error";
        }
    }
    @PostMapping("/selectDiet")
    public String selectDiet(@RequestParam(name ="dietId",required=true,defaultValue = "null")int dietId,@RequestParam(name =
    "userId",required = true,defaultValue = "null")int userId, Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }else{
           Diet diet=s.get(Diet.class, dietId);
           user.setDiet(diet);

            s.update(user);
            tx.commit();
            session.setAttribute("user", user);

            return "dashboard";
        }
    }
}
