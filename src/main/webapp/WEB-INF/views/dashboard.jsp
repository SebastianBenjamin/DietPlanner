<%@ page import="org.classFiles.User" %>
<%@ page import="org.classFiles.Diet" %>
<%@ page import="org.classFiles.LogData" %>
<%@ page import="org.hibernate.SessionFactory" %>
<%@ page import="org.classFiles.Services" %>
<%@ page errorPage="error.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Diet Planner - Dashboard</title>
    <link rel="icon" type="image/ico" href="healthy-food.png">
    <script src="https://cdn.tailwindcss.com"></script>
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

        <a href="profile" class="flex items-center gap-2 hover:text-gray-600" title="Profile">
            <i class="fas fa-user-circle text-lg"></i> <!-- Smaller Icon -->
            <span class="text-lg"><%=user.getFullName()%></span> <!-- Smaller Text -->
        </a>
        <a href="logout" class="px-3 py-1.5 rounded-md border border-red-500 text-red-500 hover:bg-red-50 transition text-lg">Logout</a>
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


<!-- Rest of the code remains the same -->
<!-- Content Area -->
<div class="flex flex-1 relative overflow-hidden">
    <!-- Left Section - Your Diets -->
    <div class="w-1/4 border border-black bg-white flex flex-col h-full md:static absolute left-0 top-0 bottom-0">
        <div class="h-16 border-b border-black flex items-center justify-center font-medium">
            Your Diets
        </div>
        <div class="flex-grow overflow-y-auto max-h-screen max-h-screen flex flex-col items-center justify-center">
            <%
                Diet diet = user.getDiet();
                if(diet != null){
            %>
            <div class="text-center mb-4">
                <p class="text-lg font-bold"> <%= diet.getDietName() %></p>
                <p class="text-lg font-normal"><%= diet.getDietType() %></p>
            </div>
            <form method="post" action="cancelDiet" class="mb-4">
                <input type="hidden" name="userId" value="<%= user.getUserId() %>">
                <input type="submit" class="inline-block px-3 py-1.5 text-red-600 border border-red-600 rounded-md transition-colors hover:bg-red-50 focus:outline-none focus:ring-2 focus:ring-red-200 focus:ring-offset-1"
                       value="Cancel Diet"/>
            </form>
            <%
            } else {
            %>
            <div class="text-center">
                No diet selected!.
            </div>
            <%
                }
            %>
        </div>

        <a class="h-16 border-t border-black flex items-center justify-center w-full hover:bg-gray-100 focus:outline-none"
           href="dietmanager?c=1">
            Choose a diet
        </a>
        <a class="h-16 border-t border-black flex items-center justify-center w-full hover:bg-gray-100 focus:outline-none"
           href="dietmanager?c=0">
            Make a Diet
        </a>
    </div>

    <!-- Center Section -->
    <div class="w-1/2 border border-black bg-white mx-auto flex flex-col">

        <div class="bg-white p-4 flex-1 overflow-y-auto">
            <h1 class="text-2xl font-bold mb-4">Salad of the day</h1>
            <h3 id="salad-name" class="text-xl mb-2"></h3>
            <img id="salad-image" src="" alt="Salad" class="w-48 h-48 mx-auto my-4 object-cover rounded-lg"/>

            <p id="salad-recipe" class="mb-4"></p>
            <p id="error-message" class="text-red-500"></p>
        </div>
    </div>

    <!-- Right Section -->
    <div class="w-1/4 border border-black bg-white flex flex-col jus h-full md:static absolute right-0 top-0 bottom-0">
        <div class="h-16 border-b border-black flex items-center justify-center font-medium">
            Tracking
        </div>
        <div class="flex-grow overflow-y-auto max-h-screen max-h-screen">
            <%
                if(user.getLogId()!=null){
                LogData logData= Services.getLogDataById(user.getLogId());

                if(logData!=null){

            %>
            <div class="p-2">
                <table class="w-full border-collapse">
                    <thead>
                    <tr class="bg-gray-100">
                        <th class="border p-2">Date</th>
                        <th class="border p-2">Water</th>
                        <th class="border p-2">Meal</th>
                        <th class="border p-2">Exercise</th>
                        <th class="border p-2">Streak</th>
                    </tr>
                    </thead>
                    <tbody>

                    <tr class="hover:bg-gray-50">
                        <td class="border p-2 text-center"><%= logData.getDate() %></td>
                        <td class="border p-2 text-center"><%= logData.getWater() %> ml</td>
                        <td class="border p-2 text-center"><%= logData.getMeals() %></td>
                        <td class="border p-2 text-center"><%=(logData.isExercise()) ? "Yes":"No" %> </td>
                        <td class="border p-2 text-center"><%= user.getCurrentStreak() %></td>
                    </tr>

                    </tbody>
                </table>
            </div>
            <%
            }  else {
            %>
            <div class="flex items-center justify-center h-full">
                Log data not found!
            </div>
            <%
                }
                } else {
            %>
            <div class="flex items-center justify-center h-full">
                No log assigned yet!
            </div>
            <%
                }
            %>

        </div>
        <a href="mealLog" class="h-16 border-b border-t border-black flex items-center justify-center w-full hover:bg-gray-100 focus:outline-none">
            <i class="fas fa-utensils mr-2"></i>Meal Log
        </a>
        <a href="waterLog" class="h-16 border-b border-black flex items-center justify-center w-full hover:bg-gray-100 focus:outline-none">
            <i class="fas fa-tint mr-2"></i>Water Log
        </a>
        <a href="exerciseLog" class="h-16 flex items-center justify-center w-full hover:bg-gray-100 focus:outline-none">
            <i class="fas fa-dumbbell mr-2"></i>Exercise Log
        </a>
    </div>
