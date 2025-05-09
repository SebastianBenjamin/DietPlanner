package org.controllers;

import jakarta.servlet.http.HttpServletRequest;
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

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;



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
    public String selectDiet(@RequestParam(name ="dietId",required=true,defaultValue = "null")int dietId, Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }else{
           Diet diet=s.get(Diet.class, dietId);
            session.setAttribute("alert","Diet selection successful ! ");
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
            session.setAttribute("alert","Diet cancellation successful ! ");

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
            diet.setCreatedBy(user.getUserId().toString());
            if(request.getParameter("exercise").equals("1")){
            diet.setExercise(true);
            }else diet.setExercise(false);
            diet.setWaterIntake(Integer.parseInt(request.getParameter("waterIntake")));
            diet.setTotalMeals(Integer.parseInt(request.getParameter("totalMeals")));
            session.setAttribute("alert","Diet creation successful ! ");

            s.save(diet);
            user.setDiet(diet);
            s.update(user);

            tx.commit();
            session.setAttribute("user", user);

            return "dashboard";
        }
    }
    @PostMapping("/updateDiet")
    public String updateDiet(HttpServletRequest request, Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            String dietName = request.getParameter("dietName");
            String dietType = request.getParameter("dietType");
            String totalMeals = request.getParameter("totalMeals");
            String waterIntake = request.getParameter("waterIntake");
            String dietPreference = request.getParameter("dietPreference");
            String exercise = request.getParameter("exercise");
            String dietId = request.getParameter("dietId");

            Diet diet = s.get(Diet.class, Integer.parseInt(dietId));
            diet.setDietName(dietName);
            diet.setDietType(dietType);
            diet.setDietPreference(dietPreference);
            diet.setTotalMeals(Integer.parseInt(totalMeals));
            diet.setWaterIntake(Integer.parseInt(waterIntake));


            diet.setExercise("on".equals(exercise));

            Transaction tx = s.beginTransaction();
            s.update(diet);
            tx.commit();


            session.setAttribute("user", user);
            session.setAttribute("alert","Diet update successful ! ");
            return "redirect:/profile";
        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        }
    }
    @PostMapping("/deleteDiet")
    public String deleteDiet(HttpServletRequest request, Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        Transaction tx = null;
        try {
            tx = s.beginTransaction();

            int dietId = Integer.parseInt(request.getParameter("id"));
            Diet diet = s.get(Diet.class, dietId);

            if (diet != null) {
                // First, find all users using this diet and set their diet to null
                String hql = "FROM User WHERE diet.dietId = :dietId";
                List<User> usersWithThisDiet = s.createQuery(hql, User.class)
                        .setParameter("dietId", dietId)
                        .list();

                for (User u : usersWithThisDiet) {
                    u.setDiet(null);
                    s.update(u);
                }

                // Check if current user is using this diet
                if (user.getDiet() != null && user.getDiet().getDietId() == dietId) {
                    user.setDiet(null);
                    s.update(user);
                    session.setAttribute("user", user);
                }

                // Then delete the diet
                s.delete(diet);
                tx.commit();

                session.setAttribute("alert", "Diet deletion successful!");
            }

            return "redirect:/profile";
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            session.setAttribute("alert", "Error deleting diet: " + e.getMessage());
            return "redirect:/profile";
        }
    }


@PostMapping("/updateProfile")
public String updateProfile(Model model, HttpServletRequest request,HttpSession session) {
    String fullName = request.getParameter("fullName");
    String email = request.getParameter("email");
    String phone = request.getParameter("phoneNumber");
    String gender = request.getParameter("gender");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); // Use your input date format
    Date dateOfBirth = null;
    try {
        dateOfBirth = sdf.parse(request.getParameter("dateOfBirth"));
    } catch (ParseException e) {
        e.printStackTrace();
    }
    double height = Double.parseDouble(request.getParameter("height"));
    double weight = Double.parseDouble(request.getParameter("weight"));
    String dietPref = request.getParameter("dietaryPreference");

    User user = (User) session.getAttribute("user");
    if (user == null) {
        return "redirect:/login";
    }
    user.setFullName(fullName);
    user.setEmail(email);
    user.setPhoneNumber(phone);
    user.setGender(gender);
    user.setDateOfBirth(dateOfBirth);
    user.setHeight(height);
    user.setWeight(weight);
    user.setDietaryPreference(dietPref);
    Transaction tx = s.beginTransaction();
    s.update(user);
    tx.commit();
    session.setAttribute("user", user);
    session.setAttribute("alert","Update profile successful ! ");
    return "redirect:/profile";
}
@PostMapping("/changePassword")
public String changePassword(Model model, HttpSession session,HttpServletRequest request) {
    User user = (User) session.getAttribute("user");
    if (user == null) {
        return "redirect:/login";
    }
    else{
        String password = request.getParameter("confirmPassword");
        user.setPassword(password);
        Transaction tx = s.beginTransaction();
        s.update(user);
        tx.commit();
        session.setAttribute("user", user);
        session.setAttribute("alert","Password changed successfully ! ");
        return "redirect:/profile";
    }
}


    // Water tracking endpoints
    @GetMapping("/waterLog")
    public String waterLogPage(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        Services services = new Services();
        LocalDateTime today = LocalDateTime.now();
        int todayWaterIntake = services.getTotalWaterIntake(user, today);


        int dailyGoal = 2000;
        if (user.getDiet() != null && user.getDiet().getWaterIntake() > 0) {
            dailyGoal = user.getDiet().getWaterIntake() * 1000;
        }

        model.addAttribute("todayWaterIntake", todayWaterIntake);
        model.addAttribute("dailyGoal", dailyGoal);

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


    @GetMapping("/exerciseLog")
    public String exerciseLogPage(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        Services services = new Services();
        LocalDateTime today = LocalDateTime.now();
        boolean exerciseCompleted = services.getExerciseStatus(user, today);

        model.addAttribute("exerciseCompleted", exerciseCompleted);

        return "exerciseLog";
    }

    @PostMapping("/updateExercise")
    public String updateExercise(
            @RequestParam("exerciseStatus") boolean completed,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        Services services = new Services();
        services.logExercise(user, completed);

        redirectAttributes.addFlashAttribute("alert", "Exercise status updated successfully!");
        return "redirect:/exerciseLog";
    }

    // Meal tracking methods
    @GetMapping("/mealLog")
    public String mealLogPage(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        Services services = new Services();
        LocalDateTime today = LocalDateTime.now();
        boolean[] mealStatus = services.getMealStatus(user, today);

        model.addAttribute("mealStatus", mealStatus);

        return "mealLog";
    }

    @PostMapping("/updateMeal")
    public String updateMeal(
            @RequestParam("mealNumber") int mealNumber,
            @RequestParam("completed") boolean completed,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        if (mealNumber < 1 || mealNumber > 6) {
            redirectAttributes.addFlashAttribute("error", "Invalid meal number");
        } else {
            Services services = new Services();
            services.logMeal(user, mealNumber, completed);
            redirectAttributes.addFlashAttribute("alert", "Meal status updated successfully!");
        }

        return "redirect:/mealLog";
    }

}
