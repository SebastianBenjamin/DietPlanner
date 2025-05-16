package org.controllers;

import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.classFiles.Diet;
import org.classFiles.Services;
import org.classFiles.User;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;



@Controller
public class Controllerr {

    private static final Logger logger = LoggerFactory.getLogger(Controllerr.class);

    Configuration cfg = new Configuration().configure();
    SessionFactory sf = cfg.buildSessionFactory();
    Session s = sf.openSession();

@RequestMapping("/")
    public String homepage(Model model, HttpSession session) {
    if(session.getAttribute("user")!=null){
        return "dashboard";
    }else{
        return "index";
    }

    }
@RequestMapping("/dashboard")
    public String dashboard(Model model, HttpSession session) {
        User user = (User)session.getAttribute("user");
        model.addAttribute("user", user);
        session.setAttribute("user", user);
        return "dashboard";
    }
@RequestMapping("/profile")
    public String profile(Model model, HttpSession session) {
        return "profile";

    }
@RequestMapping("/logout")
public String logout(HttpSession session) {
    session.invalidate();
    return "index";
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

    @PostMapping("/resetWaterLog")
    public String resetWaterLog(HttpSession session, RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user != null) {

            Services services = new Services();
            services.resetTodayWaterLog(user);
            redirectAttributes.addFlashAttribute("alert", "Water log has been reset successfully.");
        }
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
@RequestMapping("/login")
    public String login(Model model, HttpSession session) {
    User user = (User) session.getAttribute("user");
    if (user == null) {
        return "login";
    }else{
        model.addAttribute("user", user);
        return "dashboard";
    }


}
@RequestMapping("/signup")
    public String signup(Model model, HttpSession session) {
    User user=(User) session.getAttribute("user");
    if (user == null) {
        return "signup";
    }else{
        model.addAttribute("user", user);
        session.removeAttribute("alert");
        return "dashboard";
    }
}
@PostMapping("authenticateUser")
    public String authenticateUser(Model model,HttpSession session,HttpServletRequest request) {
    String email=request.getParameter("email");
    String password=request.getParameter("password");
    if(Services.checkUserAuthentication(email,password)!=null){
        int uid=Services.checkUserAuthentication(email,password);
        User user = s.get(User.class, uid);
        session.setAttribute("user", user);
        model.addAttribute("user", user);
        session.removeAttribute("alert");
        return "dashboard";
    }else {
        session.setAttribute("alert", "No user found please register first!");
        return "redirect:/signup";
    }

}
@PostMapping("createUser")
    public String createUser(Model model,HttpSession session,HttpServletRequest request) {
    User user=new User();
    user.setFullName(request.getParameter("fullName"));
    user.setPassword(request.getParameter("password"));
    user.setEmail(request.getParameter("email"));
    user.setPhoneNumber(request.getParameter("phoneNumber"));
    user.setGender(request.getParameter("gender"));
    try {
        Date dob = new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("dateOfBirth"));
        user.setDateOfBirth(dob);
    } catch (ParseException e) {
        e.printStackTrace();
    }
    user.setHeight(Double.parseDouble(request.getParameter("height")));
    user.setWeight(Double.parseDouble(request.getParameter("weight")));
    user.setDietaryPreference(request.getParameter("dietaryPreference"));
    s.persist(user);
    model.addAttribute("user", user);
    session.setAttribute("user", user);
    session.removeAttribute("alert");
    return "dashboard";
}

