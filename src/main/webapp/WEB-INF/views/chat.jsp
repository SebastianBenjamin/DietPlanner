<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.classFiles.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Diet Planner - Nutri Mate</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .chat-container {
            max-width: 700px;
            margin: 30px auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        .chat-header {
            background: #212529;
            color: white;
            padding: 15px 20px;
        }
        .chat-messages {
            height: 400px;
            overflow-y: auto;
            padding: 15px;
        }
        .message {
            margin-bottom: 15px;
            max-width: 80%;
            border-radius: 10px;
            padding: 12px 16px;
        }
        .message.user {
            margin-left: auto;
            background: #e9ecef;
            border-radius: 18px 18px 0 18px;
        }
        .message.bot {
            background: #f8f9fa;
            border-radius: 18px 18px 18px 0;
            border: 1px solid #dee2e6;
        }
        .chat-input {
            display: flex;
            padding: 15px;
            background: #f8f9fa;
            border-top: 1px solid #dee2e6;
        }
        .chat-input input {
            flex: 1;
            padding: 12px 16px;
            border: 1px solid #ced4da;
            border-radius: 20px;
            outline: none;
        }
        .chat-input button {
            background: #212529;
            color: white;
            border: none;
            border-radius: 20px;
            padding: 10px 20px;
            margin-left: 10px;
            cursor: pointer;
        }
        .chat-input button:hover {
            background: #495057;
        }
        .typing-indicator {
            display: none;
            padding: 10px;
            font-style: italic;
            color: #6c757d;
        }
        .error-message {
            color: #dc3545;
            background: #f8d7da;
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            display: none;
        }
        pre {
            white-space: pre-wrap;
            word-wrap: break-word;
            background-color: #f8f9fa;
            padding: 10px;
            border-radius: 5px;
            margin: 5px 0;
            border: 1px solid #dee2e6;
        }
        .section-title {
            font-weight: 600;
            margin-top: 10px;
            color: #212529;
        }
        .suggestions {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin: 15px;
        }
        .suggestion {
            background: #f8f9fa;
            padding: 8px 12px;
            border-radius: 16px;
            font-size: 14px;
            cursor: pointer;
            border: 1px solid #dee2e6;
        }
        .suggestion:hover {
            background: #e9ecef;
        }
        .recommendation-item {
            margin-bottom: 8px;
            padding-left: 15px;
            position: relative;
        }
        .recommendation-item:before {
            content: "•";
            position: absolute;
            left: 0;
        }
        /* Custom scrollbar for chat messages */
        .chat-messages::-webkit-scrollbar {
            width: 6px;
        }
        .chat-messages::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }
        .chat-messages::-webkit-scrollbar-thumb {
            background: #c1c1c1;
            border-radius: 10px;
        }
        .chat-messages::-webkit-scrollbar-thumb:hover {
            background: #a8a8a8;
        }
    </style>
</head>
<body class="flex flex-col h-screen bg-gray-100">

