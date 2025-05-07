<!-- dietchooser.jsp -->
<%@ page import="org.classFiles.User" %>
<%@ page errorPage="error.jsp" %>

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
    <h1 class="text-3xl font-bold mb-6">Choose Your Diet Plan</h1>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <!-- Keto Diet Card -->
        <div class="border border-gray-300 rounded-lg p-4 hover:shadow-lg transition-shadow">
            <h2 class="text-xl font-bold mb-2">Keto Diet</h2>
            <p class="text-gray-600 mb-4">Low-carb, high-fat diet that helps burn fat more effectively.</p>
            <ul class="mb-4 space-y-1">
                <li>• High healthy fats</li>
                <li>• Moderate protein</li>
                <li>• Very low carbs</li>
            </ul>
            <form action="/dietmanager" method="post">
                <input type="hidden" name="dietType" value="keto">
                <button type="submit" class="w-full bg-blue-500 text-white py-2 rounded hover:bg-blue-600">
                    Select Keto
                </button>
            </form>
        </div>

        <!-- Mediterranean Diet Card -->
        <div class="border border-gray-300 rounded-lg p-4 hover:shadow-lg transition-shadow">
            <h2 class="text-xl font-bold mb-2">Mediterranean</h2>
            <p class="text-gray-600 mb-4">Heart-healthy eating inspired by Mediterranean countries.</p>
            <ul class="mb-4 space-y-1">
                <li>• Plant-based foods</li>
                <li>• Healthy fats</li>
                <li>• Moderate wine</li>
            </ul>
            <form action="/dietmanager" method="post">
                <input type="hidden" name="dietType" value="mediterranean">
                <button type="submit" class="w-full bg-blue-500 text-white py-2 rounded hover:bg-blue-600">
                    Select Mediterranean
                </button>
            </form>
        </div>

        <!-- Vegan Diet Card -->
        <div class="border border-gray-300 rounded-lg p-4 hover:shadow-lg transition-shadow">
            <h2 class="text-xl font-bold mb-2">Vegan</h2>
            <p class="text-gray-600 mb-4">Plant-based diet excluding all animal products.</p>
            <ul class="mb-4 space-y-1">
                <li>• Fruits & vegetables</li>
                <li>• Legumes & grains</li>
                <li>• No animal products</li>
            </ul>
            <form action="/dietmanager" method="post">
                <input type="hidden" name="dietType" value="vegan">
                <button type="submit" class="w-full bg-blue-500 text-white py-2 rounded hover:bg-blue-600">
                    Select Vegan
                </button>
            </form>
        </div>

        <!-- Paleo Diet Card -->
        <div class="border border-gray-300 rounded-lg p-4 hover:shadow-lg transition-shadow">
            <h2 class="text-xl font-bold mb-2">Paleo</h2>
            <p class="text-gray-600 mb-4">Based on foods similar to what might have been eaten during the Paleolithic era.</p>
            <ul class="mb-4 space-y-1">
                <li>• Lean meats</li>
                <li>• Fish, fruits, vegetables</li>
                <li>• Nuts and seeds</li>
            </ul>
            <form action="/dietmanager" method="post">
                <input type="hidden" name="dietType" value="paleo">
                <button type="submit" class="w-full bg-blue-500 text-white py-2 rounded hover:bg-blue-600">
                    Select Paleo
                </button>
            </form>
        </div>

        <!-- Intermittent Fasting Card -->
        <div class="border border-gray-300 rounded-lg p-4 hover:shadow-lg transition-shadow">
            <h2 class="text-xl font-bold mb-2">Intermittent Fasting</h2>
            <p class="text-gray-600 mb-4">Cycling between periods of eating and fasting.</p>
            <ul class="mb-4 space-y-1">
                <li>• 16/8 method common</li>
                <li>• Eat-stop-eat</li>
                <li>• 5:2 diet</li>
            </ul>
            <form action="/dietmanager" method="post">
                <input type="hidden" name="dietType" value="fasting">
                <button type="submit" class="w-full bg-blue-500 text-white py-2 rounded hover:bg-blue-600">
                    Select Fasting
                </button>
            </form>
        </div>

        <!-- Custom Diet Card -->
        <div class="border border-gray-300 rounded-lg p-4 hover:shadow-lg transition-shadow">
            <h2 class="text-xl font-bold mb-2">Custom Diet</h2>
            <p class="text-gray-600 mb-4">Create your own personalized diet plan.</p>
            <ul class="mb-4 space-y-1">
                <li>• Set your own rules</li>
                <li>• Choose meal frequency</li>
                <li>• Custom preferences</li>
            </ul>
            <a href="dietmanager?c=1" class="block w-full bg-green-500 text-white py-2 rounded hover:bg-green-600 text-center">
                Create Custom Diet
            </a>
        </div>
    </div>
</div>

<!-- Mobile Layout -->
<div class="md:hidden fixed bottom-0 left-0 right-0 bg-white border-t border-black h-16 flex justify-around items-center">
    <a href="/dashboard" class="text-center px-4 py-2 cursor-pointer hover:bg-gray-100">Home</a>
    <div class="text-center px-4 py-2 cursor-pointer hover:bg-gray-100 font-bold">Diets</div>
    <a href="/profile" class="text-center px-4 py-2 cursor-pointer hover:bg-gray-100">Profile</a>
</div>
</body>
</html>