</div>

<!-- Mobile Layout (Only shows when screen is small) -->
<div class="md:hidden fixed bottom-0 left-0 right-0 bg-white border-t border-black h-16 flex justify-around items-center">
    <div class="text-center px-4 py-2 cursor-pointer hover:bg-gray-100">Diets</div>
    <div class="text-center px-4 py-2 cursor-pointer hover:bg-gray-100">Home</div>
    <div class="text-center px-4 py-2 cursor-pointer hover:bg-gray-100">Profile</div>
</div>
<script>
    function getDailyIndex() {
        // Get today's date as a unique seed (days since epoch)
        const today = new Date();
        const daysSinceEpoch = Math.floor(today / (1000 * 60 * 60 * 24));

        // Cycle through 0-9 based on days
        return daysSinceEpoch % 10;
    }

    async function displayDailySalad() {
        try {
            const response = await fetch('https://mocki.io/v1/37f08d62-c762-47d3-893e-0f6a015a7bf4');
            const data = await response.json();

            if (data.salads && data.salads.length > 0) {
                // Get today's index (0-9)
                const dailyIndex = getDailyIndex();
                const salad = data.salads[dailyIndex];

                document.getElementById('salad-name').textContent = salad.name;
                document.getElementById('salad-recipe').innerHTML = "Ingredients: <br>" + salad.recipe;
                document.getElementById('salad-image').src = salad.image;
                document.getElementById('salad-image').alt = salad.name;

                // Store today's salad info
                const today = new Date();
                localStorage.setItem('lastSaladDate', today.toDateString());
                localStorage.setItem('lastSaladIndex', dailyIndex);

                return salad;
            } else {
                console.error('No salads found in the data');
                return null;
            }
        } catch (error) {
            console.error('Error fetching salad data:', error);
            document.getElementById('error-message').textContent = 'Failed to load recipe. Please try again later.';
            return null;
        }
    }

    window.addEventListener('DOMContentLoaded', displayDailySalad);

    window.onload = function() {
        const alertMessage = '${sessionScope.alert}';
        if (alertMessage) {
            alert(alertMessage);
            <% session.removeAttribute("alert"); %>
        }
    };
</script>
<!-- Floating Chat Button -->
<div class="fixed bottom-6 right-6 z-50 group">
    <a href="chat" class="flex items-center justify-center h-14 w-14 rounded-full bg-gray-900 text-white shadow-lg hover:bg-gray-700 transition-all duration-300 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-500">
        <i class="fas fa-comment-dots text-2xl"></i>
    </a>
    <span class="absolute top-0 right-0 inline-flex items-center justify-center px-2 py-1 text-xs font-bold leading-none text-white transform translate-x-1/2 -translate-y-1/2 bg-red-500 rounded-full">AI</span>

    <!-- Tooltip that appears on hover -->
    <span class="absolute right-16 whitespace-nowrap bg-gray-800 text-white text-sm px-3 py-1 rounded opacity-0 group-hover:opacity-100 transition-opacity duration-300">
    Chat with AI Assistant
  </span>
</div>
</body>
</html>