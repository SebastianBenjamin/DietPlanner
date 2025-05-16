<%@ page import="org.classFiles.User" %>
<%@ page errorPage="error.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Exercise Log - Diet Planner</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="flex flex-col h-screen bg-gray-100">
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

<!-- Content -->
<div class="container mx-auto p-6 flex-grow">
    <div class="bg-white p-6 rounded-lg shadow-md">
        <h1 class="text-2xl font-bold mb-6 text-center">Exercise Tracking</h1>

        <c:if test="${not empty alert}">
            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-4" role="alert">
                <span class="block sm:inline">${alert}</span>
            </div>
        </c:if>

        <%
            boolean exerciseRequired = user.getDiet() != null && user.getDiet().getExercise();
            boolean exerciseCompleted = false;
            if (request.getAttribute("exerciseCompleted") != null) {
                exerciseCompleted = (Boolean) request.getAttribute("exerciseCompleted");
            }
        %>

        <c:choose>
            <c:when test="${empty user.diet || !user.diet.exercise}">
                <div class="bg-blue-100 text-blue-700 border border-blue-400 px-4 py-3 rounded mb-4">
                    <p>Your current diet plan does not include exercise requirements.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="border rounded-lg overflow-hidden">
                    <div class="bg-gray-100 px-4 py-2 border-b">
                        <h2 class="text-lg font-semibold">Today's Exercise Status</h2>
                    </div>
                    <div class="p-4">
                        <p class="mb-5">Current Status:
                            <% if(exerciseCompleted) { %>
                            <span class="bg-green-500 text-white px-2 py-1 rounded-full text-sm">Completed</span>
                            <% } else { %>
                            <span class="bg-red-500 text-white px-2 py-1 rounded-full text-sm">Not Completed</span>
                            <% } %>
                        </p>

                        <form action="updateExercise" method="post" class="mt-4">
                            <div class="mb-4">
                                <p class="font-medium mb-2">Update exercise status:</p>
                                <div class="flex items-center gap-6">
                                    <label class="flex items-center">
                                        <input type="radio" name="exerciseStatus" value="true" class="mr-2"
                                                <%= exerciseCompleted ? "checked" : "" %> required>
                                        Completed
                                    </label>
                                    <label class="flex items-center">
                                        <input type="radio" name="exerciseStatus" value="false" class="mr-2"
                                                <%= !exerciseCompleted ? "checked" : "" %>>
                                        Not Completed
                                    </label>
                                </div>
                            </div>
                            <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">
                                Update Status
                            </button>
                        </form>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
<!-- Floating Chat Button -->
<div class="fixed bottom-10 right-9 z-50">
    <a href="chat" class="flex items-center justify-center h-14 w-14 rounded-full bg-gray-900 text-white shadow-lg hover:bg-gray-700 transition-all duration-300 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-500" title="Chat with Nutri Mate">
        <i class="fas fa-user-tie text-2xl"></i>
    </a>
    <span class="absolute top-0 right-0 inline-flex items-center justify-center px-2 py-1 text-xs font-bold leading-none text-white transform translate-x-1/2 -translate-y-1/2 bg-red-500 rounded-full">Nutri Mate</span>
</div>
</body>
</html>