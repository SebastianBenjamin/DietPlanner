package org.controllers;

import jakarta.servlet.http.HttpServletRequest;
import org.classFiles.Diet;
import org.classFiles.Services;
import org.classFiles.User;
import org.classFiles.WaterLog; // Add this import
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

import java.time.LocalDateTime;
import java.util.List;


@Controller
public class Controllerr {
    Configuration cfg = new Configuration().configure();
    SessionFactory sf = cfg.buildSessionFactory();
    Session s = sf.openSession();

    @RequestMapping("/")
    public String homepage() {
        return "index";
    }
    @RequestMapping("/dashboard")
    public String dashboard(Model model, HttpSession session) {
        User user = s.get(User.class, 1);
        model.addAttribute("user", user);
        session.setAttribute("user", user);
        return "dashboard";
    }
    @RequestMapping("/profile")
    public String profile(Model model, HttpSession session) {
        return "profile";

    }
    @GetMapping("/dietmanager")
    public String dietmanager(@RequestParam(name = "c", required = false, defaultValue = "0") int cValue,
                              Model model,
                              HttpSession session) {
        try {
            if (cValue == 0) {

                return "dietmaker";
            } else {

                User user = (User) session.getAttribute("user");
                if (user == null) {
                    return "redirect:/login";
                }


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
            model.addAttribute("alert","Diet selection successful ! ");
           user.setDiet(diet);
            Transaction tx = s.beginTransaction();
            s.update(user);
            tx.commit();
            session.setAttribute("user", user);
            return "dashboard";
        }
    }
    @PostMapping("/cancelDiet")
    public String cancelDiet(@RequestParam(name =
    "userId",required = true,defaultValue = "null")int userId, Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }else{
            Transaction tx = s.beginTransaction();
           user.setDiet(null);
            s.update(user);
            tx.commit();
            session.setAttribute("user", user);
            model.addAttribute("alert","Diet cancellation successful ! ");

            return "dashboard";
        }
    }
    @PostMapping("makeDiet")
    public String makeDiet(HttpServletRequest request, Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }else{
            Transaction tx = s.beginTransaction();
            Diet diet =new Diet();
            diet.setDietName(request.getParameter("dietName"));
            diet.setDietType(request.getParameter("dietType"));
            diet.setDietPreference(request.getParameter("dietPreference"));
            if(request.getParameter("exercise").equals("1")){
            diet.setExercise(true);
            }else diet.setExercise(false);
            diet.setWaterIntake(Integer.parseInt(request.getParameter("waterIntake")));
            diet.setTotalMeals(Integer.parseInt(request.getParameter("totalMeals")));
            model.addAttribute("alert","Diet creation successful ! ");

            s.save(diet);


            user.setDiet(diet);
            s.update(user);

            tx.commit();
            session.setAttribute("user", user);

            return "dashboard";
        }
    }

//    water
@GetMapping("/waterLog")
public String waterLogPage(Model model, HttpSession session) {
    User user = (User) session.getAttribute("user");
    if (user == null) {
        return "redirect:/login";
    }

    Services services = new Services();
    LocalDateTime today = LocalDateTime.now();
    int todayWaterIntake = services.getTotalWaterIntake(user, today);

    // Get water intake goal from user's diet or use default
    int dailyGoal = 2000; // Default 2L goal
    if (user.getDiet() != null && user.getDiet().getWaterIntake() > 0) {
        dailyGoal = user.getDiet().getWaterIntake() *1000;
    }

    model.addAttribute("todayWaterIntake", todayWaterIntake);
    model.addAttribute("dailyGoal", dailyGoal);

    LocalDateTime startOfDay = today.toLocalDate().atStartOfDay();
    LocalDateTime endOfDay = startOfDay.plusDays(1).minusNanos(1);
    List<WaterLog> todayLogs = services.getUserWaterLogs(user, startOfDay, endOfDay);
    model.addAttribute("waterLogs", todayLogs);

    return "waterLog";
}

    @PostMapping("/addWaterLog")
    public String addWaterLog(@RequestParam("amountMl") int amountMl,
                              HttpSession session,
                              Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        Services services = new Services();
        services.logWaterIntake(user, amountMl);

        model.addAttribute("alert", "Water intake logged successfully!");
        return "redirect:/waterLog";
    }

    @PostMapping("/deleteWaterLog")
    public String deleteWaterLog(@RequestParam("logId") long logId,
                                 HttpSession session,
                                 Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        Services services = new Services();
        boolean deleted = services.deleteWaterLog(logId, user);

        if (deleted) {
            model.addAttribute("alert", "Water log deleted successfully!");
        } else {
            model.addAttribute("alert", "Could not delete log. Please try again.");
        }

        return "redirect:/waterLog";
    }

}
