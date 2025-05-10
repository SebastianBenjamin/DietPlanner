<%@ page import="org.classFiles.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Diet Planner - Login</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-white min-h-screen flex flex-col">

<div class="h-24 border border-black flex items-center justify-between text-3xl font-bold px-6">
    <div>Diet Planner</div>

</div>


<main class="flex-grow flex items-center justify-center px-4 py-10">
    <div class="bg-white border shadow-md rounded-xl w-full max-w-md p-8">
        <h2 class="text-2xl font-bold text-center text-black mb-6">Login</h2>


        <c:if test="${not empty alert}">
            <div class="bg-red-100 text-red-700 px-4 py-2 rounded mb-4 text-center">
                    ${alert}
            </div>
        </c:if>


        <c:if test="${not empty message}">
            <div class="bg-green-100 text-green-700 px-4 py-2 rounded mb-4 text-center">
                    ${message}
            </div>
        </c:if>

        <form method="post" action="authenticateUser" class="space-y-4">
            <div>
                <label class="block font-semibold mb-1 text-black">Email</label>
                <input type="email" name="email"  class="w-full border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-black" required>
            </div>

            <div>
                <label class="block font-semibold mb-1 text-black">Password</label>
                <input type="password" name="password" class="w-full border rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-black" required>
            </div>

            <div>
                <input type="submit" value="Login" class="w-full bg-black text-white font-semibold py-2 rounded hover:bg-gray-800 transition">
            </div>
        </form>

        <p class="mt-6 text-center text-sm text-black">
            Don't have an account?
            <a href="signup" class="text-black underline hover:text-gray-700 font-medium">Sign up here</a>
        </p>
    </div>
</main>
<script>

</script>

</body>
</html>
