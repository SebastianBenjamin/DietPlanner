<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Diet Planner - Choose Diet</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="flex flex-col h-screen overflow-hidden bg-white text-black">
<!-- Navbar -->
<div class="h-24 border border-black flex items-center justify-between text-3xl font-bold px-6">
    <div>Diet Planner</div>
    <c:choose>
        <c:when test="${not empty sessionScope.user}">
            <div class="text-lg">Welcome, ${sessionScope.user.fullName}</div>

        </c:when>
        <c:otherwise>
            <div class="text-lg">Please log in</div>
        </c:otherwise>
    </c:choose>
</div>

<!-- Content Area -->
<div class="flex-1 overflow-y-auto p-6">
    <h1 class="text-3xl font-bold mb-6">Choose Your Diet Plan</h1>

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
                    <input type="hidden" name="userId" value="${sessionScope.user.userId}">
                    <input type="hidden" name="dietId" value="${diet.dietId}">
                    <button type="submit" class="w-full border-2 text-black py-2 rounded hover:bg-gray-200 hover:text-black">
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
            <a href="dietmanager?c=0" class="block w-full border-2 text-black py-2 rounded hover:bg-green-100 text-center">
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
</body>
</html>