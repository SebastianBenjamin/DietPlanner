<!-- dietmaker.jsp -->
<%@ page import="org.classFiles.User" %>
<%@ page errorPage="error.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Diet Planner - Make a Diet</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="icon" type="image/ico" href="healthy-food.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="flex flex-col h-screen overflow-hidden bg-white text-black">
<!-- Navbar -->
<div class="h-24 border border-black flex items-center justify-between text-3xl font-bold px-6">
    <div>Diet Planner</div>
    <%
        User user = (User) session.getAttribute("user");
        if(user != null){
    %>
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
    <%
    } else {
        response.sendRedirect("login");
    %>
    <div class="text-lg">Please log in</div>
    <%
        }
    %>

</div>

<!-- Content Area -->
<div class="flex-1 overflow-y-auto p-6">
    <h3 class="text-xl font-bold mb-6">Create Custom Diet Plan</h3>

    <form action="/makeDiet" method="post" class="max-w-3xl mx-auto">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <!-- Diet Basic Info -->
            <div class="space-y-4">
                <div>
                    <label for="dietName" class="block text-sm font-medium text-gray-700">Diet Name</label>
                    <input type="text" id="dietName" name="dietName" required
                           class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                </div>

                <div>
                    <label for="dietType" class="block text-sm font-medium text-gray-700">Diet Type</label>
                    <select id="dietType" name="dietType" required
                            class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                        <option value="Balanced">Balanced</option>
                        <option value="Low Carb">Low Carb</option>
                        <option value="Low Fat">Low Fat</option>
                        <option value="High Protein">High Protein</option>
                        <option value="Vegetarian">Vegetarian</option>
                        <option value="Custom">Custom</option>
                    </select>
                </div>

                <div>
                    <label for="dietPreference" class="block text-sm font-medium text-gray-700">Dietary Preference</label>
                    <select id="dietPreference" name="dietPreference" required
                            class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-blue-500 focus:border-blue-500">

                        <option value="Vegetarian">Vegetarian</option>
                        <option value="Non Vegetarian">Non Vegetarian</option>
                    </select>
                </div>
            </div>

            <!-- Diet Details -->
            <div class="space-y-4">
                <div>
                    <label for="totalMeals" class="block text-sm font-medium text-gray-700">Total Meals Per Day</label>
                    <input type="number" id="totalMeals" name="totalMeals" min="1" max="6" value="0" required
                           class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                </div>

                <div>
                    <label for="waterIntake" class="block text-sm font-medium text-gray-700">Daily Water Intake (liters)</label>
                    <input type="number" id="waterIntake" name="waterIntake" min="1" max="20" value="0" required
                           class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                </div>

                <div>
                    <label for="exercise" class="block text-sm font-medium text-gray-700">Exercise </label>
                    <select id="exercise" name="exercise" required
                            class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-blue-500 focus:border-blue-500">

                        <option value="1">Yes</option>
                        <option value="0" selected>No</option>

                    </select>
                </div>
            </div>
        </div>


        <!-- Submit Button -->
        <div class="mt-8 flex justify-end space-x-4">
            <a href="dashboard" class="border border-black bg-transparent text-black py-2 px-4 rounded hover:bg-black hover:text-white transition-colors duration-200">
                Cancel
            </a>
            <button type="submit" class="border border-black bg-transparent text-black py-2 px-6 rounded hover:bg-black hover:text-white transition-colors duration-200">
                Create Diet Plan
            </button>
        </div>
    </form>
</div>

<!-- Mobile Layout -->
<div class="md:hidden fixed bottom-0 left-0 right-0 bg-white border-t border-black h-16 flex justify-around items-center">
    <a href="/dashboard" class="text-center px-4 py-2 cursor-pointer hover:bg-gray-100">Home</a>
    <a href="dietmanager?c=0" class="text-center px-4 py-2 cursor-pointer hover:bg-gray-100">Diets</a>
    <a href="/profile" class="text-center px-4 py-2 cursor-pointer hover:bg-gray-100">Profile</a>
</div>
</body>
</html>