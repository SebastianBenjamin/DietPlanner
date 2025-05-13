<%@ page import="org.classFiles.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Diet Planner - Choose a Diet</title>
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

<!-- Content Area -->
<div class="flex-1 overflow-y-auto p-6">
    <h3 class="text-xl font-bold mb-6">Choose Your Diet Plan</h3>

    <c:if test="${not empty error}">
        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                ${error}
        </div>
    </c:if>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <!-- Dynamic Diet Cards -->
        <c:forEach items="${diets}" var="diet">
            <div class="border border-gray-300 rounded-lg p-4 hover:shadow-lg transition-shadow">
                <h2 class="text-xl font-bold mb-2">${diet.dietName}</h2>
                <p class="text-gray-600 mb-4">${diet.dietType}</p>
                <ul class="mb-4 space-y-1">
                    <c:if test="${not empty diet.dietPreference}">
                        <li>• ${diet.dietPreference}</li>
                    </c:if>
                    <c:if test="${not empty diet}">
                        <li>• Exercise:
                            <c:choose>
                                <c:when test="${diet.exercise}">Yes</c:when>
                                <c:otherwise>No</c:otherwise>
                            </c:choose>
                        </li>
                    </c:if>
                    <c:if test="${diet.totalMeals != null}">
                        <li>• Total meals: ${diet.totalMeals}</li>
                    </c:if>
                    <c:if test="${diet.waterIntake != null}">
                        <li>• Water intake: ${diet.waterIntake} liters</li>
                    </c:if>
                </ul>
                <form action="selectDiet" method="post">

                    <input type="hidden" name="dietId" value="${diet.dietId}">
                    <button type="submit" class="w-full border border-black bg-transparent text-black py-2 px-6 rounded hover:bg-black hover:text-white transition-colors duration-200">
                        Select
                    </button>
                </form>
            </div>
        </c:forEach>

        <!-- Custom Diet Card -->
        <div class="border border-gray-300 rounded-lg p-4 hover:shadow-lg transition-shadow">
            <h2 class="text-xl font-bold mb-2">Custom Diet</h2>
            <p class="text-gray-600 mb-4">Create your own personalized diet plan.</p>
            <ul class="mb-4 space-y-1">
                <li>• Set your own rules</li>
                <li>• Choose meal frequency</li>
                <li>• Custom preferences</li>
            </ul>
            <a href="dietmanager?c=0" class="block w-full border border-black text-black py-2 rounded hover:bg-green-300 text-center">
                Create Custom Diet
            </a>
        </div>
    </div>
</div>

<!-- Mobile Navigation -->
<div class="md:hidden fixed bottom-0 left-0 right-0 bg-white border-t border-black h-16 flex justify-around items-center">
    <a href="dashboard" class="text-center px-4 py-2 cursor-pointer hover:bg-gray-100">Home</a>
    <div class="text-center px-4 py-2 cursor-pointer hover:bg-gray-100 font-bold">Diets</div>
    <a href="profile" class="text-center px-4 py-2 cursor-pointer hover:bg-gray-100">Profile</a>
</div>

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