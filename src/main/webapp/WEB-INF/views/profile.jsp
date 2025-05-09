<%@ page import="org.classFiles.User" %>
<%@ page import="org.classFiles.Diet" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page errorPage="error.jsp" %>

<%
    User user = (User) session.getAttribute("user");
    if(user == null) {
        response.sendRedirect("login");
        return;
    }

// Format date of birth
    String dobFormatted = "";
    if(user.getDateOfBirth() != null) {
        dobFormatted = new SimpleDateFormat("yyyy-MM-dd").format(user.getDateOfBirth());
    }

// Get user's current diet
    Diet currentDiet = user.getDiet();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Diet Planner - Profile</title>
    <link rel="icon" type="image/ico" href="healthy-food.png">

    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script>
        function togglePasswordVisibility(fieldId) {
            const field = document.getElementById(fieldId);
            const icon = document.getElementById(`${fieldId}-icon`);
            if (field.type === "password") {
                field.type = "text";
                icon.classList.remove("fa-eye");
                icon.classList.add("fa-eye-slash");
            } else {
                field.type = "password";
                icon.classList.remove("fa-eye-slash");
                icon.classList.add("fa-eye");
            }
        }

        function validatePassword() {
            const newPassword = document.getElementById("newPassword").value;
            const confirmPassword = document.getElementById("confirmPassword").value;
            const errorElement = document.getElementById("password-error");

            if (newPassword !== confirmPassword) {
                errorElement.textContent = "Passwords do not match";
                return false;
            }

            if (newPassword.length < 8) {
                errorElement.textContent = "Password must be at least 8 characters";
                return false;
            }

            errorElement.textContent = "";
            return true;
        }
    </script>
</head>
<body class="flex flex-col h-screen overflow-hidden bg-white text-black">
<!-- Navbar -->
<div class="h-24 border border-black flex items-center justify-between text-3xl font-bold px-6">
    <div>Diet Planner</div>
    <div class="flex gap-4">
        <a href="dashboard" class="flex items-center gap-2 hover:text-gray-600">
            <i class="fas fa-home text-lg mr-1"></i> <!-- Smaller Icon -->
            <span class="text-lg">Dashboard</span>
        </a>
        <a href="profile" class="flex items-center gap-2 hover:text-gray-600" title="Profile">
            <i class="fas fa-user-circle text-lg"></i> <!-- Smaller Icon -->
            <span class="text-lg"><%=user.getFullName()%></span> <!-- Smaller Text -->
        </a>
    </div>
</div>

