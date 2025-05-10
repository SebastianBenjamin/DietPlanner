<%@ page import="org.classFiles.User" %>
<%@ page errorPage="error.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meal Log - Diet Planner</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="flex flex-col h-screen bg-gray-100">
<!-- Navbar -->

<div class="h-24 min-h-24 border border-black flex items-center justify-between text-3xl font-bold px-6">
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

<!-- Content -->
<div class="container mx-auto p-6 flex-grow">
    <div class="bg-white p-6 rounded-lg shadow-md">
        <h1 class="text-2xl font-bold mb-6 text-center">Meal Tracking</h1>

        <c:if test="${not empty alert}">
            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-4" role="alert">
                <span class="block sm:inline">${alert}</span>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert">
                <span class="block sm:inline">${error}</span>
            </div>
        </c:if>

        <c:choose>
            <c:when test="${empty user.diet}">
                <div class="bg-blue-100 text-blue-700 border border-blue-400 px-4 py-3 rounded mb-4">
                    <p>You don't have a diet plan. Please set up a diet plan first.</p>
                </div>
            </c:when>
            <c:otherwise>
                <%-- Fix: Using scriptlet to get totalMeals value without pageContext.setAttribute --%>
                <% int totalMeals = user.getDiet().getTotalMeals(); %>
                <div class="border rounded-lg overflow-hidden">
                    <div class="bg-gray-100 px-4 py-2 border-b">
                        <h2 class="text-lg font-semibold">Today's Meals (<%= totalMeals %> meals recommended)</h2>
                    </div>
                    <div class="p-4">
                        <div class="grid grid-cols-1 gap-4">
                                <%-- Loop through meals using scriptlet instead of JSTL to avoid EL issues --%>
                            <% for(int i = 1; i <= totalMeals; i++) { %>
                            <div class="border rounded p-4">
                                <h3 class="font-medium text-lg mb-2">Meal <%= i %></h3>
                                <div class="flex items-center justify-between">
                    <span>Status:
                      <% if(((boolean[])request.getAttribute("mealStatus"))[i-1]) { %>
                        <span class="bg-green-500 text-white px-2 py-1 rounded-full text-sm">Completed</span>
                      <% } else { %>
                        <span class="bg-red-500 text-white px-2 py-1 rounded-full text-sm">Not Completed</span>
                      <% } %>
                    </span>
                                    <form action="updateMeal" method="post" class="inline-block">
                                        <input type="hidden" name="mealNumber" value="<%= i %>">
                                        <input type="hidden" name="completed" value="<%= !((boolean[])request.getAttribute("mealStatus"))[i-1] %>">
                                        <button type="submit" class="bg-blue-500 text-white px-3 py-1 rounded hover:bg-blue-600">
                                            <%= ((boolean[])request.getAttribute("mealStatus"))[i-1] ? "Mark Incomplete" : "Mark Complete" %>
                                        </button>
                                    </form>
                                </div>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>