    @PostMapping("/chatbot")
    @ResponseBody
    public Map<String, String> chatbotResponse(@RequestBody Map<String, String> payload,HttpSession session) {
        logger.info("Received chat request: {}", payload);
        String message = payload.get("message");
        Map<String, String> response = new HashMap<>();

        try {
            String apiKey = "AIzaSyCf8f0qtkdgxztVi_WwnkKnHHUxiudpk68";
            User userDetails = (session.getAttribute("user") != null) ? (User) session.getAttribute("user") : null;
            String userInfo = (userDetails != null)
                    ? String.format(
                    "User Details: [Name: %s, Email: %s, Phone: %s, Gender: %s, Date of Birth: %s, Height: %.2f, Weight: %.2f, Dietary Preference: %s, Current Streak: %d, Last Streak Update: %s, Log Date: %s]",
                    userDetails.getFullName(),
                    userDetails.getEmail(),
                    userDetails.getPhoneNumber() != null ? userDetails.getPhoneNumber() : "Not provided",
                    userDetails.getGender(),
                    userDetails.getDateOfBirth() != null ? userDetails.getDateOfBirth().toString() : "Not provided",
                    userDetails.getHeight() != null ? userDetails.getHeight() : 0.0,
                    userDetails.getWeight() != null ? userDetails.getWeight() : 0.0,
                    userDetails.getDietaryPreference(),
                    userDetails.getCurrentStreak(),
                    userDetails.getLastStreakUpdate() != null ? userDetails.getLastStreakUpdate().toString() : "Not provided",
                    userDetails.getLogDate() != null ? userDetails.getLogDate().toString() : "Not provided"
            )
                    : "User details not available";




            HttpClient client = HttpClient.newHttpClient();
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create("https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=" + apiKey))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString("""
                {
                    "contents": [
                        {
                            "role": "user",
                            "parts": [
                            {"text": "You are a professional nutritionist and diet planner. Answer the following question concisely: %s 
                            . also if asked to give  a diet give in format like:
                            diet name,total meals per day (max 6),diet type(balanced,low carb,low fat,high protein,
                            vegetarian),daily water intake(max 20l),dietary preference(vegetarian,non vegetarian),exercise(yes or no).User details: %s"}
                            ]
                        }
                    ],
                    "generationConfig": {
                        "temperature": 0.7,
                        "maxOutputTokens": 800
                    }
                }
                """.formatted(message, userInfo)))
                    .build();

            HttpResponse<String> apiResponse = client.send(request, HttpResponse.BodyHandlers.ofString());
            logger.info("Gemini API response status: {}", apiResponse.statusCode());
            logger.debug("Gemini API response body: {}", apiResponse.body());

            if (apiResponse.statusCode() == 200) {
                try {
                    JSONObject jsonResponse = new JSONObject(apiResponse.body());

                    if (jsonResponse.has("candidates") && jsonResponse.getJSONArray("candidates").length() > 0) {
                        JSONObject candidate = jsonResponse.getJSONArray("candidates").getJSONObject(0);

                        if (candidate.has("content") &&
                                candidate.getJSONObject("content").has("parts") &&
                                candidate.getJSONObject("content").getJSONArray("parts").length() > 0) {

                            String responseText = candidate.getJSONObject("content")
                                    .getJSONArray("parts")
                                    .getJSONObject(0)
                                    .getString("text");

                            response.put("response", responseText);
                            return response;
                        }
                    }

                    response.put("response", "API response format issue. Raw response: " + apiResponse.body().substring(0, 200) + "...");
                } catch (Exception e) {
                    logger.error("Error parsing Gemini API response: {}", e.getMessage());
                    response.put("response", "Failed to parse API response: " + e.getMessage());
                }
            } else {
                logger.error("API error response: {} - {}", apiResponse.statusCode(), apiResponse.body());
                response.put("response", "API returned error status: " + apiResponse.statusCode() +
                        ". Details: " + apiResponse.body());
            }

        } catch (Exception e) {
            logger.error("Error in chatbot request", e);
            response.put("response", "Server error: " + e.getMessage());
        }

        return response;
    }
    @GetMapping("/chat")
    public String chatPage() {
        return "chat";
    }
    @GetMapping("/favicon.ico")
    public void favicon(HttpServletResponse response) throws IOException {
        // Load favicon from resources folder (classpath)
        Resource resource = new ClassPathResource("/static/favicon.ico");

        if (resource.exists()) {
            response.setContentType("image/x-icon");
            // Set caching headers if you want (optional)
            response.setHeader("Cache-Control", "max-age=86400");

            try (ServletOutputStream out = response.getOutputStream()) {
                // Copy the file content to response output stream
                resource.getInputStream().transferTo(out);
                out.flush();
            }
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
