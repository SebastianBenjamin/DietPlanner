<%@ page import="org.classFiles.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page errorPage="error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Diet Planner - Water Log </title>
  <link rel="icon" type="image/ico" href="healthy-food.png">

  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="flex flex-col h-screen bg-gray-100">
<!-- Navbar -->
<div class="h-24 border border-black flex items-center justify-between text-3xl font-bold px-6">
  <div class="text-3xl font-bold">Diet Planner</div>

  <%
    User user = (User) session.getAttribute("user");
    if(user == null) {
      response.sendRedirect("login");
      return;
    }
  %>

  <div class="flex gap-4">
    <a href="dashboard" class="flex items-center gap-2 hover:text-gray-600">
      <i class="fas fa-home text-lg mr-1"></i>
      <span class="text-lg">Dashboard</span>
    </a>
    <a href="profile" class="flex items-center gap-2 hover:text-gray-600" title="Profile">
      <i class="fas fa-user-circle text-lg"></i>
      <span class="text-lg"><%=user.getFullName()%></span>
    </a>
    <a href="logout" class="px-3 py-1.5 rounded-md border border-red-500 text-red-500 hover:bg-red-50 transition text-lg">Logout</a>
  </div>
</div>

<!-- Content -->
<div class="container mx-auto p-6 flex-grow">
  <div class="bg-white p-6 rounded-lg shadow-md">
    <h1 class="text-2xl font-bold mb-6 text-center">Water Tracking</h1>

    <% if(user.getDiet() == null) { %>
    <div class="bg-gray-100 text-gray-700 border border-gray-300 px-4 py-3 rounded mb-4">
      <p>You don't have a diet plan. Please set up a diet plan first.</p>
    </div>
    <% } else { %>
    <!-- Progress -->
    <%
      int todayWaterIntake = (Integer)request.getAttribute("todayWaterIntake");
      int dailyGoal = (Integer)request.getAttribute("dailyGoal");
      int percentage = Math.min(100, (todayWaterIntake * 100) / dailyGoal);
    %>

    <div class="mb-8">
      <div class="flex justify-between mb-2">
        <span class="font-medium">Daily progress</span>
        <span><%= todayWaterIntake %> / <%= dailyGoal %> ml</span>
      </div>
      <div class="w-full h-4 bg-gray-200 rounded-full">
        <div class="h-4 bg-blue-500 rounded-full" style="width: <%= percentage %>%"></div>
      </div>
    </div>

    <!-- Add Water Form -->
    <form action="addWaterLog" method="post" class="mb-8">
      <div class="flex gap-4 justify-center">
        <button type="submit" name="amountMl" value="200" class="bg-gray-100 text-gray-800 px-4 py-3 rounded-lg border border-gray-300 hover:bg-gray-200">
          <i class="fas fa-glass-water text-xl mb-1"></i><br>200ml
        </button>
        <button type="submit" name="amountMl" value="350" class="bg-gray-100 text-gray-800 px-4 py-3 rounded-lg border border-gray-300 hover:bg-gray-200">
          <i class="fas fa-glass-water text-2xl mb-1"></i><br>350ml
        </button>
        <button type="submit" name="amountMl" value="500" class="bg-gray-100 text-gray-800 px-4 py-3 rounded-lg border border-gray-300 hover:bg-gray-200">
          <i class="fas fa-bottle-water text-2xl mb-1"></i><br>500ml
        </button>
      </div>
      <div class="mt-4 flex justify-center">
        <div class="flex items-center gap-2">
          <label for="customAmount">Custom amount:</label>
          <input type="number" id="customAmount" name="amountMl" class="border rounded px-3 py-2 w-24" placeholder="ml">
          <button type="submit" class="bg-gray-900 text-white px-4 py-2 rounded hover:bg-gray-800">Add</button>
        </div>
      </div>
    </form>

    <!-- Reset button -->
    <div class="mt-6 text-center border-t pt-4">
      <form action="resetWaterLog" method="post">
        <button type="submit"
                class="bg-gray-800 text-white px-4 py-2 rounded hover:bg-black flex items-center mx-auto">
          <i class="fas fa-redo-alt mr-2"></i> Reset Today's Water Log
        </button>
      </form>
    </div>
    <% } %>
  </div>
</div>

<script>
  window.onload = function() {
    const alertMessage = '${alert}';
    if (alertMessage) {
      alert(alertMessage);
    }
  };
</script>


<div class="fixed bottom-10 right-9 z-50">
  <a href="chat" class="flex items-center justify-center h-14 w-14 rounded-full bg-gray-900 text-white shadow-lg hover:bg-gray-700 transition-all duration-300 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-500" title="Chat with Nutri Mate">
    <i class="fas fa-user-tie text-2xl"></i>
  </a>
  <span class="absolute top-0 right-0 inline-flex items-center justify-center px-2 py-1 text-xs font-bold leading-none text-white transform translate-x-1/2 -translate-y-1/2 bg-red-500 rounded-full">Nutri Mate</span>
</div>
</body>
</html>