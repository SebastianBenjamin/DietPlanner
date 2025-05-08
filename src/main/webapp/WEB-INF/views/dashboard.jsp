<%@ page import="org.classFiles.User" %>
<%@ page import="org.classFiles.Diet" %>
<%@ page errorPage="error.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Diet Planner - Dashboard</title>
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
    <div class="text-lg">
        <a href="profile" class="flex items-center gap-2 hover:text-gray-600" title="Profile">
            <i class="fas fa-user-circle text-3xl"></i>
            <span><%=user.getFullName()%></span>
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
        <div class="flex-grow overflow-y-auto max-h-screen max-h-screen flex items-center justify-center">
            No logged data yet !.
        </div>
        <button class="h-16 border-t border-black flex items-center justify-center w-full hover:bg-gray-100 focus:outline-none">
            Log food
        </button>
        <button class="h-16 border-t border-black flex items-center justify-center w-full hover:bg-gray-100 focus:outline-none">
            Log water
        </button>
        <button class="h-16 border-b border-t border-black flex items-center justify-center w-full hover:bg-gray-100 focus:outline-none">
            Log exercise
        </button>
    </div>
</div>

<!-- Mobile Layout (Only shows when screen is small) -->
<div class="md:hidden fixed bottom-0 left-0 right-0 bg-white border-t border-black h-16 flex justify-around items-center">
    <div class="text-center px-4 py-2 cursor-pointer hover:bg-gray-100">Diets</div>
    <div class="text-center px-4 py-2 cursor-pointer hover:bg-gray-100">Home</div>
    <div class="text-center px-4 py-2 cursor-pointer hover:bg-gray-100">Profile</div>
</div>

<script>
    async function displayRandomSalad() {
        try {
            const response = await fetch('https://mocki.io/v1/37f08d62-c762-47d3-893e-0f6a015a7bf4');
            const data = await response.json();

            if (data.salads && data.salads.length > 0) {
                const randomIndex = 2;
                const salad = data.salads[randomIndex];

                document.getElementById('salad-name').textContent = salad.name;
                document.getElementById('salad-recipe').innerHTML = "Ingredients: <br>"+salad.recipe;
                document.getElementById('salad-image').src = salad.image;
                document.getElementById('salad-image').alt = salad.name;

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

    window.addEventListener('DOMContentLoaded', displayRandomSalad);
    window.onload = function() {
        const alertMessage = '${alert}';
        if (alertMessage) {
            alert(alertMessage);
        }
    };
</script>

</body>
</html>