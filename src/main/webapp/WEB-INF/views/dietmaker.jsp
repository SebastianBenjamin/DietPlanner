<!-- dietmaker.jsp -->
<%@ page import="org.classFiles.User" %>
<%@ page errorPage="error.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Diet Planner - Create Diet</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="flex flex-col h-screen overflow-hidden bg-white text-black">
<!-- Navbar -->
<div class="h-24 border border-black flex items-center justify-between text-3xl font-bold px-6">
    <div>Diet Planner</div>
    <%
        User user = (User) session.getAttribute("user");
        if(user != null){
    %>
    <div class="text-lg">Welcome, <%=user.getFullName()%></div>
    <%
    } else {
    %>
    <div class="text-lg">Please log in</div>
    <%
        }
    %>
</div>

<!-- Content Area -->
<div class="flex-1 overflow-y-auto p-6">
    <h1 class="text-3xl font-bold mb-6">Create Custom Diet Plan</h1>

    <form action="/dietmanager" method="post" class="max-w-3xl mx-auto">
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
                    <select id="dietType" name="dietType"
                            class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                        <option value="balanced">Balanced</option>
                        <option value="lowCarb">Low Carb</option>
                        <option value="lowFat">Low Fat</option>
                        <option value="highProtein">High Protein</option>
                        <option value="vegetarian">Vegetarian</option>
                        <option value="custom">Custom</option>
                    </select>
                </div>

                <div>
                    <label for="dietPreference" class="block text-sm font-medium text-gray-700">Dietary Preference</label>
                    <select id="dietPreference" name="dietPreference"
                            class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                        <option value="none">None</option>
                        <option value="glutenFree">Gluten Free</option>
                        <option value="dairyFree">Dairy Free</option>
                        <option value="nutFree">Nut Free</option>
                        <option value="vegan">Vegan</option>
                    </select>
                </div>
            </div>

            <!-- Diet Details -->
            <div class="space-y-4">
                <div>
                    <label for="totalMeals" class="block text-sm font-medium text-gray-700">Total Meals Per Day</label>
                    <input type="number" id="totalMeals" name="totalMeals" min="1" max="6" value="3"
                           class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                </div>

                <div>
                    <label for="waterIntake" class="block text-sm font-medium text-gray-700">Daily Water Intake (glasses)</label>
                    <input type="number" id="waterIntake" name="waterIntake" min="1" max="20" value="8"
                           class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                </div>

                <div>
                    <label for="exercise" class="block text-sm font-medium text-gray-700">Exercise Recommendation</label>
                    <select id="exercise" name="exercise"
                            class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                        <option value="none">None</option>
                        <option value="light">Light (3x/week)</option>
                        <option value="moderate" selected>Moderate (5x/week)</option>
                        <option value="intense">Intense (daily)</option>
                        <option value="custom">Custom Plan</option>
                    </select>
                </div>
            </div>
        </div>

        <!-- Additional Notes -->
        <div class="mt-6">
            <label for="notes" class="block text-sm font-medium text-gray-700">Additional Notes/Instructions</label>
            <textarea id="notes" name="notes" rows="3"
                      class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-blue-500 focus:border-blue-500"></textarea>
        </div>

        <!-- Submit Button -->
        <div class="mt-8 flex justify-end space-x-4">
            <a href="/dashboard" class="bg-gray-300 text-gray-800 py-2 px-4 rounded-md hover:bg-gray-400">
                Cancel
            </a>
            <button type="submit" class="bg-blue-500 text-white py-2 px-6 rounded-md hover:bg-blue-600">
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