<div class="h-24 min-h-24 border-2 border-black flex items-center justify-between text-3xl font-bold px-6">
    <div>Diet Planner</div>

    <%
        User user = (User) session.getAttribute("user");
        if(user != null){
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

<div class="container mx-auto">
    <div class="chat-container">
        <div class="chat-header">
            <h4 class="mb-0">Nutri Mate</h4>
            <p class="mb-0 small">Ask me anything about nutrition and diet planning</p>
        </div>

        <div class="error-message" id="errorMessage"></div>

        <div class="chat-messages" id="chatMessages">
            <div class="message bot">
                <div class="d-flex align-items-center mb-2">
                    <div class="rounded-circle bg-dark text-white d-flex align-items-center justify-content-center me-2" style="width: 30px; height: 30px;">
                        <i class="fas fa-robot"></i>
                    </div>
                    <strong>Nutri Mate</strong>
                </div>
                Hello! I'm Nutri Mate , your Diet Planner Assistant. How can I help you with your nutrition or diet plans today?
            </div>
        </div>

        <div class="typing-indicator" id="typingIndicator">
            <div class="d-flex align-items-center">
                <div class="rounded-circle bg-dark text-white d-flex align-items-center justify-content-center me-2" style="width: 30px; height: 30px;">
                    <i class="fas fa-robot"></i>
                </div>
                Nutri Mate is typing...
            </div>
        </div>

        <div class="suggestions">
            <div class="suggestion" onclick="sendSuggestion('What\'s a good diet for weight loss?')">Weight loss diet</div>
            <div class="suggestion" onclick="sendSuggestion('How much protein should I eat daily?')">Daily protein intake</div>
            <div class="suggestion" onclick="sendSuggestion('Suggest healthy breakfast options')">Breakfast ideas</div>
            <div class="suggestion" onclick="sendSuggestion('How much water should I drink?')">Water intake</div>
        </div>

        <div class="chat-input">
            <input type="text" id="userInput" placeholder="Type your question here..." autocomplete="off">
            <button id="sendButton">Send</button>
        </div>
    </div>
</div>



<script>
    document.addEventListener('DOMContentLoaded', function() {
        const chatMessages = document.getElementById('chatMessages');
        const userInput = document.getElementById('userInput');
        const sendButton = document.getElementById('sendButton');
        const errorMessage = document.getElementById('errorMessage');
        const typingIndicator = document.getElementById('typingIndicator');

        // Handle sending messages
        function sendMessage() {
            const message = userInput.value.trim();
            if (message) {
                // Add user message to chat
                appendMessage('user', message);
                userInput.value = '';

                // Show typing indicator
                typingIndicator.style.display = 'block';
                chatMessages.scrollTop = chatMessages.scrollHeight;

                // Hide any previous error
                errorMessage.style.display = 'none';

                // Send to backend
                fetchGeminiResponse(message)
                    .then(function(response) {
                        // Hide typing indicator
                        typingIndicator.style.display = 'none';

                        // Add bot response
                        appendMessage('bot', formatResponse(response));
                    })
                    .catch(function(error) {
                        // Hide typing indicator
                        typingIndicator.style.display = 'none';

                        // Show error message
                        errorMessage.textContent = 'Error: ' + (error.message || 'Could not get a response');
                        errorMessage.style.display = 'block';

                        // Add error message in chat
                        appendMessage('bot', 'Sorry, I encountered an error. Please try again later.');
                    });
            }
        }

        // Handle suggestion clicks
        window.sendSuggestion = function(text) {
            userInput.value = text;
            sendMessage();
        };

        // Format response with markdown-like features
        function formatResponse(text) {
            try {
                // First try to parse as JSON to handle structured responses
                const jsonStart = text.indexOf('{');
                const jsonEnd = text.lastIndexOf('}') + 1;
                if (jsonStart >= 0 && jsonEnd > jsonStart) {
                    try {
                        const jsonString = text.slice(jsonStart, jsonEnd);
                        const data = JSON.parse(jsonString);
                        return renderStructuredResponse(data);
                    } catch (e) {
                        console.log("Not valid JSON, processing as text");
                    }
                }
            } catch (e) {
                console.log("Error parsing structured content, falling back to text formatting");
            }

            // Regular text formatting
            text = text.replace(/```([^`]*?)```/g, function(match, p1) {
                return '<pre>' + p1 + '</pre>';
            });

            // Convert bold text
            text = text.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');

            // Convert italics
            text = text.replace(/\*(.*?)\*/g, '<em>$1</em>');

            // Convert bullet points
            text = text.replace(/^\s*-\s+(.+)$/gm, '• $1<br>');

            // Convert numbered lists
            text = text.replace(/^\s*(\d+)\.\s+(.+)$/gm, '$1. $2<br>');

            // Convert newlines to <br>
            text = text.replace(/\n/g, '<br>');

            return text;
        }

        function renderStructuredResponse(data) {
            let htmlContent = '';

            // Description Section
            if (data.description) {
                htmlContent += '<p>' + data.description + '</p>';
            }

            // Nutrition Info Section
            if (data.nutritionInfo) {
                htmlContent += '<div class="section-title">Nutrition Information</div><div class="mt-2">';

                if (Array.isArray(data.nutritionInfo)) {
                    data.nutritionInfo.forEach(function(item) {
                        htmlContent += '<div class="mb-3">' +
                            '<div><strong>' + (item.name || 'Item') + '</strong> (' + (item.servingSize || 'Serving') + ')</div>';

                        for (const [key, value] of Object.entries(item)) {
                            if (key !== 'name' && key !== 'servingSize') {
                                htmlContent += '<div>' + key + ': ' + value + '</div>';
                            }
                        }

                        htmlContent += '</div>';
                    });
                } else {
                    for (const [key, value] of Object.entries(data.nutritionInfo)) {
                        htmlContent += '<div>' + key + ': ' + value + '</div>';
                    }
                }

                htmlContent += '</div>';
            }

            // Daily Needs Section
            if (data.dailyNeeds) {
                htmlContent += '<div class="section-title">Daily Caloric Needs</div>' +
                    '<div class="mt-2">' +
                    '<div>Daily Target: ' + data.dailyNeeds + ' calories</div>';

                if (data.breakfastCalories) {
                    htmlContent += '<div>Breakfast Target: ' + data.breakfastCalories + ' calories</div>';
                }
                if (data.oatmealCalories) {
                    htmlContent += '<div>This Meal Provides: ' + data.oatmealCalories + ' calories</div>';
                }
                if (data.percentageOfDailyNeeds) {
                    htmlContent += '<div>Percentage of Daily Needs: ' + data.percentageOfDailyNeeds + '%</div>';
                }

                htmlContent += '</div>';
            }

            // Recommendations Section
            if (data.recommendations && data.recommendations.length) {
                htmlContent += '<div class="section-title">Recommendations</div>' +
                    '<div class="mt-2">';

                if (Array.isArray(data.recommendations)) {
                    data.recommendations.forEach(function(item) {
                        htmlContent += '<div class="recommendation-item">' + item + '</div>';
                    });
                } else {
                    htmlContent += '<div class="recommendation-item">' + data.recommendations + '</div>';
                }

                htmlContent += '</div>';
            }

            // Additional Notes Section
            if (data.notes) {
                htmlContent += '<div class="section-title">Additional Notes</div>' +
                    '<div class="mt-2">';

                if (Array.isArray(data.notes)) {
                    data.notes.forEach(function(note) {
                        htmlContent += '<p class="mb-2">• ' + note + '</p>';
                    });
                } else {
                    htmlContent += '<p>' + data.notes + '</p>';
                }

                htmlContent += '</div>';
            }

            // If only plain text is available
            if (!data.nutritionInfo && !data.ingredients && !data.dailyNeeds &&
                !data.recommendations && !data.notes && data.text) {
                htmlContent += '<p>' + data.text + '</p>';
            }

            return htmlContent || "I couldn't process that information.";
        }

        // Add a message to the chat
        function appendMessage(sender, content) {
            const messageDiv = document.createElement('div');
            messageDiv.className = 'message ' + sender;

            if (sender === 'bot') {
                const headerHTML =
                    '<div class="d-flex align-items-center mb-2">' +
                    '<div class="rounded-circle bg-dark text-white d-flex align-items-center justify-content-center me-2" style="width: 28px; height: 28px;">' +
                    '<i class="fas fa-robot"></i>' +
                    '</div>' +
                    '<strong>Nutri Mate</strong>' +
                    '</div>';
                messageDiv.innerHTML = headerHTML + content;
            } else {
                messageDiv.innerHTML = content;
            }

            chatMessages.appendChild(messageDiv);
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }

        // Fetch response from backend
        async function fetchGeminiResponse(message) {
            console.log("Sending request to backend:", message);

            try {
                // Get the current URL path and construct the correct endpoint
                let contextPath = '';
                const pathParts = window.location.pathname.split('/');
                if (pathParts.length > 1 && pathParts[1] !== '') {
                    contextPath = '/' + pathParts[1];
                }

                const url =  '/chatbot';
                console.log("Sending request to URL:", url);

                const response = await fetch(url, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        message: message
                    })
                });

                console.log("Backend response status:", response.status);

                if (!response.ok) {
                    throw new Error('Backend returned status ' + response.status);
                }

                const data = await response.json();
                console.log("Response data:", data);

                if (data.error) {
                    throw new Error(data.error);
                }

                return data.response;
            } catch (error) {
                console.error("Error fetching chatbot response:", error);
                throw error;
            }
        }

        // Event listeners
        sendButton.addEventListener('click', sendMessage);

        userInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                sendMessage();
            }
        });

        // Focus input on page load
        userInput.focus();
    });
</script>
</body>
</html>