<!-- Content Area -->
<div class="flex-1 overflow-y-auto p-6">
        <h3 class="text-xl font-bold mb-6">User Profile</h3>
    <div class="max-w-4xl mx-auto">

        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
            <!-- Profile Summary Card -->
            <div class="md:col-span-1 border border-gray-200 rounded-lg p-6">
                <div class="flex flex-col items-center">
                    <div class="w-32 h-32 rounded-full bg-gray-200 flex items-center justify-center mb-4">
                        <i class="fas fa-user-circle text-6xl text-gray-400"></i>
                    </div>
                    <h4 class="text-xl font-bold text-center"><%=user.getFullName()%></h4>
                    <p class="text-gray-600 text-center"><%=user.getEmail()%></p>

                    <!-- Stats -->
                    <div class="mt-6 w-full space-y-4">
                        <div class="bg-gray-100 p-4 rounded-lg">
                            <div class="flex justify-between items-center">
                                <span class="font-medium">Current Streak: <%=user.getCurrentStreak() != null ? user.getCurrentStreak() : 0%> days</span>
                            </div>
                            <% if(user.getCurrentStreak() != null && user.getCurrentStreak() > 0) { %>
                            <div class="mt-2 text-sm text-green-600">
                                <i class="fas fa-fire mr-1"></i> Keep it up!
                            </div>
                            <% } %>
                        </div>

                        <% if(currentDiet != null) { %>
                        <div class="bg-gray-100 p-4 rounded-lg">
                            <div class="flex justify-between items-center">
                                <span class="font-medium">Current Diet: <%=currentDiet.getDietName()%></span>
                            </div>
                            <div class="mt-2 text-sm">
                                <span class="block"><i class="fas fa-utensils mr-2"></i> <%=currentDiet.getTotalMeals()%> meals/day</span>
                                <span class="block mt-1"><i class="fas fa-glass-water mr-2"></i> <%=currentDiet.getWaterIntake()%> glasses</span>
                            </div>
                        </div>
                        <% } %>

                        <div class="bg-gray-100 p-4 rounded-lg">
                            <div class="flex justify-between items-center">
                                <span class="font-medium">Preference:
                                        <% if(user.getDietaryPreference() != null) { %>
                                            <%=user.getDietaryPreference().equalsIgnoreCase("veg") ? "Vegetarian" : "Non-Vegetarian"%>
                                        <% } else { %>
                                            Not specified
                                        <% } %>
                                    </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Profile Edit Form -->
            <div class="md:col-span-2">
                <div class="border border-gray-200 rounded-lg p-6 mb-6">
                    <h4 class="text-xl font-bold mb-4">Personal Information</h4>

                    <form action="/updateProfile" method="post" class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <!-- Basic Info -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Full Name</label>
                            <input type="text" name="fullName" value="<%=user.getFullName()%>" required
                                   class="w-full border border-gray-300 rounded-md py-2 px-3 focus:outline-none focus:ring-1 focus:ring-black">
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
                            <input type="email" value="<%=user.getEmail()%>" readonly name="email"
                                   class="w-full border border-gray-300 rounded-md py-2 px-3 bg-gray-100 focus:outline-none">
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Phone Number</label>
                            <input type="tel" name="phoneNumber" value="<%=user.getPhoneNumber() != null ? user.getPhoneNumber() : ""%>"
                                   class="w-full border border-gray-300 rounded-md py-2 px-3 focus:outline-none focus:ring-1 focus:ring-black">
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Gender</label>
                            <select name="gender" class="w-full border border-gray-300 rounded-md py-2 px-3 focus:outline-none focus:ring-1 focus:ring-black">
                                <option value="">Select</option>
                                <option value="male" <%=user.getGender() != null && user.getGender().equalsIgnoreCase("male") ? "selected" : ""%>>Male</option>
                                <option value="female" <%=user.getGender() != null && user.getGender().equalsIgnoreCase("female") ? "selected" : ""%>>Female</option>

                            </select>
                        </div>

                        <!-- Health Metrics -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Date of Birth</label>
                            <input type="date" name="dateOfBirth" value="<%=dobFormatted%>"
                                   class="w-full border border-gray-300 rounded-md py-2 px-3 focus:outline-none focus:ring-1 focus:ring-black">
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Height (cm)</label>
                            <input type="number" name="height" step="0.1" value="<%=user.getHeight() != null ? user.getHeight() : ""%>"
                                   class="w-full border border-gray-300 rounded-md py-2 px-3 focus:outline-none focus:ring-1 focus:ring-black">
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Weight (kg)</label>
                            <input type="number" name="weight" step="0.1" value="<%=user.getWeight() != null ? user.getWeight() : ""%>"
                                   class="w-full border border-gray-300 rounded-md py-2 px-3 focus:outline-none focus:ring-1 focus:ring-black">
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Dietary Preference</label>
                            <select name="dietaryPreference" class="w-full border border-gray-300 rounded-md py-2 px-3 focus:outline-none focus:ring-1 focus:ring-black">
                                <option value="Vegetarian" <%=user.getDietaryPreference() != null && user.getDietaryPreference().equalsIgnoreCase("vegetarian") ? "selected" : ""%>>Vegetarian</option>
                                <option value="Nonvegetarian" <%=user.getDietaryPreference() != null && user.getDietaryPreference().equalsIgnoreCase("nonvegetarian") ? "selected" : ""%>>Non-Vegetarian</option>
                            </select>
                        </div>

                        <!-- Action Buttons -->
                        <div class="md:col-span-2 flex justify-end space-x-4 mt-6">
                            <button type="reset" class="border border-black bg-transparent text-black py-2 px-4 rounded hover:bg-black hover:text-white transition-colors duration-200">
                                Reset
                            </button>
                            <button type="submit" class="border border-black bg-black text-white py-2 px-6 rounded hover:bg-gray-800 transition-colors duration-200">
                                Save Changes
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Password Change Section -->
                <div class="border border-gray-200 rounded-lg p-6 mb-6">
                    <h4 class="text-xl font-bold mb-4">Change Password</h4>
                    <form action="/changePassword" method="post" onsubmit="return validatePassword()" class="space-y-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Current Password</label>
                            <div class="relative">
                                <input type="password" id="currentPassword" name="currentPassword" required value="<%=user.getPassword()%>"
                                       class="w-full border border-gray-300 rounded-md py-2 px-3 focus:outline-none focus:ring-1 focus:ring-black">
                                <button type="button" onclick="togglePasswordVisibility('currentPassword')"
                                        class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500">
                                    <i id="currentPassword-icon" class="fas fa-eye"></i>
                                </button>
                            </div>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">New Password</label>
                            <div class="relative">
                                <input type="password" id="newPassword" name="newPassword" required minlength="8"
                                       class="w-full border border-gray-300 rounded-md py-2 px-3 focus:outline-none focus:ring-1 focus:ring-black">
                                <button type="button" onclick="togglePasswordVisibility('newPassword')"
                                        class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500">
                                    <i id="newPassword-icon" class="fas fa-eye"></i>
                                </button>
                            </div>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Confirm New Password</label>
                            <div class="relative">
                                <input type="password" id="confirmPassword" name="confirmPassword" required minlength="8"
                                       class="w-full border border-gray-300 rounded-md py-2 px-3 focus:outline-none focus:ring-1 focus:ring-black">
                                <button type="button" onclick="togglePasswordVisibility('confirmPassword')"
                                        class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500">
                                    <i id="confirmPassword-icon" class="fas fa-eye"></i>
                                </button>
                            </div>
                        </div>
                        <div id="password-error" class="text-red-600 text-sm"></div>
                        <div class="flex justify-end">
                            <button type="submit" class="border border-black bg-black text-white py-2 px-6 rounded hover:bg-gray-800 transition-colors duration-200">
                                Update Password
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Current Diet Plan Section -->
                <% if(currentDiet != null) { %>
                <div class="border border-gray-200 rounded-lg p-6">
                    <div class="flex justify-between items-center mb-4">
                        <h4 class="text-xl font-bold">Current Diet Plan</h4>
                        <a href="dietmanager?c=0" class="text-sm text-gray-600 hover:text-black">
                            View All Diets <i class="fas fa-chevron-right ml-1"></i>
                        </a>
                    </div>

                    <div class="bg-gray-100 p-4 rounded-lg">
                        <h5 class="font-bold text-lg mb-2"><%=currentDiet.getDietName()%></h5>
                        <div class="grid grid-cols-2 md:grid-cols-3 gap-4 mt-4">
                            <div>
                                <span class="block text-sm text-gray-600">Type</span>
                                <span class="font-medium"><%=currentDiet.getDietType()%></span>
                            </div>
                            <div>
                                <span class="block text-sm text-gray-600">Meals/Day</span>
                                <span class="font-medium"><%=currentDiet.getTotalMeals()%></span>
                            </div>
                            <div>
                                <span class="block text-sm text-gray-600">Water</span>
                                <span class="font-medium"><%=currentDiet.getWaterIntake()%> glasses</span>
                            </div>
                            <div>
                                <span class="block text-sm text-gray-600">Exercise</span>
                                <span class="font-medium"><%=currentDiet.getExercise() ? "Yes" : "No"%></span>
                            </div>
                            <div>
                                <span class="block text-sm text-gray-600">Preference</span>
                                <span class="font-medium"><%=currentDiet.getDietPreference()%></span>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<!-- Mobile Navigation -->
<div class="md:hidden fixed bottom-0 left-0 right-0 bg-white border-t border-black h-16 flex justify-around items-center">
    <a href="/dashboard" class="text-center px-4 py-2 cursor-pointer hover:bg-gray-100">
        <i class="fas fa-home block text-xl"></i>
        <span class="text-xs">Home</span>
    </a>
    <a href="dietmanager?c=0" class="text-center px-4 py-2 cursor-pointer hover:bg-gray-100">
        <i class="fas fa-utensils block text-xl"></i>
        <span class="text-xs">Diets</span>
    </a>
    <a href="/profile" class="text-center px-4 py-2 cursor-pointer hover:bg-gray-100">
        <i class="fas fa-user block text-xl"></i>
        <span class="text-xs">Profile</span>
    </a>
</div>
<script>
    window.onload = function() {
        const alertMessage = '${sessionScope.alert}';
        if (alertMessage) {
            alert(alertMessage);
            <% session.removeAttribute("alert"); %>
        }
    };
</script>
</body>
</html>